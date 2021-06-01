import argparse
import os
import sys
import linecache
import re
import subprocess
import clingo
from shutil import copyfile
#import tempfile
import timeit
import random
from pathlib import Path
from pandas import DataFrame
from file_names import *
import generate_examples
import structures


def print_exception():
	exc_type, exc_obj, tb = sys.exc_info()
	f = tb.tb_frame
	lineno = tb.tb_lineno
	filename = f.f_code.co_filename
	linecache.checkcache(filename)
	line = linecache.getline(filename, lineno, f.f_globals)
	print('EXCEPTION IN ({}, LINE {} "{}"): {}'.format(filename, lineno, line.strip(), exc_obj))


def remove_duplicates(file):
	seen = set()
	edit=[]
	for ln in file.split("\n"):
		#t = tuple(sorted(ln.split(' ')))
		if (ln not in seen) or (len(ln.split(' ')) < 3):
			edit.append(ln)
			seen.add(ln)
	return "\n".join(edit)

def remove_files(directory, temp_files):
	"""
	Clean directory from temp files
	"""
	try:
		for file in temp_files:
			if os.path.isfile(directory + file):
				os.remove(directory + file)
	except Exception:
		print_exception()
		sys.exit(3)

def clean_ABK(directory,n):
	"""
	Clean directory from temp files
	"""
	try:
		with open(directory + ACTIVE_BK, "r") as f:
			lines = "".join(f.readlines())
		with open(directory + ACTIVE_BK, "w") as f:
			f.write(re.sub(rf'%% Iteration n {n}.*?\Z', '', lines, flags=re.DOTALL))
	except Exception:
		print_exception()
		sys.exit(3)

def parse_examples(directory, file):
	with open(directory + file) as infile:
		lines = infile.readlines()
	return [re.findall(r'\{(.*?)\}', line) for line in lines if line != "\n"]

def cover(answer_set, listOfExamples):
	answer=False
	for e in listOfExamples:
		if set(e[0].split(', ')).issubset(answer_set) and not(set(e[1].split(', ')).intersection(answer_set)):
			answer=True
			break
	return answer

