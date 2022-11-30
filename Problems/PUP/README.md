## Contents of each directory
    \PUP_instances       # Directory with inputs for framework
    ├── \Gen                        # General instances
    ├── \S                          # Instances analysed with SBASS 
    ├── \Sat                        # Satisfiable instances (used for validation)
    ├── \Unsat                      # Unsatisfiable instances (used for validation)
    ├── active_BK.lp                # Active Background Knowledge  
    ├── ILASP_BK.lp                 # ASP program equivalent to P (used by ILASP) 
    ├── ILASP_iterative_step_1.lp   # Language bias (H_M)
    └── input.lp                    # ASP program P
    
Each directory contains the five inputs for our framework (P, Gen, S, H_M, ABK), plus two directories (Sat and Unsat) used to validate the learned constraints.

The directories ending with "_opt" were used to test the option "opt"

