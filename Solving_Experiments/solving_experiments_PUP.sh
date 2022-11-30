#!/bin/bash
NUMITERATION=1
TIMEOUT=300
CSVFILE=$1experiments.csv

shopt -s nullglob
echo "Problem,Encoding,Instance,Result,OptVal,Time,Solving" > $CSVFILE
for ins in $1/Instances/*.lp
        do
            filename=$(basename -- "$ins")
            id="${filename%.*}"
            echo "$1,ABK,$id,$(clingo $1/ABK.lp $1/BASE.lp $ins -q  --time-limit=$TIMEOUT | sed ':a;N;$!ba;s/\n//g'| sed -E "s/.*(\.|p)(UNSATISFIABLE|SATISFIABLE|UNKNOWN|OPTIMUM FOUND)(TIME LIMIT   : [ 0-9]+)?(Models       : [0-9+]*)?(  Optimum    : [yesunknown]*)?(Optimization : )?([0-9]+)?Calls        : [0-9+]*Time         : ([0-9.]*)s \(Solving: ([0-9.]*)s ... Model: [0-9.]*s Unsat: [0-9.]*s\)CPU Time     : [0-9.]*s/\2,\7,\8,\9/")" >> $CSVFILE
            echo "$1,ENC2,$id,$(clingo ENC2.lp $ins -q  --time-limit=$TIMEOUT | sed ':a;N;$!ba;s/\n//g'| sed -E "s/.*(\.|p)(UNSATISFIABLE|SATISFIABLE|UNKNOWN|OPTIMUM FOUND)(TIME LIMIT   : [ 0-9]+)?(Models       : [0-9+]*)?(  Optimum    : [yesunknown]*)?(Optimization : )?([0-9]+)?Calls        : [0-9+]*Time         : ([0-9.]*)s \(Solving: ([0-9.]*)s ... Model: [0-9.]*s Unsat: [0-9.]*s\)CPU Time     : [0-9.]*s/\2,\7,\8,\9/")" >> $CSVFILE
            echo "$1,BASE,$id,$(clingo $1/BASE.lp $ins -q  --time-limit=$TIMEOUT | sed ':a;N;$!ba;s/\n//g'| sed -E "s/.*(\.|p)(UNSATISFIABLE|SATISFIABLE|UNKNOWN|OPTIMUM FOUND)(TIME LIMIT   : [ 0-9]+)?(Models       : [0-9+]*)?(  Optimum    : [yesunknown]*)?(Optimization : )?([0-9]+)?Calls        : [0-9+]*Time         : ([0-9.]*)s \(Solving: ([0-9.]*)s ... Model: [0-9.]*s Unsat: [0-9.]*s\)CPU Time     : [0-9.]*s/\2,\7,\8,\9/")" >> $CSVFILE
        done 
    done


