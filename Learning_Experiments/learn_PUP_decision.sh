#!/bin/bash
LEARNINGCSV=LearningExp_wout$2.csv
dir=$1
i=120

# If there's an ucommented weak constraint, add %
sed -i '/^ :*/ s/./%&/' ${dir}input.lp
sed -i '/^ :*/ s/./%&/' ${dir}ILASP_BK.lp

while read line; do
            if [ "$line" != "" ]; then
              command="${dir} -d=${i} --csv $LEARNINGCSV $line"
              echo $command
              timeout 3600 python ./../src/main.py $command
              exit_status=$?
              if [[ $exit_status -eq 124 ]]; then
                  echo "Timeout for: ${command}" >> $1timeout$2.txt
              fi
              ((i=i+1))
            fi
    done <seeds$2.txt