* train.do
clear
sysuse auto
svmachines foreign price-gear_ratio if !missing(rep78), sv(SV)
list SV
do ./helpers/inspect_model.do

