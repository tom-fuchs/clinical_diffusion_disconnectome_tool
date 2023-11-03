cd /shared/studies/nonregulated/connectome/NeMo/resources

#echo "fileID = fopen('exptable.txt','a');" >> dti_chaco_script$2.m
#echo "fprintf(fileID, 'Exponential Function\n\n');" >> dti_chaco_script$2.m
#echo "exit" >> dti_chaco_script$2.m

#echo "N = maxNumCompThreads" >> dti_chaco_script$2.m
#echo "exit" >> dti_chaco_script$2.m

echo "addpath(genpath('/shared/studies/nonregulated/connectome/NeMo/resources'));"  >> dti_chaco_script$2.m
echo "disp('added path 1st time')" >> dti_chaco_script$2.m
echo "addpath(genpath('/shared/studies/nonregulated/connectome/NeMo/resources'));" >> dti_chaco_script$2.m
echo "disp('added path 2nd time')" >> dti_chaco_script$2.m
echo "addpath(genpath('/shared/studies/nonregulated/connectome/NeMo/resources'));" >> dti_chaco_script$2.m
echo "disp('added path 3rd time')" >> dti_chaco_script$2.m
echo "disp('attempt chacocalc')" >> dti_chaco_script$2.m
echo "try">> dti_chaco_script$2.m
echo "ChaCoCalc">> dti_chaco_script$2.m
echo "catch">> dti_chaco_script$2.m
echo "try">> dti_chaco_script$2.m
echo "ChaCoCalc">> dti_chaco_script$2.m
echo "catch">> dti_chaco_script$2.m
echo "try">> dti_chaco_script$2.m
echo "ChaCoCalc">> dti_chaco_script$2.m
echo "catch">> dti_chaco_script$2.m
echo "disp('end attempt chacocalcs')">> dti_chaco_script$2.m
echo "end">> dti_chaco_script$2.m
echo "end">> dti_chaco_script$2.m
echo "end">> dti_chaco_script$2.m

echo "ChaCoCalc('$path/subjects/$2/fa_dev_nemo_input.nii',[],'MNI',86,'$path/subjects/$2/default_output',$1)" \
	    >> dti_chaco_script$2.m
echo "exit">> dti_chaco_script$2.m
