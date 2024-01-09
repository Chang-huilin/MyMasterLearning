% 假设X是输入特征矩阵，Y是响应变量向量
% 使用train_test_split函数将数据集分为训练集和测试集
rng(1); % 设置随机数种子以确保可重复性
cv = cvpartition(size(X, 1), 'HoldOut', 0.6); % 80%的数据作为训练集
X_train = X(cv.training,:);
Y_train = Y(cv.training,:);
X_test = X(cv.test,:);
Y_test = Y(cv.test,:);

% 创建PLS模型，选择主成分的数量（n_components）
n_components = 10; % 这里选择2个主成分，你可以根据需要选择
[XL,~,Xs,~,beta,PCTVAR,MSE,stats] = plsregress(X_train, Y_train, n_components);

% 使用PLS模型进行预测
Y_pred = [ones(size(X_test, 1), 1) X_test] * beta;

% 计算均方根误差（RMSE）
mse = immse(Y_test, Y_pred);
rmse = sqrt(mse);
disp(['均方根误差（RMSE）：', num2str(rmse)]);