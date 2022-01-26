#!/bin/bash
CSVFILE=$1SolvingResult$2.csv
LEARNINGCSV=LearningExp$2.csv
dir=$1
TIMEOUT=300
i=1
while read line; do
            if [ "$line" != "" ]; then
              command="${dir} --iter=1 -d=${i} --csv $LEARNINGCSV $line"
              echo $command
              timeout 3600 python ./../src/main.py $command
              exit_status=$?
              if [[ $exit_status -eq 124 ]]; then
                  echo "Timeout for: ${command}" >> $1timeout$2.txt
              fi
              ((i=i+1))
            fi
    done <seeds$2.txt


shopt -s nullglob
echo "ConstraintFile,Id,Mode,Order,Full,Cell,Version,Seed,Instance,Result,Model,Time,Solving,1st Model,Unsat,CPU" > $CSVFILE
for dirSol in "Unsat" "Sat"; do
echo ${dirSol}
for ins in ${dir}/${dirSol}/*
do
    for constr in ${dir}/Learned_Constraints/*.lp
    do
        echo "$constr"
        echo "$ins"
        str="$(tail -2 $constr)"
        if [[ $str != *[%]* ]]
        then
            c_filename=$(basename -- "$constr")
            c_id="${c_filename%.*}"
            arrc_id=$(echo $c_id | tr _ ,)
            filename=$(basename -- "$ins")
            id="${filename%.*}"
            echo "$c_id,$arrc_id,$id,$(clingo $constr ${dir}input.lp $ins -q  --time-limit=$TIMEOUT | sed ':a;N;$!ba;s/\n//g'| sed -E "s/.*(\.|p)(SATISFIABLE|UNSATISFIABLE|UNKNOWN)(TIME LIMIT   : [0-9]+)?Models       : ([0-9+]*)Calls        : [0-9+]*Time         : ([0-9.]*)s \(Solving: ([0-9.]*)s ... Model: ([0-9.]*)s Unsat: ([0-9.]*)s\)CPU Time     : ([0-9.]*)s/\2,\4,\5,\6,\7,\8,\9/")" >> $CSVFILE
        fi
    done 
done
done

