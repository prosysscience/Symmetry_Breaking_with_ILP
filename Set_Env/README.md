
## Configure Conda Enviroment used for Experiments
    $ conda create --name experiments --file conda_env.txt
    $ export LD_LIBRARY_PATH=<conda_path>/envs/experiments/lib/
    $ ldconfig
    $ conda activate experiments
