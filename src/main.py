import argparse
import os
import sys
import linecache
import re
import subprocess
import tempfile
import timeit
import random
from pathlib import Path
from file_names import *
import generate_examples


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

class App:
	def __init__(self, args):
		self.args = args
		self.examples_start_time = timeit.default_timer()
		self.learning_start_time = None

	def run(self):
		if self.args.clean:
			self.clean_directory([EXAMPLES_GEN, SMODELS_FILE, GENERATORS, SYMBOLIC_GENERATORS, POS_EXAMPLES_S, NEG_EXAMPLES_S, ILASP_INPUT])
		else:
			# check if the input directory exists
			if not os.path.isdir(self.args.dir):
				print("{} is not a directory".format(self.args.dir)) 
				sys.exit(3)
			# if necessary, create general examples
			if not os.path.isfile(self.args.dir + EXAMPLES_GEN):
				self.create_ex_gen()
			# compute examples from SBASS analysis 
			if not self.args.ilp:
				self.create_ex_s()
				if self.args.time:
					print('Time for creating examples: ', timeit.default_timer() - self.examples_start_time)
			# solve ILP task
			self.solve_ilp()
	
	def clean_directory(self, temp_files):
		"""
		Clean directory from temp files
		"""
		try:
			for file in temp_files:
				if os.path.isfile(self.args.dir + file):
					os.remove(self.args.dir + file)
		except OSError:
			pass

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
				gen_examples.append("#pos(gen_0_" + id_example + ",{},{},{" + " ".join(context) + "}).")
			
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
			self.clean_directory([NEG_EXAMPLES_S, POS_EXAMPLES_S, GENERATORS])
				
			for instance in os.listdir(self.args.dir + S):
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
					generate_examples.main(self.args.dir, self.args.sat, instance)
		except Exception:
			print_exception()
			sys.exit(3)

	def solve_ilp(self):
		"""
		Run ILASP to solve ILP task defined
		"""
		try:
			ilasp_input = [ILASP_NO_EX, ACTIVE_BK, EXAMPLES_GEN, POS_EXAMPLES_S, NEG_EXAMPLES_S]
			for file in ilasp_input[:-2]:
				if not os.path.isfile(self.args.dir + file):
					print("File missing: " + file)
					sys.exit(3)
			for file in ilasp_input[-2:]:
				if not os.path.isfile(self.args.dir + file):
					print("The instances in {} produced no {}".format(self.args.dir + S, file))
					sys.exit(3)
			if self.args.verbose:
				print("Run ILASP...")
			self.learning_start_time = timeit.default_timer()

			# append all contents of files in ilasp_input
			with open(self.args.dir + ILASP_INPUT, "w") as outfile:
				for filename in ilasp_input:
					with open(self.args.dir + filename) as infile:
						contents = infile.readlines()
						if self.args.random and filename in ilasp_input[2:]:
							random.shuffle(contents)
						outfile.writelines(contents)
			input_list= [ILASP, '--version=4', self.args.dir + ILASP_INPUT]
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
			popen.stdout.close()
			popen.wait()		
			if self.args.time:
				print('Time for solving ILP task: ', timeit.default_timer() - self.learning_start_time)
			# print constraints and decide whether to append them in ABK
			self.handle_ILASP_result(new_constraints)
			
		except Exception:
			print_exception()
			sys.exit(3)

	def handle_ILASP_result(self, new_constraints):
		if len(new_constraints) == 0:
			print("ILASP did not find new constraints")
		else:
			print("Found new constraints: ")
			print("".join(new_constraints))
			while True:
				answer = input("Update the ABK with the new constraints? [Y/N] ")
				if answer == "Y" or answer == "y":
					with open(self.args.dir + ACTIVE_BK, "a") as f:
						f.write("".join(new_constraints)+"\n")
					break
				elif answer == "N" or answer == "n":
					break
				else:
					print("Please answer yes [Y|y] or [N|n] ")


parser = argparse.ArgumentParser(description="Lift SBC with ILP.", epilog="""Example: python main.py ./../Instance/Pigeon_Hole""")

parser.add_argument("dir", help="the directory with all the necessary files")
parser.add_argument("-v", "--verbose", action='store_true', help="print extra information")
parser.add_argument("-t", "--time", action='store_true', help="print running-time")
parser.add_argument("-i", "--ilp", action='store_true', help="solve the ILP task without recomputing examples from S")
parser.add_argument("-c", "--clean", action='store_true', help="remove temp files")
parser.add_argument("-s", "--sat", action='store_true', help="sat mode")
parser.add_argument("-r", "--random", action='store_true', help="shuffle the examples")
args = parser.parse_args()

App(args).run() 






