# ILP Symmetry Breaking

## Overview 
This project aims to exploit inductive logic programming to lift symmetry-breaking constraints of ASP programs.
In particular, we study three distributions of the Partner Unit Problem (PUP).

Given an ASP file, we use the system _SBASS_ (_symmetry-breaking answer set solving_) [1] to infer its graph representation and then detect the symmetries as a graph automorphism problem (performed by the system [_SAUCY_](http://vlsicad.eecs.umich.edu/BK/SAUCY/.)). _SBASS_ returns a set of (irredundant) graph symmetry generators, which are used in our framework to compute the positive and negative examples for the ILP system [_ILASP_](http://www.ilasp.com/?no_animation) [2].

The encodings used for PUP (ENC1 and ENC2) are taken from the paper [3]; while, the PUP benchmarks used (double, doublev, and triple) are derived from [4].

## Project Structure

    .
    ├── \Learning_Experiments       # Directory with learning experiments data 
    │   ├── \Analysis                   # Directory with elaborated data 
    │   ├── \Results                    # Directory with raw data 
    │   ├── create_seeds.sh             # Script to generate seeds for tests  
    │   └── run_experiments.sh          # Script to run experiments 
    │
    ├── \PUP                        # Directory with PUP benchmarks
    │   ├── \double                     # Framework inputs with instances draw from double 
    │   │                                  (use default scoring function for ILASP)    
    │   ├── \double_weight              # Framework inputs with instances draw from double 
    │   │                                  (use custom scoring function for ILASP)    
    │   ├── \doublev                    # Framework inputs with instances draw from doublev 
    │   │                                  (use default scoring function for ILASP) 
    │   ├── \doublev_weight             # Framework inputs with instances draw from doublev 
    │   │                                  (use custom scoring function for ILASP)   
    │   ├── \triple                     # Framework inputs with instances draw from triple 
    │   │                                  (use default scoring function for ILASP)  
    │   └── \triple_weight              # Framework inputs with instances draw from triple 
    │                                      (use custom scoring function for ILASP) 
    │
    ├── \Scrips_for_instances       # Directory with description and scripts for creating instances 
    │   ├── \double                     # Instances draw from double 
    │   ├── \doublev                    # Instances draw from doublev 
    │   └── \triple                     # Instances draw from triple 
    │
    ├── \Set_Env                    # Instruction for setting the Conda env used for experiments
    │   ├── conda_server.txt            # Conda environment 
    │   └── libclingo.so.4              # Clingo library
    │
    ├── \Solving_Experiments        # Directory with solving experiments data 
    │   ├── \double                     # Directory with ABK and inputs for double
    │   ├── \doublev                    # Directory with ABK and inputs for doublev
    │   ├── \triple                     # Directory with ABK and inputs for triple 
    │   ├── ENC1.lp                     # PUP encoding without SBCs 
    │   ├── ENC2.lp                     # Advanced PUP encoding with SBCs 
    │   └── solving_experiments.sh      # Script to run solving experiments 
    │
    ├── \src                    # Sources  
    │   ├── \ILASP4.2                # ILASP4 
    │   ├── \SBASS                   # SBASS 
    │   ├── file_names.py            # Python module with file names
    │   ├── generate_examples.py     # Python file to create positive and negative examples from SBASS output
    │   ├── ilasp4.py                # Pylasp script generated from ILASP4 (default)
    │   ├── main.py                  # Main Python file
    │   ├── permutations.lp          # ASP files that encode the lex-leader approach
    │   ├── structures.py            # Python file with data structures 
    │   └── vio_sub.lp               # Edited Pylasp script that uses the new conflict analysis
    │
    ├── Appendix.pdf                 # Appendix with example of sbca
    └── README.md

## Brief Descriptions of Directories 
*  _**src**_ contains the programs and python scripts used for implementing the framework.

*  _**PUP**_ contains the inputs of our framework ($P,S,Gen,ABK,H_M$) for each PUP benchmark analysed.
The three directories, double, doublev and triple, contain the search space for ILASP without overwriting its scoring function; while, the three directories finishing with "_weight" contain the search space for ILASP with an alternative scoring function.

*  _**Scrips_for_instances**_ contains the description of the labeling and topology of the PUP instances analysed for each distribution.

*  _**Set_Env**_  contains the instruction for setting the Conda env used for experiments.

*  _**Learning_Experiments**_ contains the raw results and analysis obtained by computing the ILP task 120 times for each considered parameter. 

*  _**Solving_Experiments**_ contains the files used to compare the solving performance of the fastest constraints learned with our approach vs ENC1 (base encoding without SBCs), ENC2 (advanced encoding with SBCs modelled by experts) and SBASS+solving with ground SBCs.

## Prerequisites

* [Python3](https://www.python.org/downloads/)
* [Clingo](https://potassco.org/clingo/) 
* [ILASP4 dependencies](https://doc.ilasp.com/installation.html) 
* [(Optional) Conda](https://docs.conda.io/projects/conda/en/latest/index.html) 

## Example of usage
    First update CLINGOPATH in the file "./src/file_names.py" with your Clingo path.
    $ python ./src/main.py PUP/double/ -v --cell 1 -f 
## For more information 
    $ python ./src/main.py --help



## Citations

[1] C. Drescher, O. Tifrea, and T. Walsh, “Symmetry-breaking answer set solving” (SBASS)
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

[2] M. Law, A. Russo, and K. Broda, “The {ILASP} System for Inductive Learning of Answer Set Programs” (ILASP)
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

[3] Dodaro, C., Gasteiger, P., Leone, N., Musitsch, B., Ricca, F., and Schekotihin, K. 
"Combining answer set programming and domain heuristics for solving hard industrial problems."
```
@article{dogalemurish16a,
  author  = {C. Dodaro and P. Gasteiger and N. Leone and B. Musitsch and F. Ricca and K. Schekotihin},
  journal = {Theory and Practice of Logic Programming},
  title   = {Combining Answer Set Programming and Domain Heuristics for Solving Hard Industrial Problems (application paper)},
  year    = {2016}
}
```

[4] Aschinger, M., Drescher, C., Friedrich, G., Gottlob, G., Jeavons, P., Ryabokon, A., and Thorstensen, E.
"Optimization methods for the partner units problem."
```
@inproceedings{DBLP:conf/cpaior/AschingerDFGJRT11,
	author    = {M. Aschinger and C. Drescher and G. Friedrich and G. Gottlob and P. Jeavons and A. Ryabokon and E. Thorstensen},
	title     = {Optimization Methods for the Partner Units Problem},
	booktitle = {CPAIOR},
	series    = {LNCS},
	volume    = {6697},
	pages     = {4--19},
	publisher = {Springer},
	year      = {2011}
}
```