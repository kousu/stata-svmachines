/* svmachines: the entry point to the support vector fitting algorithm */

program define svmachines
*! version 1.2.3
  version 13
  
  //plugin call does not handle factor variables.
  // xi can pre-expand factors into indicator columns and then evaluate some code.
  // However xi interacts badly with "plugin call"; just tweaking the code that calls into
  // the plugin to read "xi: plugin call _svm, train" fails. xi needs to run pure Stata.
  // Further, xi runs its passed code in the global scope and can't access inner routines,
  // which means the pure Stata must be in a *separate file* (_svm_train.ado).
  xi: _svm_train `0'        
end
// Version History
// version 1.2.3 April 2026, distribute libsvm v3.2.5 embedded within _svmachines.plugin, instead of distributing libsvm.dll on Windows, libsvm.dylib on macOS, or asking Linux users to install libsvm.so separately.
// version 1.2.2 Aug 2021, _svm_model2stata.ado: only saving support vectors up to size 11,000 unless Stata MP is used
// version 1.2.1 June 2020, Predictions vars take the same type as y. If y is int/byte/double, this was a problem for regression.
