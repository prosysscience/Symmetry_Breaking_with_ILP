import os
# -----------------------------------------------------------------------------------------------------------
#	Input files/directories
# -----------------------------------------------------------------------------------------------------------
# Clingo path
CLINGOPATH = ""

# ASP file for checking if the atom assignment is dominated (used with TEMP_PERMUTATION 
# and PERMUTATION_RANGE)
CHECK_ASSIGNMENT=os.path.dirname(__file__) + "/permutations.lp"

# Program for detect the symmetries: SBASS
SBASS= os.path.dirname(__file__) + "/SBASS/sbass"

# Program for solving the ILP task: ILASP
ILASP=os.path.dirname(__file__)+"/ILASP4.2/ILASP"

# ILASP scripts
DEFAULT=os.path.dirname(__file__)+"/vio_sub.py"
ILASP4=os.path.dirname(__file__)+"/ilasp4.py"

# Directory with instances that define the general positive examples 
GEN="/Gen/"

# Directory with instances analysed with SBASS 
S="/S/"

# Non-ground ASP program in input
ASP_FILE_NAME="/input.lp"

# ASP file with the learned constraints and auxiliary predicates
ACTIVE_BK="/active_BK.lp"

# ILASP background knowledge
ILASP_BK="/ILASP_BK.lp"

# ILASP language bias (missing number and format)
ILASP_STEP="ILASP_iterative_step_"

# -----------------------------------------------------------------------------------------------------------
#	Temp files
# -----------------------------------------------------------------------------------------------------------

# Output file that contains the general positive examples, computed from the instances in GEN
EXAMPLES_GEN="/examples_gen.lp"

# ground ASP program in smodels format, from ASP_FILE_NAME, ACTIVE_BK, and the current instance in S
SMODELS_FILE="/smodels.gnd"

# file with the set of generators found by SBASS for SMODELS_FILE
GENERATORS="/generators.txt"

# Output file with the considered generators, translated in atoms
SYMBOLIC_GENERATORS="/generators_translated.txt"

# ASP file with all the permutations considered GENERATORS
TEMP_PERMUTATION="/permutation_input.lp"

# Output file that contains positive examples for all the instances in S
POS_EXAMPLES_S="/examples_S_pos.lp"

# Output file that contains negative examples for all the instances in S
NEG_EXAMPLES_S="/examples_S_neg.lp"

# ILASP input: ILASP_BK + ACTIVE_BK + all selected ILASP_STEP +POS_EXAMPLES_S + EXAMPLES_GEN + NEG_EXAMPLES_S
ILASP_INPUT="/ILASP_input.lp"
