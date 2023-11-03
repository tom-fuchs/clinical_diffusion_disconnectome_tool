cd /shared/studies/nonregulated/connectome/NeMo/resources

echo "addpath(genpath('/shared/studies/nonregulated/connectome/NeMo/resources'));"  >> dti_chaco_script.m
    echo "disp('added path 1st time')" >> dti_chaco_script.m
    echo "addpath(genpath('/shared/studies/nonregulated/connectome/NeMo/resources'));" >> dti_chaco_script.m
    echo "disp('added path 2nd time')" >> dti_chaco_script.m
    echo "addpath(genpath('/shared/studies/nonregulated/connectome/NeMo/resources'));" >> dti_chaco_script.m
    echo "disp('added path 3rd time')" >> dti_chaco_script.m
    echo "disp('attempt chacocalc')" >> dti_chaco_script.m
    echo "try">> dti_chaco_script.m
    echo "ChaCoCalc">> dti_chaco_script.m
    echo "catch">> dti_chaco_script.m
    echo "try">> dti_chaco_script.m
    echo "ChaCoCalc">> dti_chaco_script.m
    echo "catch">> dti_chaco_script.m
    echo "try">> dti_chaco_script.m
    echo "ChaCoCalc">> dti_chaco_script.m
    echo "catch">> dti_chaco_script.m
    echo "disp('end attempt chacocalcs')">> dti_chaco_script.m
    echo "end">> dti_chaco_script.m
    echo "end">> dti_chaco_script.m
    echo "end">> dti_chaco_script.m

echo "ChaCoCalc('$path/subjects/$1/masked_final_deviation.nii',[],'MNI',86,'$path/subjects/$1/default_output',12)" \
    >> dti_chaco_script.m
