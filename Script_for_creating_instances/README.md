
## Contents of each directory
    \PUP_instances       # Directory with script to create instances (double, doublev, triple)
    ├── \Sat                        # Satisfiable instances
    ├── \Unsat                      # Unsatisfiable instances 
    ├── create_instances.sh         # Script for generating instances  
    ├── createZ2S.lp                # ASP program used in script  
    └── PUP_instances.JPG           # Structure of instance 
    
Each directory contains the script (create_instances.sh) for creating the PUP instance in Sat and Unsat.
For each directory, the smallest instance can be obtained from n=3 (see the instance on the right in PUP_instances.JPG).
The name of the created instance in Sat and Unsat contains the number of rooms/zones created.

# Example of usage
    $ create_instances.sh 3
