# ILP Symmetry Breaking

## Overview 
This project aims to exploit inductive logic programming to learn symmetry breaking constraints of ASP programs.

Given an ASP file, we use the system _SBASS_ (_symmetry-breaking answer set solving_) to infer its graph representation and then detect the symmetries as a graph automorphism problem (performed by the system [_SAUCY_](http://vlsicad.eecs.umich.edu/BK/SAUCY/.)). _SBASS_ returns a set of (irredundant) graph symmetry generators, which are used in our framework to compute the positive and negative examples for the ILP system [_ILASP_](http://www.ilasp.com/?no_animation).

## Project Structure

    .
    ├── \Instances              # Directory with problem instances
    │   ├── \Graceful_Graph          # Graceful-Graph Labeling Problem     
    │   ├── \House_Configuration     # House-Configuration Problem     
    │   ├── \Partner_Unit_Problem    # Partner-Unit Problem  
    │   ├── \Pigeon_Owner            # Pigeon-Hole Problem with colors and owners extension   
    │   ├── \Pigeon_Color            # Pigeon-Hole Problem with colors extension
    │   └── \Pigeon_Hole             # Pigeon-Hole Problem  
    │
    ├── \src                    # Sources  
    │   ├── \ILASP4                  # ILASP4 
    │   ├── \SBASS                   # SBASS 
    │   ├── file_names.py            # Python module with file names
    │   ├── generate_examples.py     # Python file to create positive and negative examples from SBASS output
    │   ├── structures.py            # Python file with data structures 
    │   └── main.py                  # Main Python file
    │
    ├── .gitignore 
    ├── .gitattributes
    └── README.md


## Prerequisites

* [Python3](https://www.python.org/downloads/)
* [Clingo](https://potassco.org/clingo/) 
* [ILASP4 dependencies](https://doc.ilasp.com/installation.html) 

## Usage
    $ python .\src\main.py --help




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