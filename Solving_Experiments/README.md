## To repeat experiments for PUP
    $ ./solving_experiments_PUP.sh ./double/
    $ ./solving_experiments_PUP.sh ./doublev/
    $ ./solving_experiments_PUP.sh ./triple/

## To repeat experiments for other problems
    $ ./solving.sh ./fastfood/
    $ ./solving.sh ./house_configuration/
    $ ./solving.sh ./pigeon_color/
    $ ./solving.sh ./pigeon_hole/
    $ ./solving.sh ./pigeon_owner/

## To repeat the experiments with core-guided optimization (unsatisfiable cores), add --opt-strategy=usc the the clingo call in solving.sh and solving_experiments_PUP.sh