class App:
	def __init__(self, args):
		self.args = args
		if args.files is None or len(args.files) == 0:
			self.list_of_files = os.listdir(args.dir + S)
		else:
			self.list_of_files = args.files
		self.count_uncov_neg=0
		self.count_tot_AS =0
		self.count_lost_AS=0
		self.current_neg_examples=0	
		self.count_AS_with_constraints=0	
		if self.args.data:	
			self.stats={'directory':args.dir,\
						'files analysed with SBASS':" - ".join(self.list_of_files) ,\
						'learning mode':'Default' if (not args.sat) else 'Satisfiable' ,\
						'ordering':'Standard' if (not args.order) else 'Alternative' ,\
						'scalable examples':'nonScalable' if (not args.fullSBC) else 'Scalable' ,\
						'iteration': 0 if (not args.iter) else args.iter\
				}
		else:
			self.stats=None
		if self.args.csv:
			self.csv = self.args.csv
		else:
			self.csv = "Experiments.csv"


	def run(self):
		if self.args.order:
			structures.LEX_ORDER = 1
		else:
			structures.LEX_ORDER = 0
		if self.args.clean:
			remove_files(self.args.dir,[EXAMPLES_GEN, SMODELS_FILE, GENERATORS, SYMBOLIC_GENERATORS, POS_EXAMPLES_S, NEG_EXAMPLES_S, ILASP_INPUT,TEMP_PERMUTATION])
		else:
			# check if the input directory exists
			if not os.path.isdir(self.args.dir):
				print("{} is not a directory".format(self.args.dir)) 
				sys.exit(3)
			# if necessary, create general examples
			if not os.path.isfile(self.args.dir + EXAMPLES_GEN):
				self.create_ex_gen()
			# compute examples from SBASS analysis
			if (self.args.iter in ['2', '3']):
				clean_ABK(self.args.dir, self.args.iter)
			elif (self.args.iter in ['1', None]):
				clean_ABK(self.args.dir, "")
			examples_start_time = timeit.default_timer()
			if not self.args.ilp:
				self.create_ex_s()
			if self.args.data:
				self.stats['Time for creating examples'] = round(timeit.default_timer() - examples_start_time,3)
			# solve ILP task
			self.solve_ilp()
			if self.args.data:
				self.store_data()

	def store_data(self):
		df = DataFrame(data=self.stats, index={self.args.data})
		header=list(self.stats.keys())
		# create the csv file if it doesn't exist, defining the headers
		fileName=self.args.dir+self.csv
		if not os.path.isfile(fileName):
			df.to_csv(fileName, header=header)
		# otherwise, just append the new row
		else:
			df.to_csv(fileName, mode='a', header=False)

	def create_ex_gen(self):
		"""
		Create file EXAMPLES_GEN with general examples obtained from instances in GEN
		"""
		try:
			gen_examples=[]
			if self.args.verbose:
				print("Create general positive examples from: {}: ".format(self.args.dir + GEN))
			for file_name in os.listdir(self.args.dir + GEN):
				if self.args.verbose:
					print("  - " + file_name)
				id_example =  file_name.split('.')[0].replace("-","_")
				# extract context: i.e., program without comments
				with open(self.args.dir + GEN + file_name, 'r') as f:
					context = [line.strip() for line in f.readlines() if not line.startswith('%')] 
				# append example to gen_examples
				gen_examples.append("#pos(id0def_" + id_example[3:] + ",{},{},{" + " ".join(context) + "}).")
			
			# store general examples in EXAMPLES_GEN
			with open(self.args.dir + EXAMPLES_GEN, "w") as w:
				w.write("\n".join(gen_examples) + "\n")
		except Exception:
			print_exception()
			sys.exit(3)

	def create_ex_s(self):
		"""
		For each instance in S, 
			append new positive and negative examples
		"""
		try:
			sbass_input = [ASP_FILE_NAME, ACTIVE_BK]
			for file in sbass_input:
				if not os.path.isfile(self.args.dir + file):
					print("File missing: " + file)
					sys.exit(3)
			if self.args.verbose:
				print("Create examples from {}: ".format(self.args.dir + S))
			# remove files generated from previous run
			remove_files(self.args.dir,[NEG_EXAMPLES_S, POS_EXAMPLES_S])
				

			for instance in self.list_of_files:
				remove_files(self.args.dir,[GENERATORS])
				if not os.path.isfile(self.args.dir + S + instance):
					print("File missing: " + S + instance)
				else:
					if self.args.verbose:
						print("  - "+instance)
					# create ground program in smodels format
					process = subprocess.Popen(['gringo', '--output=smodels', self.args.dir + ASP_FILE_NAME, 
												self.args.dir + ACTIVE_BK, self.args.dir +S+ instance], 
												stdout=subprocess.PIPE, stderr=subprocess.DEVNULL)
					stdout, stderr = process.communicate()
					with open(self.args.dir + SMODELS_FILE, 'w') as f:
						f.write(remove_duplicates(stdout.decode('ascii')))

					# run SBASS and get the generators
					process = subprocess.Popen([SBASS, '--show'], stdin= open(self.args.dir + SMODELS_FILE),
												stdout=subprocess.DEVNULL, stderr=subprocess.PIPE)
					stdout, stderr = process.communicate()
					generators = stderr.decode('ascii')

					if len(generators) == 0:
						print("	No symmetries for {}".format(instance))
					elif generators[0]=="(":
						with open(self.args.dir + GENERATORS, 'w') as f:
							f.write(generators)
					else:
						print("Error from SBASS: {}".format(generators))
						sys.exit(3)
					# if SBASS detects symmetries for the instance, compute examples
					if os.path.isfile(self.args.dir + GENERATORS):
						generate_examples.main(self.args.dir, self.args.sat, self.args.fullSBC, instance)
		except Exception:
			print_exception()
			sys.exit(3)

	def solve_ilp(self):
		"""
		Run ILASP to solve ILP task defined
		"""
		try:
			
			all_SM = [file for file in os.listdir(self.args.dir) if file.startswith(ILASP_STEP)]
			if not self.args.iter or int(self.args.iter[0]) >= len(all_SM):
				ilasp_SM = all_SM
			else:
				iteration_num=int(self.args.iter[0])
				ilasp_SM = all_SM[0:(iteration_num)]
			if len(ilasp_SM) < 1:
				print("Define language bias: e.g., file {}1.lp".format(ILASP_STEP))
				sys.exit(3)
			ilasp_input = [ ILASP_BK, ACTIVE_BK, POS_EXAMPLES_S, EXAMPLES_GEN, NEG_EXAMPLES_S]
			for file in ilasp_input:
				if not os.path.isfile(self.args.dir + file):
					print("File missing: " + file)
					if self.args.data:
						self.stats['Time for solving ILP task'] = 0
						self.stats["Total AS"] = 0
						self.stats["Total neg examples"] = 0
						self.stats["Total pos examples"] = 0
						self.stats["Neg examples covered"] = 0
						self.stats["Lost answer set"] = 0
						for instance in self.list_of_files:
							with open(self.args.dir + S + instance, 'r') as f:
								context = [line.strip() for line in f.readlines() if not line.startswith('%')] 
								self.count_result(""," ".join(context),[])
						self.stats["Produced answer set"] = self.count_AS_with_constraints
						self.stats["Learned Constraints"] = ""
						self.store_data()
					sys.exit(3)
			if self.args.verbose:
				print("Run ILASP...")

			# append all contents of files in ilasp_input
			with open(self.args.dir + ILASP_INPUT, "w") as outfile:
				for filename in ilasp_SM:
					with open(self.args.dir + filename) as infile:
						contents = infile.readlines()
						outfile.writelines(contents)
				for filename in ilasp_input:
					with open(self.args.dir + filename) as infile:
						contents = infile.readlines()
						if self.args.random and filename in ilasp_input[2:]:
							random.shuffle(contents)
						outfile.writelines(contents)
				with open(PYLASP) as infile:
						contents = infile.readlines()
						outfile.writelines(contents)
			input_list= [ILASP,  self.args.dir + ILASP_INPUT]
			new_constraints = []
			if self.args.verbose:
				input_list.append("-d")

			#run ILASP
			popen = subprocess.Popen(input_list,stdout=subprocess.PIPE, stderr=subprocess.PIPE,universal_newlines=True)
			for stdout_line in iter(popen.stdout.readline, ""):
				if self.args.verbose:
					print(stdout_line.replace("\n",""))
				# constraint found
				if stdout_line.startswith(" :-"):
					new_constraints.append(stdout_line.replace(";",","))
				if stdout_line.startswith("%% Total"):
					time=stdout_line.split(":",1)[1]
					timevalue=re.findall("([0-9]+([.][0-9]+)?)", time)[0][0]
				if stdout_line.startswith("TIMEOUT"):
					timevalue="TO"
			popen.stdout.close()
			popen.wait()		
			if self.args.data:
				self.stats['Time for solving ILP task'] = timevalue

			# print constraints and decide whether to append them in ABK
			self.handle_ILASP_result(new_constraints)
			
		except Exception:
			print_exception()
			sys.exit(3)

	def handle_ILASP_result(self, new_constraints):
		if self.args.data:
			self.temp("".join(new_constraints))
			

		#if len(new_constraints) == 0:
		#	print("ILASP did not find new constraints")
		#else:
		#	print("Found new constraints: ")
		#	print("".join(new_constraints))
		
		with open(self.args.dir + ACTIVE_BK, "a") as f:
			f.write("%% Iteration n {}\n".format(self.args.iter))
			f.write("%% From files: {}\n".format(" - ".join(self.list_of_files)))
			f.write("".join(new_constraints)+"\n")
		if self.args.data:
			if not os.path.exists(self.args.dir + "/Learned_Constraints"):
				os.makedirs(self.args.dir + "/Learned_Constraints")
			copyfile(self.args.dir + ACTIVE_BK, self.args.dir + "/Learned_Constraints/{}_{}_{}_{}.lp".format(\
				self.args.data,self.stats['learning mode'],self.stats['ordering'],self.stats['scalable examples']))
			
	
	def temp(self, new_constraints):
		pos = parse_examples(self.args.dir, POS_EXAMPLES_S)
		neg = parse_examples(self.args.dir, NEG_EXAMPLES_S)
		contexts = set([e[2] for e in neg])
		contexts.update(set([e[2] for e in pos]))
		for c in contexts:
			self.count_result(new_constraints, c, [p for p in neg if p[2]==c])
		self.stats["Total AS"] = self.count_tot_AS
		self.stats["Total neg examples"] = len(neg)
		self.stats["Total pos examples"] = len(pos)
		self.stats["Neg examples covered"] = self.count_uncov_neg
		self.stats["Lost answer set"] = self.count_lost_AS
		self.stats["Produced answer set"] = self.count_AS_with_constraints
		self.stats["Learned Constraints"] = new_constraints


	def count_result(self, new_constraints, context, negExamples):
		ctl = clingo.Control()
		ctl.add("base", [], context +"\n" + new_constraints)
		files = [ self.args.dir + ASP_FILE_NAME, self.args.dir + ACTIVE_BK]
		for file in files:
			ctl.load(file)
		ctl.ground([("base", [])])
		ctl.configuration.solve.models="0"
		preserved_AS = 0
		with ctl.solve(yield_=True, async_=True) as handle:
			for model in handle:
				answer_set = set([str(atom) for atom in model.symbols(atoms=True)])
				self.count_AS_with_constraints += 1
				if cover(answer_set, negExamples):
						self.count_uncov_neg +=  1
				#elif cover(answer_set, posExamples):
				#		self.countP = self.countP + 1
				else:
						preserved_AS = preserved_AS + 1
		ctl2 = clingo.Control()
		ctl2.add("base", [], context)
		files = [ self.args.dir + ASP_FILE_NAME, self.args.dir + ACTIVE_BK]
		for file in files:
			ctl2.load(file)
		ctl2.ground([("base", [])])
		ctl2.configuration.solve.models="0"
		previous_count = self.count_tot_AS
		self.current_neg_examples=0
		ctl2.solve(on_model=lambda m: self.check_as_type(m,negExamples))
		tot_AS_instance = self.count_tot_AS -  previous_count
		self.count_lost_AS += (tot_AS_instance - self.current_neg_examples) \
							- preserved_AS 
		
	def check_as_type(self,m,negExamples):
		self.count_tot_AS=self.count_tot_AS+1
		answer_set = set([str(atom) for atom in m.symbols(atoms=True)])
		if cover(answer_set, negExamples):
			self.current_neg_examples = self.current_neg_examples + 1
		
			
