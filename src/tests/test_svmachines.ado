// can only be executed in the ./src/tests folder
capture program drop test_svmachines
program define test_svmachines
	version 15.0

	local all_pass_flag = 1
	
	capture do ethyl.do
	local rc = _rc
	if (`rc' != 0){
		di as error "error with ethyl.do"
		local all_pass_flag = 0
	}

	
	capture do export_svmlight.do
	local rc = _rc
	if (`rc' != 0){
		di as error "error with export_svmlight.do"
		local all_pass_flag = 0
	}

	
	capture do getenv.do
	local rc = _rc
	if (`rc' != 0){
		di "`rc'"
		di as error "error with getenv.do"
		local all_pass_flag = 0
	} 

		
	capture do loadplugin.do
	local rc = _rc
	if (`rc' != 0){
		di as error "error with loadplugin.do"
		local all_pass_flag = 0
	}

	
	capture do predict.do
	local rc = _rc
	if (`rc' != 0){
		di as error "error with predict.do"
		local all_pass_flag = 0
	}

	
	capture do predict_float.do
	local rc = _rc
	if (`rc' != 0){
		di as error "error with predict_float.do"
		local all_pass_flag = 0
	}

	
	capture do predict_float_multiclass.do
	local rc = _rc
	if (`rc' != 0){
		di as error "error with predict_float_multiclass.do"
		local all_pass_flag = 0
	}

	
	capture do predict_oneclass.do
	local rc = _rc
	if (`rc' != 0){
		di as error "error with predict_oneclass.do"
		local all_pass_flag = 0
	}

	
	capture do predict_oneclass_scores.do
	local rc = _rc
	if (`rc' != 0){
		di as error "error with predict_oneclass_scores.do"
		local all_pass_flag = 0
	}

	
	capture do predict_probability.do
	local rc = _rc
	if (`rc' != 0){
		di as error "error with predict_probability.do"
		local all_pass_flag = 0
	}

	
	capture do predict_probability_strangelabels.do
	local rc = _rc
	if (`rc' != 0){
		di as error "error with predict_probability_strangelabels.do"
		local all_pass_flag = 0
	}

	
	capture do predict_scores.do
	local rc = _rc
	if (`rc' != 0){
		di as error "error with predict_scores.do"
		local all_pass_flag = 0
	}

	
	capture do predict_scores_and_probability.do
	local rc = _rc
	if (`rc' != 0){
		di as error "error with predict_scores_and_probability.do"
		local all_pass_flag = 0
	}

	
	capture do predict_scores_multiclass.do
	local rc = _rc
	if (`rc' != 0){
		di as error "error with predict_scores_multiclass.do"
		local all_pass_flag = 0
	}

	
	capture do predict_svr.do
	local rc = _rc
	if (`rc' != 0){
		di as error "error with predict_svr.do"
		local all_pass_flag = 0
	}

	
	capture do predict_svr_scores.do
	local rc = _rc
	if (`rc' != 0){
		di as error "error with predict_svr_scores.do"
		local all_pass_flag = 0
	}

	
	capture do setenv.do
	local rc = _rc 
	if (`rc' != 0){ 
		di as error "error with setenv.do"
		local all_pass_flag = 0
	}

	
	capture do train.do
	local rc = _rc 
	if (`rc' != 0){ 
		di as error "error with train.do"
		local all_pass_flag = 0
	}

	
	capture do train_list_SVs.do
	local rc = _rc 
	if (`rc' != 0){ 
		di as error "error with train_list_SVs.do"
		local all_pass_flag = 0
	}

	
	capture do train_multiclass.do
	local rc = _rc 
	if (`rc' != 0){ 
		di as error "error with train_multiclass.do"
		local all_pass_flag = 0
	}


	capture do train_oneclass.do
	local rc = _rc 
	if (`rc' != 0){ 
		di as error "error with train_oneclass.do"
		local all_pass_flag = 0
	}


	capture do train_sv_offbyone.do
	local rc = _rc 
	if (`rc' != 0){ 
		di as error "error with train_sv_offbyone.do"
		local all_pass_flag = 0
	}


	capture do train_svr.do
	local rc = _rc 
	if (`rc' != 0){ 
		di as error "error with train_svr.do"
		local all_pass_flag = 0
	}


	capture do train_svr_prob.do
	local rc = _rc 
	if (`rc' != 0){ 
		di as error "error with train_svr_prob.do"
		local all_pass_flag = 0
	}
	
	
	if (`all_pass_flag' == 1){
		clear
		di "All tests passed"
	}
	
end
