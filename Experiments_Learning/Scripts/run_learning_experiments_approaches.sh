#!/bin/bash

i=1
sed -i.bak s/$'\r'//g experiments_approaches.txt

for approach in "" "-s" "-o" "-f -o"; do
  while read line; do
        if [ "$line" != "" ]; then
              command="${line} ${approach} -d=${i} --csv Experiments_approaches.csv"
              echo $command
              python ./../../src/main.py ./../../$command
              ((i=i+1))
        fi
  done <experiments_approaches.txt
done
