* train_svr.do
clear
sysuse auto
svmachines price mpg-gear_ratio if !missing(rep78), type(nu_svr) kernel(sigmoid)
do ./helpers/inspect_model.do

