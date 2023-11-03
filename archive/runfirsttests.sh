cd /shared/studies/nonregulated/connectome/NeMo/resources/

rm chacotest.m

echo "addpath(genpath('/shared/studies/nonregulated/connectome/NeMo/resources'));"  >> chacotest.m
echo "disp('added path 1st time')" >> chacotest.m
echo "addpath(genpath('/shared/studies/nonregulated/connectome/NeMo/resources'));" >> chacotest.m
echo "disp('added path 2nd time')" >> chacotest.m
echo "addpath(genpath('/shared/studies/nonregulated/connectome/NeMo/resources'));" >> chacotest.m
echo "disp('added path 3rd time')" >> chacotest.m
echo "disp('attempt chacocalc')" >> chacotest.m
echo "try">> chacotest.m
echo "ChaCoCalc">> chacotest.m
echo "catch">> chacotest.m
echo "try">> chacotest.m
echo "ChaCoCalc">> chacotest.m
echo "catch">> chacotest.m
echo "try">> chacotest.m
echo "ChaCoCalc">> chacotest.m
echo "catch">> chacotest.m
echo "disp('end attempt chacocalcs')">> chacotest.m
echo "end">> chacotest.m
echo "end">> chacotest.m
echo "end">> chacotest.m
echo "exit">> chacotest.m
