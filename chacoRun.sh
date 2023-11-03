#!/bin/bash

#takes number of matlab script to be run as input 
cd /shared/nonrestricted/connectome/NeMo/resources

name=`echo $path | rev | cut -d'/' -f 1 | rev | sed 's/[0-9]*//g'`

chaco=_dti_chaco_script

echo $name$chaco$1.m

#matlab -nodesktop -nosplash -r "addpath(pwd);run $name$chaco$1.m;"
sudo matlab-docker "matlab -nodesktop -nosplash -r 'run neurostream_processing_dti_chaco_script1.m;'"
