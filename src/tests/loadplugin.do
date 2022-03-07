* loadplugin.do
* unconditionally unload the plugin
* this is only relevant if this do file is reused in the same session
clear
sysuse auto
svmachines price mpg
clear
capture program drop _svmachines

* load it! 
program _svmachines, plugin
