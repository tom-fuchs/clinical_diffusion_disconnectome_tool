cd /shared/nonrestricted/connectome/NeMo/resources/

project_dir=$path

name=`echo $project_dir | rev | cut -d'/' -f 1 | rev | sed 's/[0-9]*//g'`

rm -f $name\_dti_chaco_script*

ms_list=$project_dir/subject_lists/neurostream_c_cases_march10.txt

count=0
index=1

instances=$1

len=$(wc $ms_list | cut -d " " -f2)

d=$(($instances - 1))

n=$(($len + $d))

numsubs=$(($n / $instances))

echo ""
echo Creating $instances NeMo scripts...
echo ""
#add some nonsense to the top of every script because chacocalc is inconsistent
cd /shared/nonrestricted/connectome/NeMo/resources/
echo "addpath(genpath('/shared/nonrestricted/connectome/NeMo/resources_matlab'));"  >> $name\_dti_chaco_script$index.m
echo "disp('added path 1st time')" >> $name\_dti_chaco_script$index.m
echo "addpath(genpath('/shared/nonrestricted/connectome/NeMo/resources_matlab'));" >> $name\_dti_chaco_script$index.m
echo "disp('added path 2nd time')" >> $name\_dti_chaco_script$index.m
echo "addpath(genpath('/shared/nonrestricted/connectome/NeMo/resources_matlab'));" >> $name\_dti_chaco_script$index.m
echo "disp('added path 3rd time')" >> $name\_dti_chaco_script$index.m
echo "disp('attempt chacocalc')" >> $name\_dti_chaco_script$index.m
echo "try">> $name\_dti_chaco_script$index.m
echo "ChaCoCalc">> $name\_dti_chaco_script$index.m
echo "catch">> $name\_dti_chaco_script$index.m
echo "try">> $name\_dti_chaco_script$index.m
echo "ChaCoCalc">> $name\_dti_chaco_script$index.m
echo "catch">> $name\_dti_chaco_script$index.m
echo "try">> $name\_dti_chaco_script$index.m
echo "ChaCoCalc">> $name\_dti_chaco_script$index.m
echo "catch">> $name\_dti_chaco_script$index.m
echo "disp('end attempt chacocalcs')">> $name\_dti_chaco_script$index.m
echo "end">> $name\_dti_chaco_script$index.m
echo "end">> $name\_dti_chaco_script$index.m
echo "end">> $name\_dti_chaco_script$index.m

index=1
#loop over the list of MS scans
for i in $( cat $ms_list  ); do

    #add actual call to chacocalc for each scan
    echo "ChaCoCalc('$path/subjects/$i/fa_dev_nemo_input.nii',[],'MNI',86,'$path/subjects/$i/default_output',12)" \
    >> $name\_dti_chaco_script$index.m
    #index=$(($index + 1))
    count=$(($count + 1))

    if [ $count == $numsubs ]
    then
    echo "exit" >> $name\_dti_chaco_script$index.m
    index=$(($index + 1))
    if [ $index -le $instances ]
    then
    count=0
    echo "addpath(genpath('/shared/nonrestricted/connectome/NeMo/resources_nemo'));"  >> $name\_dti_chaco_script$index.m
    echo "disp('added path 1st time')" >> $name\_dti_chaco_script$index.m
    echo "addpath(genpath('/shared/nonrestricted/connectome/NeMo/resources_nemo'));" >> $name\_dti_chaco_script$index.m
    echo "disp('added path 2nd time')" >> $name\_dti_chaco_script$index.m
    echo "addpath(genpath('/shared/nonrestricted/connectome/NeMo/resources_nemo'));" >> $name\_dti_chaco_script$index.m
    echo "disp('added path 3rd time')" >> $name\_dti_chaco_script$index.m
    echo "disp('attempt chacocalc')" >> $name\_dti_chaco_script$index.m
    echo "try">> $name\_dti_chaco_script$index.m
    echo "ChaCoCalc">> $name\_dti_chaco_script$index.m
    echo "catch">> $name\_dti_chaco_script$index.m
    echo "try">> $name\_dti_chaco_script$index.m
    echo "ChaCoCalc">> $name\_dti_chaco_script$index.m
    echo "catch">> $name\_dti_chaco_script$index.m
    echo "try">> $name\_dti_chaco_script$index.m
    echo "ChaCoCalc">> $name\_dti_chaco_script$index.m
    echo "catch">> $name\_dti_chaco_script$index.m
    echo "disp('end attempt chacocalcs')">> $name\_dti_chaco_script$index.m
    echo "end">> $name\_dti_chaco_script$index.m
    echo "end">> $name\_dti_chaco_script$index.m
    echo "end">> $name\_dti_chaco_script$index.m
    fi
    fi

    done
echo Done!
echo ""
echo Scripts located in:
echo /shared/nonrestricted/connectome/NeMo/resources
echo ""
