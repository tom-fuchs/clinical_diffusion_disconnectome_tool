#!/bin/bash
c=0
d=0
f=0

echo "provide file name for subject list"
read csv_name
ids=$path/subject_lists/$csv_name

for i in $( cat $ids ); do
	n=$(ls -lrth $path/subjects/$i/default_output | wc -l)
        n=$(($n-1))
	if [ $n = 0  ]; then
		c=$(($c + 1))
	elif [ $n = 74  ]; then
		f=$(($f + 1))
	else
		echo $i:  $(( $n ))/73  patients done
		d=$(($d + 1))
	fi

	#echo $i:  $(($n-1))/73 total patients
	#ls -lrth $path/subjects/$i/default_output
	#n=$(ls -lrth $path/subjects/$i/default_output | wc -l)
	#echo $(($n-1))/73 total patients
done

echo $c scans not started
echo $d scans in progress
echo $f scans done
