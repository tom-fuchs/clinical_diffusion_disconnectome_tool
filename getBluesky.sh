#!/bin/bash

dir=$path
#format of csv has to be subjectIdNum,date
echo "provide file name for the csv that you want scan IDs for (with file extension)"
read csv_name
csv=$path/subject_lists/$csv_name

echo "provide file name for the csv that you want scan IDs to save to (with file extension)"
read csv_name2
save_to=$path/subject_lists/$csv_name2

for i in $( cat $csv ); do
    IFS=','
    read -ra ADDR <<< "$i" # str is read into an array as tokens separated by IFS
    sub_id=${ADDR[0]}
    date=${ADDR[1]}
    echo SU$sub_id the "sub id"
    echo `bluesky_info -i BBS -o SU$sub_id | grep $date | cut -c3-9` >> scan_ids_temp.csv
    scan_id_file='scan_ids_temp.csv'
    IFS=$'\r\n'
    content=$( cat ${scan_id_file} )
    IFS=' '
    read -ra contentArr <<< "$content"
    for ((idx = 0; idx < ${#contentArr[@]}; idx+=1)); do
        scan=${contentArr[idx]}
        echo `bluesky_info -i BBS -o $scan | grep DTI` >> temp.csv 
        numb=`grep -c "DTI" temp.csv`
        if [ $numb > 0 ]; then
            echo $scan "the scan ID"
            echo $scan,$sub_id,$date >> $save_to
            break
        fi
        rm temp.csv
    done
    rm scan_ids_temp.csv
done
