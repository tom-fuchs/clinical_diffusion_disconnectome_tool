
ms_list=$path/subject_lists/ms_ids.csv

cd /shared/studies/nonregulated/connectome/NeMo/resources

rm -f dti_chaco_script*

for i in $( cat $ms_list  ); do
	bash $DTIPATH/makechacoscript.sh $1 $i  
		        
done


for i in $( cat $ms_list  ); do
	sem -j $1 matlab -nodesktop -nosplash -r "run dti_chaco_script$i.m;"   
	
done

sem --wait


