#!/bin/bash

#takes number of matlab script to be run as input 
cd /shared/studies/nonregulated/connectome/NeMo/resources

name=`echo $path | rev | cut -d'/' -f 1 | rev | sed 's/[0-9]*//g'`

chaco=_dti_chaco_script

#echo $name$chaco$1.m

matlab -nodesktop -nosplash -r "run $name$chaco$1.m;"
