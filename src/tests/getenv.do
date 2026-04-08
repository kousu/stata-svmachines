capture program drop _svm_getenv
program _svm_getenv, plugin
plugin call _svm_getenv, PATH
quietly local stata_path : env PATH
quietly if `"`_getenv'"' != `"`stata_path'"' {
	di as error "getenv did not return the same as Stata"
	error 10
}
