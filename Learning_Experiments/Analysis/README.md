This directory contains the analyses carried out on the data in "./../Results". 

## Contents of the directory
    .
    ├── <type>_default_vs_custom.ods                # ods file combining SolvingResults1.csv from the
    │                                                  dir <type> and <type>_weight in "./../Results"
    ├── <type>.csv                                  # csv file created from <type>_default_vs_custom.ods
    │                                                  used with wilcoxon.py
    ├── Results_for_custom_scoring_function.JPG     # image illustrating the results obtained for all 
    │                                                  experiments with the custom scoring function
    ├── Results_for_default_scoring_function.JPG    # image illustrating the results obtained for all 
    │                                                  experiments with the default scoring function
    └── wilcoxon.py                                 # python file for producing boxplot in paper and 
                                                      calculate Wilcoxon T-test

To calculate Wilcoxon T-test and create the box plots used in the paper, run: 

    $ python wilcoxon.py

