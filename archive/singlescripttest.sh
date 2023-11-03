cd /shared/studies/nonregulated/connectome/NeMo/resources/
rm -f dti_chaco_script*

project_dir=$path
ms_list=$project_dir/subject_lists/ms_ids.csv

instances=$1

len=$(wc $ms_list | cut -d " " -f2)

#add some nonsense to the top of every script because chacocalc is inconsistent 
cd /shared/studies/nonregulated/connectome/NeMo/resources/
echo "addpath(genpath('/shared/studies/nonregulated/connectome/NeMo/resources'));"  >> dti_chaco_script$index.m
echo "disp('added path 1st time')" >> dti_chaco_script$index.m
echo "addpath(genpath('/shared/studies/nonregulated/connectome/NeMo/resources'));" >> dti_chaco_script$index.m
echo "disp('added path 2nd time')" >> dti_chaco_script$index.m
echo "addpath(genpath('/shared/studies/nonregulated/connectome/NeMo/resources'));" >> dti_chaco_script$index.m
echo "disp('added path 3rd time')" >> dti_chaco_script$index.m
echo "disp('attempt chacocalc')" >> dti_chaco_script$index.m
echo "try">> dti_chaco_script$index.m
echo "ChaCoCalc">> dti_chaco_script$index.m
echo "catch">> dti_chaco_script$index.m
echo "try">> dti_chaco_script$index.m
echo "ChaCoCalc">> dti_chaco_script$index.m
echo "catch">> dti_chaco_script$index.m
echo "try">> dti_chaco_script$index.m
echo "ChaCoCalc">> dti_chaco_script$index.m
echo "catch">> dti_chaco_script$index.m
echo "disp('end attempt chacocalcs')">> dti_chaco_script$index.m
echo "end">> dti_chaco_script$index.m
echo "end">> dti_chaco_script$index.m
echo "end">> dti_chaco_script$index.m

#loop over the list of MS scans 
for i in $( cat $ms_list  ); do

    #add actual call to chacocalc for each scan 
    echo "ChaCoCalc('$path/subjects/$i/masked_final_deviation.nii',[],'MNI',86,'$path/subjects/$i/default_output',12)" \
    >> dti_chaco_script.m
done

echo Done!
echo ""
echo Script located in:
echo /shared/studies/nonregulated/connectome/NeMo/resources
echo ""
