#!/bin/bash

path=$path

echo "provide file name for MS subject list"
read ms_list
ids=$path/subject_lists/$ms_list

mkdir -p $path/qc

	qc_path=$path/qc
        echo ""
        echo "Saving scans as image files for review and quality control..."
        for i in $( cat $ids ); do
	      echo $i
           python -W ignore $DTIPATH/scripts/qc_output.py $path/subjects/$i/dti_FA.nii.gz $i\_fa $qc_path $i $path "FA" 'a' $path/subjects/$i
	   python -W ignore $DTIPATH/scripts/qc_output.py $path/subjects/$i/dti_FA_to_MNI.nii.gz $i\_fa_mni $qc_path $i $path "FA in MNI" 'b' $path/subjects/$i
	   python -W ignore $DTIPATH/scripts/qc_output.py $path/subjects/$i/masked_final_deviation.nii.gz $i\_fa_dev $qc_path $i $path "Deviation map" 'c' $path/subjects/$i

   done

	img_path=$path/qc
	rm -f $img_path/qc_output_view.html


cd $path/qc

echo "<!DOCTYPE html>"  >> qc_output_view.html
echo "<html>"  >> qc_output_view.html
echo "<head>"  >> qc_output_view.html
echo "<style>"  >> qc_output_view.html
echo "</head>"  >> qc_output_view.html
echo "<body>"  >> qc_output_view.html


for i in $( ls $img_path ); do
	line="<center><img src='$path/qc/$i' style='width:600px;height:250px;'></center><br><br><br><br><br>"
        echo $line >> qc_output_view.html
	#echo "yeet"
done

echo "</body>"  >> qc_output_view.html
echo "</html>"  >> qc_output_view.html


libreoffice --convert-to pdf qc_output_view.html

echo ""
echo "------------"
echo "PDF with all images can be found in the qc directory"
echo "To view, open in your favorite browser or PDF viewer!"
echo "------------"
echo ""
