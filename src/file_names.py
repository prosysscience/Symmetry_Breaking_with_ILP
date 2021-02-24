# -----------------------------------------------------------------------------------------------------------
#	Input/Output files
# -----------------------------------------------------------------------------------------------------------
# General ASP file for finding all the non-symmetric assignments
ASP_ALL_SYM="./src/permutations.lp"

# Directory with instances that define the default positive examples 
GEN="/Gen/"

# Directory with instances analysed with SBASS 
S="/S/"

# Output file that contains the general positive examples, computed from DEFAULT_DATA
DEFAULT_EXAMPLES="/default_positive_examples.lp"

# non ground ASP program 
ASP_FILE_NAME="/input.lp"

# ASP file with the learned constraints
ACTIVE_BK="/active_BK.lp"

# All the answer set for the current ASP_FILE_NAME and ACTIVE_BK
ALL_AS_FILE="/all_AS.txt"

# ground ASP program in smodels format, from ASP_FILE_NAME and ACTIVE_BK
SMODELS_FILE="/smodels.gnd"

# file with all generators found by SBASS
GENERATORS_FILE="/generators.txt"

# Output file with the considered generators, translated in atoms
OUT_GENERATORS_FILE="/generators_translated.txt"

# ASP file with all the permutations considered OUT_GENERATORS_FILE
TEMP_ASP_ALL_SYM="/permutation_input.lp"

# ASP file that select a subset of permutations in TEMP_ASP_ALL_SYM
PERMUTATION_RANGE="/permutation_range.txt"

# File that contains the non symmetric assignments from ASP_ALL_SYM, TEMP_ASP_ALL_SYM and PERMUTATION_RANGE and the current answer set
OUT_SYM_FILE="/non_sym_assignment.txt"

# Temp file that contains the negative examples of the current instance
TEMP_EXAMPLES_FILE="/current_neg_examples.lp"

# Output file that contains the negative examples for all the considered instances
NEG_EXAMPLES_FILE="/neg_examples.lp"

# Output file that contains the positive examples for all the considered instances
POS_EXAMPLES_FILE="/pos_examples.lp"

# Sbass output: input program and new ground sbc in smodels format
SBASS_OUTPUT="/sbass_output.txt"

# ILASP program without positive and negative examples
ILASP_NO_EX="/ILASP_input_wout_examples.lp"

# ILASP input: ILASP_NO_EX + ACTIVE_BK + POS_EXAMPLES_FILE + DEFAULT_EXAMPLES + NEG_EXAMPLES_FILE  
ILASP_INPUT="/ILASP_input.lp"

