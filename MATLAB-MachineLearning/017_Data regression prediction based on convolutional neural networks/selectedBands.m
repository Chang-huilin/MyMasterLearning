% 加载数据
load('data.mat'); % 假设文件 data.mat 包含变量 X 和 y

% 设置PLS成分数量
numComponents = 10;

% 运行PLS回归
[XL,~,XS,~,beta,PCTVAR,MSE,stats] = plsregress(X, Y, numComponents);

% 获取特征权重
weights = abs(stats.W);

% 选择特征波长，假设我们选择权重最大的前N个特征
N = 5;
[~, idx] = sort(weights, 'descend');
selectedFeatures = idx(1:N);

% 保存选中的特征波长
save('selected_features.mat', 'selectedFeatures');

% 显示选中的特征波长
disp('Selected feature wavelengths (indices):');
disp(selectedFeatures);
