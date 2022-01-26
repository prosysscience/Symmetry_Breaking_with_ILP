
## Configure Conda Enviroment used for Experiments
    $ conda create --name server --file conda_server.txt
    $ cp libclingo.so.4 <conda_path>/envs/server/lib/libclingo.so.4
    $ cd <conda_path>/envs/server/lib
    $ chmod 777 libclingo.so.4
    $ sudo rm -r libclingo.so
    $ sudo ln -s libclingo.so.4 libclingo.so
    $ export LD_LIBRARY_PATH=<conda_path>/envs/server/lib/
    $ ldconfig
    $ conda activate server

Lastly, update the CLINGOPATH in ./src/file_names.py with "<conda_path>/envs/server/clingo"