parser = argparse.ArgumentParser(description="Lift SBC with ILP.", epilog="""Example: python main.py ./../Instance/Pigeon_Hole/ --files p3_h3.lp --iter=1 -v""")

parser.add_argument("dir", help="the directory with all the necessary files")
parser.add_argument("-v", "--verbose", action='store_true', help="print extra information")
parser.add_argument("-i", "--ilp", action='store_true', help="solve the ILP task without recomputing examples from S")
parser.add_argument("-c", "--clean", action='store_true', help="remove temp files")
parser.add_argument("-s", "--sat", action='store_true', help="sat mode")
parser.add_argument("-r", "--random", action='store_true', help="shuffle the examples")
parser.add_argument("-f", "--fullSBC", action='store_true', help="Learn full symmetry breaking constraints. By default, it uses the alternative ordering criterion. ")
parser.add_argument("-d", "--data",  type=int, help="Store learning data with id DATA")
parser.add_argument("-o", "--order", action='store_true', help="Use alternative order for atoms. \
																 E.g., a(X,_) > a(Y,_) if X < Y; a(X,Y) > a(X,Z) if Y > Z")
parser.add_argument("--files", nargs='*', help='List of files to analyse with SBASS.')
parser.add_argument('--iter', choices=[ '1', '2', '3', '1a', '2a', '3a'], help='Iterative step. With #a, the constraints learnt so far are kept.')
parser.add_argument('--csv',  nargs='?', default=None, help="file name of the csv file to store results")

args = parser.parse_args()

App(args).run() 






