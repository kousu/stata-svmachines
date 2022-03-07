* export_svmlight.do
clear
sysuse auto
capture rm "./auto.svmlight"
// notice: auto contains a string variable and its class variable is last
// we explicitly rearrange them during the export stating the order of variables (Stata handles the indirection, hiding it from the plugin)
export_svmlight foreign price-gear_ratio using "./auto.svmlight"
type "./auto.svmlight", lines(10)
