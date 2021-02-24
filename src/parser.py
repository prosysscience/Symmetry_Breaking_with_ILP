#!/usr/bin/env python3

import re
import sys
import subprocess
import itertools
from collections import deque
from file_names import *


def intTerms(atom):	
	"""
	When sorting the atoms, consider the integer value of the terms
	"""	
	terms = re.search('\((.*)\)', atom)
	if terms is None: 
		return int(atom)
	else:
		return [int(term) for term in re.findall('(\d+)',terms.group(1))]

class MyParser:
	def __init__(self, directory, learnSatisfiability, instance):
		self.directory = directory
		self.learnSatisfiability = learnSatisfiability
		self.id = instance.replace("-","_")
		with open(self.directory+S+instance+".lp", 'r') as file:
			self.context  = file.read().replace('\n', '')
		self.allGenerators = [] 									# Updated with the method: translateAtoms
		self.atomsInGenerator = []  								# Updated with the method: writeInputPermutation
		with open(self.directory + ALL_AS_FILE, 'r') as g:
				file = g.read()	
				start = re.search('Solving...\n', file).span()[1]
				end = re.search('SATISFIABLE',file[start:]).span()[0]
		self.allAS = [set(i.split()) for i in file[start:start+end].splitlines() if not re.search('Answer', i)]
		self.positiveAS = [True] * len(self.allAS)					# Updated with the method: computeExamples
		self.occurrenceAsNegEx = [0] * len(self.allAS)				# Updated with the method: createNegativeExample
		self.clusterId = [] 										# Updated with the method: findClusters

	def parseSmodels(self):
		"""
		Create a list with the mapping from (numeric) literals to their string representation
		
		Returns:
			list -- ['num literal', 'translated literal']
		"""
		with open(self.directory + SMODELS_FILE, 'r') as o:
			file = o.read()
			start = re.search('\n0\n', file).span()[1]
			end = re.search('\n0\n',file[start:]).span()[0]
		return  [i.split() for i in file[start:start+end].splitlines()]

	def translateAtoms(self, mapping):
		"""
		 Translate and order all the atoms in the generators using the values in "mapping". 
		 	from `GENERATORS_FILE`: 
		 		- identify all the `nonTranslatableAtoms`
				- replace all the numeric literals with their string representations
				- remove the `nonTranslatableAtoms` and store the result in the attribute `allGenerators` 
				- Reorder each single cycle lexicographically (from bigger to smaller)
				- Print the generators in `OUT_GENERATORS_FILE`
		"""
		literals = [i[0] for i in mapping]
		nonTranslatableAtoms= set([])
		with open(self.directory + GENERATORS_FILE, 'r') as g:
			file = g.read()	
			lines =  file.splitlines()
		allGen = [re.split('\(|\)|\n',line) for line in lines]
		allGen = [[cycle.split() for cycle in generator if cycle != ""] for generator in allGen]
		# nontran = [element for generator in allGen for cycle in generator for element in cycle if element not in literals]
		for idGen in range(len(allGen)):
			for idCycle in range(len(allGen[idGen])):
				for idAtom in range(len(allGen[idGen][idCycle])):
					if allGen[idGen][idCycle][idAtom] in literals:
						index = literals.index(allGen[idGen][idCycle][idAtom])
						allGen[idGen][idCycle][idAtom] = allGen[idGen][idCycle][idAtom].replace(mapping[index][0],mapping[index][1])
					else:
						nonTranslatableAtoms.add(allGen[idGen][idCycle][idAtom])

		# Identify permutations where a non-translatable atom and a translatable atom appear in the same cycle
		discardedGen = [[idGen for cycle in generator if ((set(cycle) & nonTranslatableAtoms) and bool((set(cycle).difference(nonTranslatableAtoms))))] for idGen, generator in enumerate(allGen)]
		setOfDiscardedGen = set().union(*discardedGen)
		# Remove the cycles containing nonTranslatableAtoms and generators in setOfDiscardedGen
		allGeneratorsTranslated = [[cycle for cycle in generator if not set(cycle) & nonTranslatableAtoms] for idGen, generator in enumerate(allGen) if idGen not in setOfDiscardedGen]
		# Remove empty generators
		self.allGenerators =[g for g in allGeneratorsTranslated if g]
		
		# Reorder lexicographically the atoms in each cycle
		[cycle.sort(key=intTerms, reverse=True) for generator in self.allGenerators for cycle in generator] 	

		# Print the generators in OUT_GENERATORS_FILE
		with open(self.directory + OUT_GENERATORS_FILE, "w") as f:
			f.write("\n".join(("[{}]".format(", ".join(generator)) for generator in 
				(["[{}]".format(", ".join(cycle)) for cycle in generator] for generator in self.allGenerators)
			)))

	def writeInputPermutation(self):
		"""
		Create the file to compute the permutations: TEMP_ASP_ALL_SYM. 
		Update the attribute `atomsInGenerator` --> 
			after this methods, the element `atomsInGenerator`[i] contains the atoms considered in the i-th generator
		"""
		permutations = []
		for idGen, generator in enumerate(self.allGenerators):
			atoms = set([atom for cycle in generator for atom in cycle])
			self.atomsInGenerator.append(atoms) 
			# Order the atoms lexicographically
			atomsList = list(atoms)
			atomsList.sort(key=intTerms,reverse=True)
			"""
			Following the lexicographical order of all the atoms in the current generator, define:
				"permute(idPermutation, atom2, atom1, 0)."
				where atom1 is shifted to atom2 and atom1 is not the last atom in the cycle
			"""
			for atom in atomsList:
				for cycle in generator:
					if atom in cycle:
						index = cycle.index(atom)
						if index != len(cycle)-1:
							permutations.append("permute(" + str(idGen+1) +","+ cycle[index-1 % len(cycle)]+","+atom+ ",0).")
						break

		with open(self.directory + TEMP_ASP_ALL_SYM, "w") as f:
			f.write("\n".join(permutations))

	def findClusters(self):
		"""
		Compute the clusters of generators
		"""
		
		self.clusterId = [-1] * len(self.allGenerators)				
		sortedList=sorted([(len(self.atomsInGenerator[i]),i) for i in range(len(self.atomsInGenerator))])
		q=deque([generator for nAtoms,generator in sortedList])
		idCluster=0
		while q:
			idGen=q.pop()
			self.clusterId[idGen]=idCluster
			currentAtoms=self.atomsInGenerator[idGen]
			newAtoms=currentAtoms
			while newAtoms:
				currentAtoms=currentAtoms.union(newAtoms)
				newAtoms=set([])
				for i in range(len(self.allGenerators)):
					if self.clusterId[i]==-1 and bool(currentAtoms.intersection(self.atomsInGenerator[i])):
						newAtoms=newAtoms.union(currentAtoms.intersection(self.atomsInGenerator[i]))
						self.clusterId[i]=idCluster
						q.remove(i)		
			idCluster=idCluster+1
			

	def computeExamples(self):
		"""
		For each generators cluster, 
			check which answer set doesn't lead to UNSATISFIABLE: i.e. it is a non-symmetric assignments
		"""
		clustersNames=set(self.clusterId)
		for num in clustersNames:
			noSymAS = [False] * len(self.allAS)
			for idansw, answ in enumerate(self.allAS):
				currentGeneratorsAtoms=[gen for gen in [gen for (gen,cluster) in  enumerate(self.clusterId)  if cluster == num]]
				atoms=set([])
				for gen in currentGeneratorsAtoms:
					atoms = atoms.union(self.atomsInGenerator[gen])
				listOfAtoms=list(atoms)
				s=" ".join(["assign({},1).".format(atom) for atom in answ if atom in listOfAtoms])
				s1=" ".join(["assign({},0).".format(atom) for atom in listOfAtoms if atom not in answ])
				with open(self.directory + PERMUTATION_RANGE, 'w') as h:
					h.write("permutation("+ ";".join([str(gen+1) for (gen,cluster) in enumerate(self.clusterId) if cluster == num])+").")
					h.write(s)
					h.write(s1)
				# Compute the non symmetric assignments according to the current permutation
				with open(self.directory + OUT_SYM_FILE, 'w') as f:
					process = subprocess.Popen(['clingo', ASP_ALL_SYM, self.directory + TEMP_ASP_ALL_SYM, self.directory + PERMUTATION_RANGE],
												stdout=f, stderr=subprocess.PIPE)
					process.wait()
				with open(self.directory + OUT_SYM_FILE, 'r') as g:
					file = g.read()	
					noSymAS[idansw] = re.search('UNSATISFIABLE', file) is None
			for AS in range(len(noSymAS)):
				self.positiveAS[AS] = self.positiveAS[AS] and noSymAS[AS]
			self.writeCurrentNegativeExamples(noSymAS,num)




	def writeCurrentNegativeExamples(self, noSymForCurrentPermutation, currentCluster):
		"""
			Create the negative examples and write them in `TEMP_EXAMPLES_FILE`
		 	project in the inclusion and exclusion only over the atoms considered. 
		"""	
		currentGenerators=[gen for gen in [gen for (gen,cluster) in  enumerate(self.clusterId)  if cluster == currentCluster]]
		atoms=set([])
		for gen in currentGenerators:
			atoms = atoms.union(self.atomsInGenerator[gen])

		negative = [self.createNegativeExample(str(ind+1)+"_C"+str(currentCluster), AS, atoms, ind) for ind, AS in enumerate(self.allAS) if not noSymForCurrentPermutation[ind]]

		with open(self.directory + TEMP_EXAMPLES_FILE, "a") as f:
			f.write("".join(negative))

	def createNegativeExample(self, idExample, AS, atoms, index):	
		""" 
		Generate a negative example according to ILASP syntax (with weight)

		Returns: 
			string -- a negative example
		"""
		self.occurrenceAsNegEx[index] = self.occurrenceAsNegEx[index]+1
		head = "#neg(id"+ idExample+ "_"+ self.id+ "@100"
		body = ", ".join(atoms.intersection(AS)) + "}, {" + ", ".join(atoms.difference(AS))  + "}, {" +self.context
		return head + ", {" + body +"}).\n"

	def writeNegativeExamples(self):
		"""
		 Append the negative examples. 
		 For the negative example define the penalty according to the number of generators that consider the answer set as negative
		"""
		with open(self.directory + NEG_EXAMPLES_FILE, "a") as f:
			with open(self.directory + TEMP_EXAMPLES_FILE) as temp:
				for line in temp:
					index = re.findall('\d+', line)
					f.write(line.replace("@100", "@"+str(round(100/self.occurrenceAsNegEx[int(index[0])-1]))))

	def writePositiveExample(self,file):
		"""
		Print the positive examples to a file.

		if `learnSatisfiability` is `True` then write a general positive example.
		Otherwise write a positive example for each answer set in `positiveAS` and project 
		all its atoms in the inclusions and exclusions
		"""		
		if self.learnSatisfiability:
			#produce just one positive example with empty inclusion and exclusion sets.
			positive = [self.createPositiveExample(str(0), set([]))]
		else:
			positive = [self.createPositiveExample(str(ind+1), AS) for ind, AS in enumerate(self.allAS) if self.positiveAS[ind]]

		with open(self.directory + file, "a") as f:
			f.write("".join(positive))

	def createPositiveExample(self, ind, AS):
		"""
		Returns:
			string -- representing a positive example according to ILASP syntax
		"""
		head = "#pos(id"+ ind+ "_"+ self.id
		body =  ", ".join(AS) + "}, {" + ", ".join(set([]))  + "}, {" + self.context
		return head + ", {" + body +"}).\n"


"""
# MAIN
"""
if __name__ == "__main__":
	directory = sys.argv[1]
	instance = sys.argv[2]
	learnSatisfiability = False  if "Def" in sys.argv[3] else True
	open(directory + TEMP_EXAMPLES_FILE, 'w').close()

	parser = MyParser(directory, learnSatisfiability, instance)

	mapping = parser.parseSmodels()
	parser.translateAtoms(mapping)
	parser.writeInputPermutation()
	parser.findClusters()
	parser.computeExamples()
	parser.writeNegativeExamples()
	parser.writePositiveExample(POS_EXAMPLES_FILE)

