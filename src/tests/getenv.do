capture program drop _svm_getenv
program _svm_getenv, plugin
plugin call _svm_getenv, PATH
di "_getenv=`_getenv'"
