#!/bin/bash

i=100
sed -i.bak s/$'\r'//g experiments_iterative.txt
sed -i.bak s/$'\r'//g experiments_alternative_sm.txt
#declare -a StringArray=("" "-o" "-f" "-f -o")
#declare -a StringArray=("" "-s")
for approach in "" "-s"; do
  while read line; do
        if [ "$line" != "" ]; then
              command="${line} ${approach} -d=${i} --csv Experiments_iterative.csv"
              echo $command
              timeout 3600 python ./../../src/main.py ./../../$command
              exit_status=$?
              if [[ $exit_status -eq 124 ]]; then
                  echo "Timeout for: ${i}" >> timeout.txt
              fi
              ((i=i+1))
        fi
  done <experiments_iterative.txt
done

while read line; do
  for approach in "" "-s"; do
    if [ "$line" != "" ]; then
      command="${line} ${approach} -d=${i} --csv Experiments_alternative_sm.csv"
      echo $command
      timeout 3600  python ./../../src/main.py ./../../$command
      exit_status=$?
      if [[ $exit_status -eq 124 ]]; then
          echo "Timeout for: ${i}" >> timeout.txt
      fi
      ((i=i+1))
    fi
  done
done <experiments_alternative_sm.txt

