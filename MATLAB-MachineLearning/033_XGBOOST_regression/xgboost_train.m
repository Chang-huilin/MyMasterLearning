function model = xgboost_train(p_train, t_train, params, max_num_iters)
%%% Function inputs:
% p_train:        matrix of inputs for the training set
% t_train:        vetor of labels/values for the test set
% params :        structure of learning parameters
% max_num_iters: max number of iterations for learning
 
%%% Function output:
% model: a structure containing:
%     iters_optimal; % number of iterations performs by xgboost (final model)
%     h_booster_ptr; % pointer to the final model
%     params;        % model parameters (just for info)
%     missing;       % value considered "missing"
 
%% 加载 xgboost 库
loadlibrary('xgboost')
 
%% 设置参数
missing = single(NaN);          % 设置该值被视为"缺失"
iters_optimal = max_num_iters;  % 最大迭代次数
 
%% 设置xgboost的相关参数
if isempty(params)
    params.booster           = 'gbtree';
    % params.objective         = 'binary:logistic';
    params.objective         = 'reg:linear';
    params.max_depth         = 5;
    params.eta               = 0.1;
    params.min_child_weight  = 1;
    params.subsample         = 0.9;
    params.colsample_bytree  = 1;
    params.num_parallel_tree = 1;
end