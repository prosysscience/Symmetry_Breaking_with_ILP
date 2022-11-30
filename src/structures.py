#!/usr/bin/env python3

import re

LEX_ORDER=0

def check(i,j):
	if i > j:
		return 1
	elif i == j:
		return 0
	else:
		return -1


####################################################################################
class Atom:
	def __init__(self, atom):
		self.predicate = atom.split('(')[0]
		terms = re.search('\((.*)\)', atom)
		if terms is None: 
			self.terms = []
		else:
			self.terms=[int(term) for term in re.findall('(\d+)', terms.group(1))]
		self.arity = len(self.terms)

	def __str__(self):
		return f'{self.predicate}({",".join((str(x) for x in self.terms))})'
	
	def __repr__(self):
		return f'{self.predicate}({",".join((str(x) for x in self.terms))})'

	def __hash__(self):
		return hash((self.predicate, self.arity, ",".join((str(x) for x in self.terms))))

	def __lt__(self, other):
		if self.predicate != other.predicate:
			return self.predicate < other.predicate
		elif self.arity != other.arity:
			return self.arity < other.arity
		else:
			sign=[check(i,j) for i, j in zip(self.terms, other.terms)]
			if LEX_ORDER == 0:
				elem=[i for i in sign if i != 0]
				if (len(elem) == 0):
					return False
				else:
					return elem[0] == -1
			else:
				elem=[i for i in sign[:-1] if i != 0]
				if (len(elem) == 0):
					return sign[-1] == -1
				else:
					return elem[0] == 1


	def __eq__(self, other):
		sign=[check(i,j) for i, j in zip(self.terms, other.terms) if check(i,j) != 0]
		return (self.predicate == other.predicate) and (self.arity == other.arity) and (len(sign) == 0)

####################################################################################
class Interpretation:
	@classmethod
	def union_list(cls, other_interpretations): 
		if len(other_interpretations) == 0:
			return cls(set([]))
		else:
			list_atoms = [interpretation.atoms for interpretation in other_interpretations]
			all_atoms = set.union(*list_atoms)
			return cls(all_atoms)

	def __init__(self, atoms):
		self.mixed=False
		if type(atoms) is list:
			self.atoms=set([Atom(a) for a in atoms])
		elif type(atoms) is set:
			self.atoms=atoms
		else:
			non_symbolic_literals, mapping = atoms
			literals = [i[0] for i in mapping]
			self.ordered= [ Atom(mapping[literals.index(l)][1]) for l in non_symbolic_literals.split() if l in literals]
			self.atoms=set(self.ordered)
			self.mixed=(set(non_symbolic_literals.split()) & set(literals)) and bool((set(non_symbolic_literals.split()).difference(set(literals))))

	def __str__(self):
		return f'{", ".join((str(x) for x in sorted(self.atoms)))}'

	def __repr__(self):
		return f'{", ".join((str(x) for x in sorted(self.atoms)))}'
	
	def __len__(self):
		return len(self.atoms)

	def __lt__(self, other):
		sign=[check(i,j) for i, j in zip(sorted(self.atoms), sorted(other.atoms)) if check(i,j) != 0]
		if len(sign) == 0:
			return False
		else:
			return sign[0] == -1

	def __eq__(self, other):
		return sorted(self.atoms) ==sorted(other.atoms)

	def __hash__(self):
		return hash(repr(self))

	def intersection(self, other):
		return Interpretation(self.atoms.intersection(other.atoms))

	def union(self, other):
		return Interpretation(self.atoms.union(other.atoms))

	def difference(self, other):
		difference = [a for a in self.sorted_atoms() if not other.contains(a)]
		return Interpretation(set(difference))
	
	def contains(self, atom):
		return atom in self.atoms 
	
	def sorted_atoms(self):
		return sorted(self.atoms)

	def cycle_order(self):
		min_atom = min(self.ordered)
		index_min_atom = self.ordered.index(min_atom)
		return (self.ordered[index_min_atom:]+ self.ordered[:index_min_atom])

	def print_facts(self):
		return f'{" ".join((str(x)+"." for x in self.atoms))}'

	def print_cycle(self):
		return f'[{" ".join((str(x) for x in self.cycle_order()))}]'

		
####################################################################################
class Generator:
	def __init__(self, cycles, mapping):
		translated_cycles=[Interpretation((c, mapping)) for c in cycles if len(c)>0]
		# if there is a mixed cycle, the generator can't be used
		self.discard_generator = len([c for c in translated_cycles if c.mixed]) > 0
		self.cycles = [c for c in translated_cycles if len(c)>0]
		self.all_atoms = Interpretation.union_list(self.cycles)

	def __str__(self):
		return f'[{",".join((c.print_cycle() for c in self.cycles))}]'

	def __repr__(self):
		return f'[{",".join((c.print_cycle() for c in self.cycles))}]'

	def __len__(self):
		return len(self.cycles)

	def get_atoms(self):
		return self.all_atoms
	
	def is_valid(self):
		return not self.discard_generator
	
	def next_var(self, atom):
		atoms_in_cycle = [c for c in self.cycles if c.contains(atom)]
		if len(atoms_in_cycle) > 0:
			# for group properties, at most one cycle will contain atom
			sorted_atoms = atoms_in_cycle[0].cycle_order()
			for cur, nxt in zip (sorted_atoms, sorted_atoms [1:] + [sorted_atoms[0]]):
				if cur == atom:
					return nxt
		return None
	
	def next_assignment(self, interpretation):
		new_interpretation=[]
		
		for atom in interpretation.sorted_atoms():
			next=self.next_var(atom)
			if next is None:
				# the current generator doesn't map atom
				new_interpretation.append(atom)
			else:
				# return the shifted atom
				new_interpretation.append(next)
		
		return Interpretation(set(new_interpretation))


####################################################################################

