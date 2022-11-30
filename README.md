## Project Structure

    .
    ├── \Learning_Experiments       # Directory with learning experiments data 
    │
    ├── \Problems                   # Directory with framework inputs for tested problems
    │   ├── \FastFood                     
    │   ├── \House_Configuration       
    │   ├── \Pigeon_Color 
    │   ├── \Pigeon_Hole  
    │   ├── \Pigeon_Owner  
    │   └── \PUP                    # Directory with all PUP benchmarks
    │
    ├── \Set_Env                    # Instructions for setting the Conda environment
    │   ├── conda_env.txt            # Conda environment 
    │   └── README.md                # Instructions
    │
    ├── \Solving_Experiments        # Directory with solving experiments data 
    │
    ├── \src                    # Sources  
    │   ├── \ILASP4.3                # ILASP4.3 
    │   ├── \SBASS                   # SBASS 
    │   ├── file_names.py            # Python module with file names
    │   ├── generate_examples.py     # Python file to create positive and negative examples from SBASS output
    │   ├── ilasp4.3.py              # Edited Pylasp script
    │   ├── main.py                  # Main Python file
    │   ├── permutations.lp          # ASP files that encode the lex-leader approach
    │   └── structures.py            # Python file with data structures 
    │
    └── README.md

## Brief Descriptions of Directories 
*  _**src**_ contains the programs and python scripts used for implementing the framework.

*  _**Problems**_ contains the inputs of the framework ($P,S,Gen,ABK,H_M$) for each problem analysed.

*  _**Set_Env**_  contains the instruction for setting the Conda env used for experiments.

*  _**Learning_Experiments**_ contains the results of Learning Experiments.

*  _**Solving_Experiments**_ contains the results of Solving Experiments.

## Prerequisites

* [Python3](https://www.python.org/downloads/)
* [Clingo](https://potassco.org/clingo/) 
* [ILASP4 dependencies](https://doc.ilasp.com/installation.html) 
* [(Optional) Conda](https://docs.conda.io/projects/conda/en/latest/index.html) 

## Example of usage
    $ python ./src/main.py ./Problems/PUP/double/ -v --cell 1 -f 

## For more information 
    $ python ./src/main.py --help

