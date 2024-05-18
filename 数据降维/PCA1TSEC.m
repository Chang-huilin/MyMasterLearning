% pca

%%  导入数据

file_path = 'C:\Users\79365\Desktop\图像-叶绿素\叶绿素\matlab数据\35.mat';

% 使用load函数导入数据
load(file_path);

% 数据标准化
Z = zscore(X);

% 计算协方差矩阵
C = cov(Z);

% 特征值分解
[V, D] = eig(C);

% 根据特征值大小排序特征向量
[~, idx] = sort(diag(D), 'descend');
principal_components = V(:, idx); % 选择主成分

% 只保留部分主成分进行投影
num_components = 2; % 选择要保留的主成分数量
reduced_data = Z * principal_components(:, 1:num_components); % 数据投影

% 定义阶段的颜色映射
num_stages = ceil(size(X, 1) / 20); % 计算阶段数量
colors = parula(num_stages); % 生成不同阶段的颜色

% 绘制主成分分析的结果，每个阶段用不同颜色表示
figure;
hold on;
for i = 1:num_stages
    idx_range = (20*(i-1) + 1) : min(20*i, size(reduced_data, 1));
    scatter(reduced_data(idx_range, 1), reduced_data(idx_range, 2), [], colors(i,:), 'filled');
end
hold off;

xlabel('Principal Component 1');
ylabel('Principal Component 2');
title('PCA Plot with Different Stages');

% 添加图例显示不同阶段
legend_cell = arrayfun(@(x) sprintf('Stage %d', x), 1:num_stages, 'UniformOutput', false);
legend(legend_cell);

% 显示主成分的方差解释比例
explained_variance_ratio = diag(D(idx, idx)) / sum(diag(D));
disp('Explained Variance Ratio of Principal Components:');
disp(explained_variance_ratio);

% 显示累计方差解释比例
cumulative_variance_ratio = cumsum(explained_variance_ratio);
disp('Cumulative Explained Variance Ratio:');
disp(cumulative_variance_ratio);
