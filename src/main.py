import argparse
import os
import sys
import linecache
import re
import subprocess
import clingo
from shutil import copyfile
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
	"""
	Remove redundant rules in SMODEL file (because of SBASS error) 
	"""
	seen = set()
	file_without_repetitions = []
	for ln in file.split("\n"):
		#t = tuple(sorted(ln.split(' ')))
		if (ln not in seen) or (len(ln.split(' ')) < 3):
			file_without_repetitions.append(ln)
			seen.add(ln)
	return "\n".join(file_without_repetitions)

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

def clean_ABK(directory, n):
	"""
	Remove constraints from ABK produced after iteration n
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
	with open(directory + file) as input_file:
		lines = input_file.readlines()
	return [re.findall(r'\{(.*?)\}', line) for line in lines if line != "\n"]

def cover(answer_set, list_of_examples):
	"""
	Check if an example in list_of_examples is covered by answer_set
	"""
	covered = False
	for ex in list_of_examples:
		incl = set(ex[0].split(', '))
		excl = set(ex[1].split(', '))
		if incl.issubset(answer_set) and not(excl.intersection(answer_set)):
			covered = True
			break
	return covered


class App:
	def __init__(self, args):
		self.args = args
		if args.files is None or len(args.files) == 0:
			self.list_of_files = os.listdir(args.dir + S)
		else:
			self.list_of_files = args.files
		self.count_uncov_neg = 0
		self.count_tot_AS = 0
		self.count_lost_AS = 0
		self.current_neg_examples = 0	
		self.count_AS_with_constraints = 0	
		
		if args.seed < 0:
			self.seed = str(round(random.random()*100000))
		else:
			self.seed = args.seed
		self.stats = {'Directory':args.dir,\
					'Files analysed with SBASS':" - ".join(self.list_of_files),\
					'Learning mode':'Enumerate' if (not args.sat) else 'Satisfiable',\
					'Ordering':'Standard' if ((args.order and args.fullSBC) or (not args.order and not args.fullSBC)) else 'Alternative',\
					'SBC':'Partial' if (not args.fullSBC) else 'Full',\
					'Iteration': 0 if (not args.iter) else args.iter,\
					'Cell': args.cell,\
					'Seed': self.seed,\
					'Version': 'DEFAULT' if (not args.ilasp4) else 'ILASP4'\
		}
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
			remove_files(self.args.dir, [EXAMPLES_GEN, SMODELS_FILE, GENERATORS, SYMBOLIC_GENERATORS, POS_EXAMPLES_S, NEG_EXAMPLES_S, ILASP_INPUT,TEMP_PERMUTATION])
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
				self.stats['Time for creating examples'] = \
					round(timeit.default_timer() - examples_start_time, 3)
			# solve ILP task
			self.solve_ilp()
			# store data
			if self.args.data:
				self.store_data()

	def store_data(self):
		df = DataFrame(data = self.stats, index = {self.args.data})
		header = list(self.stats.keys())
		# create the csv file if it doesn't exist, defining the headers
		csv_file = self.args.dir + self.csv
		if not os.path.isfile(csv_file):
			df.to_csv(csv_file, header = header)
		# otherwise, just append the new row
		else:
			df.to_csv(csv_file, mode = 'a', header = False)

	def create_ex_gen(self):
		"""
		Create file EXAMPLES_GEN with general examples obtained from instances in GEN
		"""
		try:
			gen_examples = []
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
				#gen_examples.append("#pos(id0def_" + id_example[3:] + ",{},{},{" + " ".join(context) + "}).")
				ctl = clingo.Control()
				ctl.add("base", [], " ".join(context) +"\n")
				ctl.load(self.args.dir + ASP_FILE_NAME)
				ctl.ground([("base", [])])
				ctl.configuration.solve.models = "0"
				with ctl.solve(async_=True) as handle:
					wait = handle.wait(5)
					handle.cancel()
				if (not wait):
					# apply custom conflict analysis
					gen_examples.append("#pos(id0gen_" + id_example[3:] + ",{},{},{" + " ".join(context) + "}).")
				else:
					gen_examples.append("#pos(id00gen_" + id_example[3:] + ",{},{},{" + " ".join(context) + "}).")
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
			if self.args.verbose:
				print("Create examples from {}: ".format(self.args.dir + S))
			# remove files generated from previous run
			remove_files(self.args.dir, [NEG_EXAMPLES_S, POS_EXAMPLES_S])
			
			for file in [ASP_FILE_NAME, ACTIVE_BK]:
				if not os.path.isfile(self.args.dir + file):
					print("File missing: " + file)
					sys.exit(3)

			for instance in self.list_of_files:
				remove_files(self.args.dir, [GENERATORS])
				if not os.path.isfile(self.args.dir + S + instance):
					print("File missing: " + S + instance)
				else:
					if self.args.verbose:
						print("  - " + instance)

					# create ground program in smodels format
					input_SBASS = ['gringo', '--output=smodels', 
						self.args.dir + ASP_FILE_NAME, self.args.dir + S + instance]
					if self.args.ABK:
						input_SBASS.append(self.args.dir + ACTIVE_BK)
					
					process = subprocess.Popen(input_SBASS, stdout = subprocess.PIPE, 
						stderr = subprocess.DEVNULL)
					stdout, stderr = process.communicate()
					with open(self.args.dir + SMODELS_FILE, 'w') as f:
						f.write(remove_duplicates(stdout.decode('ascii')))

					# run SBASS and get the generators
					process = subprocess.Popen([SBASS, '--show'], 
						stdin = open(self.args.dir + SMODELS_FILE),
						stdout = subprocess.DEVNULL, stderr = subprocess.PIPE)
					stdout, stderr = process.communicate()
					generators = stderr.decode('ascii')

					if len(generators) == 0:
						print("	No symmetries for {}".format(instance))
					elif generators[0] == "(":
						with open(self.args.dir + GENERATORS, 'w') as f:
							f.write(generators)
					else:
						print("Error from SBASS: {}".format(generators))
						sys.exit(3)

					# if SBASS detects symmetries for the instance, compute examples
					if os.path.isfile(self.args.dir + GENERATORS):
						generate_examples.main(self.args.dir, self.args.sat, self.args.fullSBC, instance, self.args.cell, self.args.maxsizecell, self.seed, self.args.ABK)
		except Exception:
			print_exception()
			sys.exit(3)

	def define_ilasp_input(self):
		"""
		define input file for ILASP
		"""
		all_SM = [file for file in os.listdir(self.args.dir) if file.startswith(ILASP_STEP)]
		if not self.args.iter or int(self.args.iter[0]) >= len(all_SM):
			ilasp_SM = all_SM
		else:
			iteration_num = int(self.args.iter[0])
			ilasp_SM = all_SM[0:(iteration_num)]
		if len(ilasp_SM) < 1:
			print("Define language bias: e.g., file {}1.lp".format(ILASP_STEP))
			sys.exit(3)
		ilasp_input = [ILASP_BK, ACTIVE_BK, POS_EXAMPLES_S, EXAMPLES_GEN,
			NEG_EXAMPLES_S]
		for file in ilasp_input:
			if not os.path.isfile(self.args.dir + file):
				print("File missing: " + file)
				if self.args.data:
					if not os.path.isfile(self.args.dir + POS_EXAMPLES_S):
						pos = []
					else:
						pos = parse_examples(self.args.dir, POS_EXAMPLES_S)
					if not os.path.isfile(self.args.dir + NEG_EXAMPLES_S):
						neg = []
					else:
						neg = parse_examples(self.args.dir, NEG_EXAMPLES_S)
					self.stats['Time for solving ILP task'] = 0
					#self.stats["Total AS"] = 0
					self.stats["Total neg examples"] = len(neg)
					self.stats["Total pos examples"] = len(pos)
					self.stats["Neg examples uncovered"] = len(neg)
					#self.stats["Lost answer set"] = 0
					#for instance in self.list_of_files:
					#	with open(self.args.dir + S + instance, 'r') as f:
					#		context = [line.strip() for line in f.readlines() if not line.startswith('%')] 
					#		self.count_result(""," ".join(context),[])
					#self.stats["Produced answer set"] = self.count_AS_with_constraints
					self.stats["Learned Constraints"] = ""
					self.store_data()
				sys.exit(3)

		# append all files to define ilasp_input
		with open(self.args.dir + ILASP_INPUT, "w") as outfile:
			for filename in (ilasp_SM + ilasp_input):
				with open(self.args.dir + filename) as infile:
					contents = infile.readlines()
					outfile.writelines(contents)
			if self.args.ilasp4:
				ilasp_script = ILASP4
			else:
				ilasp_script = DEFAULT
			with open(ilasp_script) as infile:
					contents = infile.readlines()
					if self.args.verbose:
						contents= [line.replace("##debug##","") for line in contents]
					outfile.writelines(contents)

	def solve_ilp(self):
		"""
		Run ILASP to solve ILP task defined
		"""
		if self.args.verbose:
				print("Run ILASP...")
		try:
			self.define_ilasp_input()
			if self.args.data:
				if not os.path.exists(self.args.dir + "/ILP_Task"):
					os.makedirs(self.args.dir + "/ILP_Task")
				copyfile(self.args.dir + ILASP_INPUT, self.args.dir + "/ILP_Task/ILASP_input_{}_{}_{}_{}_{}_{}_{}.lp".format(\
				self.args.data,self.stats['Learning mode'],self.stats['Ordering'],self.stats['SBC'],self.stats['Cell'],self.stats['Version'],self.stats['Seed']))
			input_list = [ILASP, '--clingo', CLINGOPATH ,self.args.dir + ILASP_INPUT]
			new_constraints = []
			
			popen = subprocess.Popen(input_list, stdout = subprocess.PIPE, 
				stderr = subprocess.PIPE, universal_newlines = True)
			timevalue = "TO"
			for stdout_line in iter(popen.stdout.readline, ""):
				if self.args.verbose:
					print(stdout_line.replace("\n",""))
				# constraint found
				if stdout_line.startswith(" :-"):
					new_constraints.append(stdout_line.replace(";",","))
				if stdout_line.startswith("%% Total"):
					time = stdout_line.split(":",1)[1]
					timevalue = re.findall("([0-9]+([.][0-9]+)?)", time)[0][0]
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
			self.get_statistics("".join(new_constraints))
			
		#if len(new_constraints) == 0:
		#	print("ILASP did not find new constraints")
		#else:
		#	print("Found new constraints: ")
		#	print("".join(new_constraints))
		
		with open(self.args.dir + ACTIVE_BK, "a") as f:
			f.write("%% Iteration n {}\n".format(self.args.iter))
			f.write("%% From files: {}\n".format(" - ".join(self.list_of_files)))
			f.write("".join(new_constraints) + "\n")
		if self.args.data:
			if not os.path.exists(self.args.dir + "/Learned_Constraints"):
				os.makedirs(self.args.dir + "/Learned_Constraints")
			copyfile(self.args.dir + ACTIVE_BK, self.args.dir + "/Learned_Constraints/{}_{}_{}_{}_{}_{}_{}.lp".format(\
				self.args.data,self.stats['Learning mode'],self.stats['Ordering'],self.stats['SBC'],self.stats['Cell'],self.stats['Version'],self.stats['Seed']))
	
	def get_statistics(self, new_constraints):
		pos = parse_examples(self.args.dir, POS_EXAMPLES_S)
		neg = parse_examples(self.args.dir, NEG_EXAMPLES_S)
		contexts = set([ex[2] for ex in neg])
		contexts.update(set([ex[2] for ex in pos]))
		for c in contexts:
			self.count_result(new_constraints, c, [ex for ex in neg if ex[2]==c])
		#self.stats["Total AS"] = self.count_tot_AS
		self.stats["Total neg examples"] = len(neg)
		self.stats["Total pos examples"] = len(pos)
		self.stats["Neg examples uncovered"] = self.count_uncov_neg
		#self.stats["Lost answer set"] = self.count_lost_AS
		#self.stats["Produced answer set"] = self.count_AS_with_constraints
		self.stats["Learned Constraints"] = new_constraints

	def count_result(self, new_constraints, context, neg_examples):
		ctl = clingo.Control()
		ctl.add("base", [], context +"\n" + new_constraints)
		files = [ self.args.dir + ASP_FILE_NAME, self.args.dir + ACTIVE_BK]
		for file in files:
			ctl.load(file)
		ctl.ground([("base", [])])
		ctl.configuration.solve.models = "0"
		preserved_AS = 0
		with ctl.solve(yield_=True, async_=True) as handle:
			for model in handle:
				answer_set = set([str(atom) for atom in model.symbols(atoms=True)])
				self.count_AS_with_constraints += 1
				if cover(answer_set, neg_examples):
						self.count_uncov_neg +=  1
				#elif cover(answer_set, posExamples):
				#		self.countP = self.countP + 1
				#else:
				#		preserved_AS = preserved_AS + 1
		#ctl2 = clingo.Control()
		#ctl2.add("base", [], context)
		#files = [ self.args.dir + ASP_FILE_NAME, self.args.dir + ACTIVE_BK]
		#for file in files:
		#	ctl2.load(file)
		#ctl2.ground([("base", [])])
		#ctl2.configuration.solve.models = "0"
		#previous_count = self.count_tot_AS
		#self.current_neg_examples = 0
		#ctl2.solve(on_model=lambda m: self.check_cover(m, neg_examples))
		#tot_AS_instance = self.count_tot_AS - previous_count
		#self.count_lost_AS += (tot_AS_instance - self.current_neg_examples) \
		#					- preserved_AS 
		
	def check_cover(self, model, neg_examples):
		self.count_tot_AS = self.count_tot_AS+1
		answer_set = set([str(atom) for atom in model.symbols(atoms=True)])
		if cover(answer_set, neg_examples):
			self.current_neg_examples = self.current_neg_examples+1
		
			
parser = argparse.ArgumentParser(description="Lift SBC with ILP.", epilog="""Example: python main.py ./../PUP/double/ -v --cell 1""")

parser.add_argument("dir", help="the directory with all the necessary files")
parser.add_argument("-v", "--verbose", action='store_true', help="print extra information")
parser.add_argument("-i", "--ilp", action='store_true', help="solve the ILP task without recomputing examples from S")
parser.add_argument("-c", "--clean", action='store_true', help="remove temp files")
parser.add_argument("-s", "--sat", action='store_true', help="sat mode")
parser.add_argument("-a", "--ABK", action='store_true', help="consider ABK with SBASS")
parser.add_argument("-f", "--fullSBC", action='store_true', help="Learn full symmetry breaking constraints. By default, it uses the alternative ordering criterion. ")
parser.add_argument("-d", "--data",  type=int, help="Store learning data with id DATA")
parser.add_argument("-o", "--order", action='store_true', help="Use alternative order for atoms. \
																 E.g., a(X,_) > a(Y,_) if X < Y; a(X,Y) > a(X,Z) if Y > Z")
parser.add_argument("--files", nargs='*', help='List of files to analyse with SBASS.')
parser.add_argument('--iter', choices=[ '1', '2', '3', '1a', '2a', '3a'], help='Iterative step. With #a, the constraints learnt so far are kept.')
parser.add_argument('--cell', type=int, help="Number of cells analysed",  default=0)
parser.add_argument('--maxsizecell', type=int, help="Max number of neg examples produced per cell",  default=100)
parser.add_argument('--csv',  nargs='?', default=None, help="file name of the csv file to store results")
parser.add_argument("--ilasp4", action='store_true', help="Run ILASP 4. By default, run version vio_sub")
parser.add_argument("--seed",type=int, help="Seed to use for computing answer sets",  default=-1)

args = parser.parse_args()
if CLINGOPATH == "":
	print("Please set you Clingo path in ./src/file_name.py")
else:
	App(args).run() 






