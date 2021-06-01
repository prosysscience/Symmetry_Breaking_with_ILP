#!/usr/bin/env python3

import re
import clingo
import collections
from file_names import *
from structures import *

DEFAULT_WEIGHT = 100

def transform_atom(atom):
	arguments = [clingo.Number(term) for term in atom.terms]
	return clingo.Function(atom.predicate, arguments)

def zip_with_scalar(interpretation, value):
	return [(transform_atom(atom), value) for atom in interpretation.sorted_atoms()]


class GenerateExample:
	def __init__(self, directory, sat_mode, fullSBC, instance):
		if sat_mode:
			self.idAS = 0
		else:
			self.idAS = 1
		self.directory = directory
		self.sat_mode = sat_mode
		self.fullSBC = fullSBC
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
		
		return len(self.all_generators) > 0

	def write_input_permutations(self):
		"""
		Create the file to compute the permutations: TEMP_PERMUTATION. 
		"""
		permutations = ["permutation(1.."+ str(len(self.all_generators)) + ")."]
		for id_gen, generator in enumerate(self.all_generators):
			atoms = generator.get_atoms().sorted_atoms()
			index_atoms = []
			for atom in atoms:
				next = generator.next_var(atom)
				if next is not None:
					permutations.append("permute(" + str(id_gen+1) + "," + str(atom) + "," + str(next) + ",0).")
					index_atoms.append(next)
			for id_atom, atom in enumerate(Interpretation(set(index_atoms)).sorted_atoms()):
					permutations.append("index(" + str(id_gen+1) + "," + str(atom) + "," + str(id_atom+1) + ").")

		with open(self.directory + TEMP_PERMUTATION, "w") as f:
			f.write("\n".join(permutations))

	def compute_examples(self, instance):
		"""
		Check which answer set is a positive or negative example
		"""
		# if sat mode: create only a general positive example
		if self.sat_mode:
			self.write_example("pos", Interpretation(set([])), Interpretation(set([])))
			self.idAS += 1

		ctl = clingo.Control()
		files = [ self.directory + ASP_FILE_NAME, self.directory + ACTIVE_BK, self.directory + S + instance]
		for file in files:
			ctl.load(file)
		ctl.ground([("base", [])])
		ctl.configuration.solve.models="0"
		with ctl.solve(yield_=True, async_=True) as handle:
				for model in handle:
					answer_set= Interpretation([str(atom) for atom in model.symbols(atoms=True)])
					if self.fullSBC:
						# set the current answer set as the minimal in its cell
						self.min_as  = answer_set.intersection(self.atoms_in_all_generators)
						seen = set([self.min_as])
						self.find_symmetric_as(self.min_as, seen)
						if not self.sat_mode:
							self.write_example("pos", self.min_as, self.atoms_in_all_generators.difference(self.min_as))
						for true_atoms in seen:
							false_atoms = self.atoms_in_all_generators.difference(true_atoms)
							model.context.add_nogood(zip_with_scalar(true_atoms, True) + zip_with_scalar(false_atoms, False))
					else:
						self.check_as_SBC(answer_set)


	def find_symmetric_as(self, start, visited): 
		queue = collections.deque([start])
		while  queue: 
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
			new_interpretations = [gen.next_assignment(interpretation) for gen in self.all_generators]
			for i in new_interpretations: 
				if i not in visited: 
					visited.add(i) 
					queue.append(i) 

	def check_as_SBC(self,answer_set):
		false=self.atoms_in_all_generators.difference(answer_set)
		s=" ".join(["assign({},1).".format(atom) for atom in answer_set.sorted_atoms()]) + " ".join(["assign({},0).".format(atom) for atom in false.sorted_atoms()])
		ctl2 = clingo.Control()
		ctl2.add("base", [], s)
		ctl2.load(CHECK_ASSIGNMENT)
		ctl2.load(self.directory + TEMP_PERMUTATION)
		ctl2.ground([("base", [])])
		dom_generators=[]
		with ctl2.solve(yield_=True) as handle:
			for model in handle:
				dom_generators= [str(atom.arguments[0]) for atom in model.symbols(shown=True)]
		if len(dom_generators) > 0:
			#current_atoms = Interpretation(set([])).union_list([self.all_generators[int(g)-1].get_atoms() for g in dom_generators])
			current_atoms = self.atoms_in_all_generators
			inclusions = answer_set.intersection(current_atoms)
			exclusions = current_atoms.difference(answer_set)
			self.write_example("neg", inclusions, exclusions)
		else:
			if not self.sat_mode:
				#self.write_example("pos", answer_set.intersection(self.atoms_in_all_generators), Interpretation(set([])))
				self.write_example("pos", answer_set.intersection(self.atoms_in_all_generators), false)


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
def main(directory, sat_mode, fullSBC, instance):
	my_generator = GenerateExample(directory, sat_mode, fullSBC, instance)

	if my_generator.parse_smodels():
		if not fullSBC: 
			my_generator.write_input_permutations()
		my_generator.compute_examples(instance)
	else:
		print("	No symmetries for {} - empty generators".format(instance))

