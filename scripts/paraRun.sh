#!/bin/bash

cd /shared/nonrestricted/connectome/NeMo/resources
project_dir=$path
name=`echo $project_dir | rev | cut -d'/' -f 1 | rev | sed 's/[0-9]*//g'`

for i in $( ls | grep $name | sed 's/[^0-9]*//g' ); do
	sem -j $1 chacoRun.sh $i   
	
done

sem --wait