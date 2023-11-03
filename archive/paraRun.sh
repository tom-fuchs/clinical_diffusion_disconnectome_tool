#!/bin/bash

cd /shared/studies/nonregulated/connectome/NeMo/resources

for i in $( ls | grep dti | sed 's/[^0-9]*//g' ); do
	sem -j $1 chacoRun.sh $i   
	
done

sem --wait


