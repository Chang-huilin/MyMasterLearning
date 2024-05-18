% t-SNE
%%  导入数据

% 数据标准化
Z = zscore(X);

% 划分数据为7个阶段
num_stages = 7;
stage_size = ceil(size(Z, 1) / num_stages); % 每个阶段的样本数量

% 使用 t-SNE 进行降维
num_dims = 2; % 指定降维后的维度为2
perplexity = 30; % t-SNE 参数：perplexity
tsne_result = tsne(Z, 'NumDimensions', num_dims, 'Perplexity', perplexity);

% 绘制 t-SNE 的结果，每个阶段用不同颜色表示
figure;
hold on;
colors = parula(num_stages); % 生成不同阶段的颜色

for i = 1:num_stages
    start_idx = (i - 1) * stage_size + 1;
    end_idx = min(i * stage_size, size(Z, 1));
    scatter(tsne_result(start_idx:end_idx, 1), tsne_result(start_idx:end_idx, 2), [], colors(i,:), 'filled');
end

hold off;
% 设置字体和字体大小
set(gca, 'FontName', 'Times New Roman', 'FontSize', 24);

% 设置边框宽度
set(gca, 'LineWidth', 2);

xlabel('t-SNE Dimension 1');
ylabel('t-SNE Dimension 2');
title('t-SNE Plot with Different Stages');

% 添加图例显示不同阶段
legend_cell = arrayfun(@(x) sprintf('Stage %d', x), 1:num_stages, 'UniformOutput', false);
legend(legend_cell);
