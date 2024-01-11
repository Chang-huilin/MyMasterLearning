% 假设 X 是你的数据矩阵，大小为 140x25



% 标准化数据
X_standardized = zscore(X);

% 使用 pca 函数进行主成分分析，保留前 10 个主成分
num_principal_components = 10;
[coeff, score, ~, ~, explained] = pca(X_standardized, 'NumComponents', num_principal_components);

% 显示累积方差贡献图
figure;
plot(cumsum(explained), 'o-');
xlabel('主成分数');
ylabel('累积方差贡献（%）');
title('累积方差贡献图');

% score 矩阵包含了每个样本在前 10 个主成分上的投影
disp('前 10 个主成分的投影矩阵:');
disp(score);
