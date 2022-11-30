The results of the learning experiments are in the directory "Learning Results".
If the tests are repeated, the results will appear in the corresponding directory "\..\Problems".

## To repeat experiments for pigeon-hole problems (color and owner variants) and house configuration problem
    $ ./learn_optimization_vs_decision.sh ./../Problems/Pigeon_Hole/ 1
    $ ./learn_optimization_vs_decision.sh ./../Problems/Pigeon_Color/ 2
    $ ./learn_optimization_vs_decision.sh ./../Problems/Pigeon_Owner/ 3
    $ ./learn_optimization_vs_decision.sh ./../Problems/House_Configuration 4
    $ ./learn_optimization_vs_decision.sh ./../Problems/FastFood 5

## To repeat experiments for PUP comparing decision vs optimization learning time
    $ ./learn_PUP_decision.sh ./../Problems/PUP/double/ 1
    $ ./learn_PUP_decision.sh ./../Problems/PUP/doublev/ 1
    $ ./learn_PUP_decision.sh ./../Problems/PUP/triple/ 1
    $ ./learn_PUP_optimization.sh ./../Problems/PUP/double/ 1
    $ ./learn_PUP_optimization.sh ./../Problems/PUP/doublev/ 1
    $ ./learn_PUP_optimization.sh ./../Problems/PUP/triple/ 1

## To repeat experiments for PUP: learning time without option "opt" 
    $ ./learn_PUP_optimization.sh ./../Problems/PUP/double_opt/ 1
    $ ./learn_PUP_optimization.sh ./../Problems/PUP/doublev_opt/ 1
    $ ./learn_PUP_optimization.sh ./../Problems/PUP/triple_opt/ 1

## To repeat experiments for PUP: learning time with option "opt"
    $ ./learn_PUP_optimization.sh ./../Problems/PUP/double_opt/ 2
    $ ./learn_PUP_optimization.sh ./../Problems/PUP/doublev_opt/ 2
    $ ./learn_PUP_optimization.sh ./../Problems/PUP/triple_opt/ 2