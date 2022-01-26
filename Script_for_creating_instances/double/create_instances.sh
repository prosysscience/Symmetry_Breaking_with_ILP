#!/bin/bash
let num="(3 * $1 - 1) / 2"
let prev="$num -1"
instanceName="2-double-"$(expr 2 \* $1)".lp"

echo -e "maxPU(2).\nmaxElements(2).\nlower($num)." > Sat/$instanceName
echo -e "maxPU(2).\nmaxElements(2).\nlower($prev)." > Unsat/Un_$instanceName
for (( repeat=1; repeat<$num; repeat++ )) ; do
	echo -e "comUnit($repeat)." | tee -a Unsat/Un_$instanceName Sat/$instanceName 1>/dev/null
done
echo -e "comUnit($num)." >> Sat/$instanceName

clingo createZ2S.lp -c n=$1 | sed -n '5 p' | tr " " "\n" | cut -d "(" -f2  | sort -t, -n -k 1,1 -k 2,2 | sed 's/^/zone2sensor(/' | sed 's/)/)./' | tee -a Unsat/Un_$instanceName Sat/$instanceName 1>/dev/null