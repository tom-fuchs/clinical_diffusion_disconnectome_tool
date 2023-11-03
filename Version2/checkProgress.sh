#!/bin/bash
c=0
d=0
f=0

echo "provide file name for ms list"
read csv_name
lst=$path/subject_lists/diffusion/$csv_name

for i in $( cat $lst ); do
    sub_id=`echo  $i | cut -d"," -f1`
    ex_id=`echo $i | cut -d"," -f2`
    
	n=$(ls -lrth $path/study_scans/$sub_id/$ex_id/diffusion/default_output | wc -l)
        n=$(($n-1))
	if [ $n = 0  ]; then
		c=$(($c + 1))
	elif [ $n = 74  ]; then
		f=$(($f + 1))
	else
		echo $i:  $(( $n ))/73  patients done
		d=$(($d + 1))
	fi

done

echo $c scans not started
echo $d scans in progress
echo $f scans done
