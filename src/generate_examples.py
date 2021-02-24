#!/usr/bin/env python3

import re
import sys
import subprocess
import itertools
import clingo
import collections
from file_names import *
from structures import *

DEFAULT_WEIGHT = 100
MAX_NUM = 100
TIMEOUT = 10

def transform_atom(atom):
	arguments = [clingo.Number(term) for term in atom.terms]
	return clingo.Function(atom.predicate, arguments)

def zip_with_scalar(interpretation, value):
	return [(transform_atom(atom), value) for atom in interpretation.sorted_atoms()]


class GenerateExample:
	def __init__(self, directory, sat_mode, instance):
		self.idAS = 1
		self.directory = directory
		self.sat_mode = sat_mode
		self.id_instance = instance.split('.')[0].replace("-","_")
		with open(self.directory + S + instance, 'r') as f:
			self.context = [line.strip() for line in f.readlines() if not line.startswith('%')] 
		self.all_generators = [] 									# Updated with the method: parse_smodels()
		self.atoms_in_all_generators = None							# Updated with the method: parse_smodels()
		self.min_as = None

	def parse_smodels(self):
		"""
		Translate the literals in the set of generators (stored in GENERATORS) into their symbolic representation.
		Store them in self.all_generators
		"""
		with open(self.directory + SMODELS_FILE, 'r') as smodels:
			file = smodels.read()
			start = re.search('\n0\n', file).span()[1]
			end = re.search('\n0\n',file[start:]).span()[0]
		# mapping from (smodels) literal to its symbolic representation
		mapping = [i.split() for i in file[start:start+end].splitlines()]

		with open(self.directory + GENERATORS, 'r') as g:
			lines =  g.read().splitlines()

		# create a list of irredundant generators, translated using mapping
		generators = [Generator(generator, mapping) for generator in [re.split('\(|\)|\n',line) for line in lines]]
		self.all_generators =[generator for generator in generators if generator.is_valid()]
		self.atoms_in_all_generators = Interpretation.union_list([gen.get_atoms() for gen in self.all_generators])
		
		# Print the generators in SYMBOLIC_GENERATORS
		with open(self.directory + SYMBOLIC_GENERATORS, "w") as f:
			f.write("\n".join([str(generator) for generator in self.all_generators]))


	def compute_examples(self, instance):
		"""
		Check which answer set is a positive or negative example
		"""
		# if sat mode: create only a general positive example
		if self.sat_mode:
			self.write_example("pos", Interpretation(set([])), Interpretation(set([])))

		ctl = clingo.Control()
		files = [ self.directory + ASP_FILE_NAME, self.directory + ACTIVE_BK, self.directory + S + instance]
		for file in files:
			ctl.load(file)
		ctl.ground([("base", [])])
		ctl.configuration.solve.models="0"
		with ctl.solve(yield_=True, async_=True) as handle:
			if handle.wait(TIMEOUT):
				for model in handle:
					answer_set= Interpretation([str(atom) for atom in model.symbols(atoms=True)])
					# set the current answer set as the minimal in its cell
					self.min_as  = answer_set.intersection(self.atoms_in_all_generators)
					seen = set([self.min_as])
					self.find_symmetric_as(self.min_as, seen)
					# stop searching for examples after find MAX_NUM answer sets
					if self.idAS > MAX_NUM:
						handle.cancel()
					# add the found answer sets as nogood, in order to search for other answer sets
					else:
						if not self.sat_mode:
							self.write_example("pos", self.min_as, self.atoms_in_all_generators.difference(self.min_as))
						for true_atoms in seen:
							false_atoms = self.atoms_in_all_generators.difference(true_atoms)
							model.context.add_nogood(zip_with_scalar(true_atoms, True) + zip_with_scalar(false_atoms, False))
			else:
				handle.cancel()

	def find_symmetric_as(self, start, visited): 
		queue = collections.deque([start])
		while self.idAS <= MAX_NUM and queue: 
			interpretation = queue.popleft()
			if interpretation < self.min_as:
				# interpretation is the new smallest answer set
				#	produce a negative example with the previous min_as
				self.write_example("neg", self.min_as, self.atoms_in_all_generators.difference(self.min_as))
				self.min_as = interpretation
			elif interpretation > self.min_as:
				# interpretation is bigger than min_as
				#	produce a negative example with interpretation
				self.write_example("neg", interpretation, self.atoms_in_all_generators.difference(interpretation))
			# identify new answer sets and analyse them
			new_interpretations = [gen.next_assignment(interpretation) for gen in self.all_generators]
			for i in new_interpretations: 
				if i not in visited: 
					visited.add(i) 
					queue.append(i) 

	def write_example(self, type, inclusions, exclusions):
		if type == "pos":
			weight = ""
			file_name = POS_EXAMPLES_S
		else:
			weight = "@" + str(DEFAULT_WEIGHT)
			file_name = NEG_EXAMPLES_S

		head = "#{}(id{}_{}{}".format(type, self.idAS, self.id_instance, weight)
		body = "{" + str(inclusions) + "}, {" + str(exclusions)  + "}, {" + " ".join(self.context) + "}). "
		self.idAS += 1
		with open(self.directory + file_name, "a") as f:
			f.write(head + ", " + body + "\n")
"""
# MAIN
"""
def main(directory, sat_mode, instance):
	my_generator = GenerateExample(directory, sat_mode, instance)

	my_generator.parse_smodels()
	my_generator.compute_examples(instance)

