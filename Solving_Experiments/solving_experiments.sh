#!/bin/bash
NUMITERATION=1
TIMEOUT=600
CSVFILE=$1experiments.csv

shopt -s nullglob
echo "Problem,Encoding,Instance,Pre-processing,Result,Model,Time,Solving,1st Model,Unsat,CPU,Pre-proc Time(Nanos)" > $CSVFILE
for ins in $1/Instances/*.lp
        do
            filename=$(basename -- "$ins")
            id="${filename%.*}"
            echo "$1,ABK,$id,OK,$(clingo $1/ABK.lp ENC1.lp $ins -q  --time-limit=$TIMEOUT | sed ':a;N;$!ba;s/\n//g'| sed -E "s/.*(\.|p)(SATISFIABLE|UNSATISFIABLE|UNKNOWN)(TIME LIMIT   : [0-9]+)?Models       : ([0-9+]*)Calls        : [0-9+]*Time         : ([0-9.]*)s \(Solving: ([0-9.]*)s ... Model: ([0-9.]*)s Unsat: ([0-9.]*)s\)CPU Time     : ([0-9.]*)s/\2,\4,\5,\6,\7,\8,\9/"),0" >> $CSVFILE
            echo "$1,ENC2,$id,OK,$(clingo ENC2.lp $ins -q  --time-limit=$TIMEOUT | sed ':a;N;$!ba;s/\n//g'| sed -E "s/.*(\.|p)(SATISFIABLE|UNSATISFIABLE|UNKNOWN)(TIME LIMIT   : [0-9]+)?Models       : ([0-9+]*)Calls        : [0-9+]*Time         : ([0-9.]*)s \(Solving: ([0-9.]*)s ... Model: ([0-9.]*)s Unsat: ([0-9.]*)s\)CPU Time     : ([0-9.]*)s/\2,\4,\5,\6,\7,\8,\9/"),0" >> $CSVFILE
            echo "$1,BASE,$id,OK,$(clingo ENC1.lp $ins -q  --time-limit=$TIMEOUT | sed ':a;N;$!ba;s/\n//g'| sed -E "s/.*(\.|p)(SATISFIABLE|UNSATISFIABLE|UNKNOWN)(TIME LIMIT   : [0-9]+)?Models       : ([0-9+]*)Calls        : [0-9+]*Time         : ([0-9.]*)s \(Solving: ([0-9.]*)s ... Model: ([0-9.]*)s Unsat: ([0-9.]*)s\)CPU Time     : ([0-9.]*)s/\2,\4,\5,\6,\7,\8,\9/"),0" >> $CSVFILE
            start_time=`date +%s%N` 
            gringo --output=smodels ENC1.lp $ins > temp.txt 
            timeout 600s ../src/SBASS/sbass < temp.txt > temp2.txt
            if [ $? == 124 ]; then
              echo "$1,SBASS,$id,Timeout,UNKNOWN,0+,$TIMEOUT,0,0,0,0,$TIMEOUT" >> $CSVFILE
            else
              pretime=$(expr `date +%s%N` - $start_time)
              echo "$1,SBASS,$id,OK,$(clasp temp2.txt -q  --time-limit=$TIMEOUT | sed ':a;N;$!ba;s/\n//g'| sed -E "s/.*(\.|p)(SATISFIABLE|UNSATISFIABLE|UNKNOWN)(TIME LIMIT   : [0-9]+)?Models       : ([0-9+]*)Calls        : [0-9+]*Time         : ([0-9.]*)s \(Solving: ([0-9.]*)s ... Model: ([0-9.]*)s Unsat: ([0-9.]*)s\)CPU Time     : ([0-9.]*)s/\2,\4,\5,\6,\7,\8,\9/"),$pretime" >> $CSVFILE
            fi
        done 
    done
    rm temp.txt temp2.txt


