#!/bin/bash

#I am very lazy and don't want to type in quality control feedback manually for the final registered FA

echo "Provide name of subject list to be qc reviewed (including file extension)"
read qc_list
echo "Name of resulting csv (sans the .csv bit): "
read t
echo Enter line number to start at -- The line that was last left off at if you stopped midway, or 1
read n

l=$path/subject_lists/$qc_list

echo For each scan id, enter 'a' for pass, 's' for fail, 'q' to quit, or 'n' to skip to the next id with no action

#give our qc spreadsheet a header
cd $path/subject_lists
file=$t\.csv
echo EXid,passed >> $file
c=0

#loop through all ids in provided list
for i in $( sed -n $n',$p' $l  ); do

#depending on the letter entered, the script echos the necessary feedback to a spreadsheet in quality_control directory

c=$(( $c + 1 ))
bad=true
while [ $bad = true ]
do

echo $i
read option

case "$option" in

#pass
"a")
	echo $i',1' >> $file
	bad=false
	;;
#fail
"s")
	echo $i',0' >> $file
	bad=false
	;;
#skip to next scan id in list
"n")
	bad=false
	continue
	;;
#exit script
"q")
	echo ""
	echo Left off at line -- $c -- better write that down
	break 2
	;;
#any other input results in output of wrong
#will continue to next scan id
*)
	echo "bad input boss"
	bad=true
	;;
esac
done
done
