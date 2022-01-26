for (( repeat=1; repeat<=20; repeat++ )) ; do
     for (( cell=1; cell<=3; cell++ )) ; do
        seed=$((1 + $RANDOM))
		echo "--cell=${cell} --seed=$seed" 
	done
done
for (( repeat=1; repeat<=20; repeat++ )) ; do
     for (( cell=1; cell<=3; cell++ )) ; do
        seed=$((1 + $RANDOM))
		echo "--cell=${cell} --seed=$seed --maxsizecell=200"
	done
done