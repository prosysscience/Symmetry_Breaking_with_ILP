# ILP Symmetry Breaking

## Overview 
This project aims to exploit inductive logic programming to lift symmetry breaking constraints of ASP programs.

Given an ASP file, we use the system _SBASS_ (_symmetry-breaking answer set solving_) to infer its graph representation and then detect the symmetries as a graph automorphism problem (performed by the system [_SAUCY_](http://vlsicad.eecs.umich.edu/BK/SAUCY/.)). _SBASS_ returns a set of (irredundant) graph symmetry generators, which are used in our framework to compute the positive and negative examples for the ILP system [_ILASP_](http://www.ilasp.com/?no_animation).

**Note**: the files of _Active Background Knowledge_ (active_BK/active_BK_sat) contain the constraints learned for the experiments. To test the framework, remove the constraints and follow the files' instructions to obtain the same result. 

## Project Structure

    .
    ├── \Experiments              # Directory with experiments results 
    │   ├── experiments.csv         # CSV file with results
    │   └── experiments             # Script to compare the running-time performance     
    │
    ├── \Instances              # Directory with problem instances
    │   ├── \House_Configuration     # House-Configuration Problem     
    │   ├── \Pigeon_Owner            # Pigeon-Hole Problem with colors and owners extension   
    │   ├── \Pigeon_Color            # Pigeon-Hole Problem with colors extension
    │   └── \Pigeon_Hole             # Pigeon-Hole Problem  
    │
    ├── \src                    # Sources  
    │   ├── \ILASP4                  # ILASP4 
    │   ├── \SBASS                   # SBASS 
    │   ├── file_names.py            # Python module with file names
    │   ├── parser.py                # Main python file: create the positive and negative examples from SBASS output
    │   ├── remove.py                # Auxiliary python file to remove duplicate in smodels file
    │   └── permutations.lp          # ASP file which computes the (partial) non symmetric 
    │                                  permutations of atoms
    │
    ├── .gitignore 
    ├── .gitattributes
    ├── ILP_SBC                 # Script that runs SBASS and lift the SBC found using ILASP
    └── README.md


## Prerequisites

* [Python3](https://www.python.org/downloads/)
* [Clingo](https://potassco.org/clingo/) 
* [ILASP4 dependencies](https://doc.ilasp.com/installation.html) 

## Usage
### 1) Create default positive examples 
Create the default positive examples for Pigeon_Hole problem: each instance in the directory Gen
generate a positive example. 

    $ .\ILP_SBC -g .\Instances\Pigeon_Hole

### 2) Create positive and negative examples 
#### Default mode: each non-symmetric answer set defines a positive example
     $ .\ILP_SBC -d .\Instances\Pigeon_Hole


#### Satisfiable mode: define a single positive example with empty inclusions and exclusions
     $ .\ILP_SBC -s .\Instances\Pigeon_Hole


### 3) Run ILASP to extend the active background knowledge
     $ .\ILP_SBC -i .\Instances\Pigeon_Hole



## Citations

C. Drescher, O. Tifrea, and T. Walsh, “Symmetry-breaking answer set solving” (SBASS)
```
@article{drescherSymmetrybreakingAnswerSet2011,
	title = {Symmetry-breaking answer set solving},
	volume = {24},
	doi = {10.3233/AIC-2011-0495},
	number = {2},
	journal = {AI Commun.},
	author = {Drescher, Christian and Tifrea, Oana and Walsh, Toby},
	year = {2011},
	pages = {177--194}
}
```

M. Law, A. Russo, and K. Broda, “The {ILASP} System for Inductive Learning of Answer Set Programs” (ILASP)
```
@article{larubr20b,
     title = {The {ILASP} System for Inductive Learning of Answer Set Programs},
     author = {M. Law and A. Russo  and K. Broda},
     journal = {The Association for Logic Programming Newsletter},
     year = {2020}
}
@misc{ilasp,
     author = {M. Law and A. Russo  and K. Broda},
     title = {Ilasp Releases},
     howpublished = {\url{www.ilasp.com}},
     note = {Accessed: 2020-10-01},
     year={2020}
}
```