import os
# -----------------------------------------------------------------------------------------------------------
#	Input files/directories
# -----------------------------------------------------------------------------------------------------------
# Program for detect the symmetries: SBASS
SBASS= os.path.dirname(__file__) + "/SBASS/sbass"

# Program for solving the ILP task: ILASP
ILASP=os.path.dirname(__file__)+"/ILASP4/ILASP"

# Directory with instances that define the general positive examples 
GEN="/Gen/"

# Directory with instances analysed with SBASS 
S="/S/"

# non ground ASP program in input
ASP_FILE_NAME="/input.lp"

# ASP file with the learned constraints and auxiliary predicates
ACTIVE_BK="/active_BK.lp"

# ILASP program without positive and negative examples
ILASP_NO_EX="/ILASP_input_wout_examples.lp"

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

# Output file that contains positive examples for all the instances in S
POS_EXAMPLES_S="/examples_S_pos.lp"

# Output file that contains negative examples for all the instances in S
NEG_EXAMPLES_S="/examples_S_neg.lp"

# ILASP input: ILASP_NO_EX + ACTIVE_BK + POS_EXAMPLES_S + EXAMPLES_GEN + NEG_EXAMPLES_S
ILASP_INPUT="/ILASP_input.lp"

