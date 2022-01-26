
## Contents of the directory
    .
    ├── \Analysis       # Directory with learning experiments data 
    │   ├── \Analysis                   # Directory with elaborated data 
    │   ├── \Results                    # Directory with raw data 
    │   ├── create_seeds.sh             # Script to generate seeds for tests  
    │   └── run_experiments.sh          # Script to run experiments 
    │ 
    ├── \Results       # Archives with raw data obtained in the learning experiments 
    │                    
    ├── create_seeds.sh                 # Script to create 120 random run
    ├── run_experiments.sh              # Script to run the experiments 
    └── seeds1...6.txt                  # txt files with the seeds considered in the experiments

The directory Results contains the archives for each considered inputs from "./../PUP/".
Each of them was used in the scripts run_experiments.sh combined with the txt files named seeds.

## Example of usage
    $ run_experiments.sh ./../PUP/double/ 1

The results of the run will appear in the directory "./../PUP/double/"

## Descriptions of seeds
*  _**seeds1.txt**_ scalable fullSBCs (with alternative ordering), with custom PyLASP script (using sbca) 

*  _**seeds2.txt**_ scalable fullSBCs (with standard ordering), with custom PyLASP script (using sbca) 

*  _**seeds3.txt**_ scalable enum (with alternative ordering), with custom PyLASP script (using sbca) 
                    Run only for doublev and triple, to obtain the same number of examples of scalable fullSBCs.

*  _**seeds3a.txt**_ scalable enum (with alternative ordering), with custom PyLASP script (using sbca). 
                     Run only for double, to obtain the same number of examples of scalable fullSBCs.

*  _**seeds4.txt**_ scalable enum (with standard ordering), with custom PyLASP script (using sbca) 
                    Run only for doublev and triple, to obtain the same number of examples of scalable fullSBCs.

*  _**seeds4a.txt**_ scalable enum (with standard ordering), with custom PyLASP script (using sbca). 
                     Run only for double, to obtain the same number of examples of scalable fullSBCs.

*  _**seeds5.txt**_ scalable fullSBCs (with alternative ordering), with default PyLASP script (from ILASP4) 

*  _**seeds6.txt**_ scalable enum (with alternative ordering), with default PyLASP script (from ILASP4) 


