## Contents of each directory
    \PUP_instances       # Compressed directory with results from learning experiments
    ├── \ILP_Task_[1..4]                        # Directories with ILP tasks produced 
    ├── \Learning_Constraints_[1..4]            # Directories with results of ILASP 
    │                                                (if missing then timeout or 
    │                                                no neg/pos examples using enum)
    ├── LearningExp[1..4].csv                   # csv file with learning time and information for successfully (no timeout) runs  
    ├── SolvingResults[1..4].csv                # csv file with solving performance. I.e., run each learned ABK for instances in Sat and Unsat 
    └── timeout[1..4].txt                       # txt file containing timeouts 
    
The numbers from 1 to 4 represent the seeds used. 

The results for 5 and 6 are missing since they all get a timeout.

We did not report the experiments testing the option sat, as it got bad performance in preliminary studies.
