% 假设 Y 矩阵是一个 140x3 的矩阵，每列分别代表叶绿素 a、叶绿素 b、叶绿素

% 假设阶段数为 7，每个阶段有 20 个样本
num_stages = 7;
samples_per_stage = 20;

% 初始化存储每个阶段平均值的数组
stage_means = zeros(num_stages, 3); % 7行（阶段数）x 3列（指标数）

% 计算每个阶段的平均值
for stage = 1:num_stages
    % 获取当前阶段的样本索引范围
    sample_start = (stage - 1) * samples_per_stage + 1;
    sample_end = stage * samples_per_stage;
    
    % 提取当前阶段的样本数据
    stage_samples = Y(sample_start:sample_end, :);
    
    % 计算当前阶段的平均值（每列的平均值）
    stage_mean = mean(stage_samples, 1); % 沿着第一维（行）计算平均值
    
    % 存储当前阶段的平均值
    stage_means(stage, :) = stage_mean;
end

% 设置每个阶段的柱状图位置
bar_positions = 1:num_stages; % 每个阶段的位置

% 设置颜色
colors = lines(3); % 生成包含三种颜色的调色板

% 画出柱状图
figure;
hold on;
bar(bar_positions - 0.2, stage_means(:, 1), 0.2, 'FaceColor', colors(1, :), 'EdgeColor', 'none'); % 第一个指标的柱子
bar(bar_positions, stage_means(:, 2), 0.2, 'FaceColor', colors(2, :), 'EdgeColor', 'none'); % 第二个指标的柱子
bar(bar_positions + 0.2, stage_means(:, 3), 0.2, 'FaceColor', colors(3, :), 'EdgeColor', 'none'); % 第三个指标的柱子

% 添加图例和标签
legend('Chlorophyll a', 'Chlorophyll b', 'Total Chlorophyll', 'FontSize', 14, 'FontName', 'Times New Roman');
xlabel('Stage', 'FontSize', 20, 'FontName', 'Times New Roman');
ylabel('Mean Value', 'FontSize', 20, 'FontName', 'Times New Roman');
title('Mean Values of Chlorophylls Across Stages', 'FontSize', 24, 'FontName', 'Times New Roman');
xticks(1:num_stages); % 设置 x 轴刻度为阶段数
xticklabels({'Stage 1', 'Stage 2', 'Stage 3', 'Stage 4', 'Stage 5', 'Stage 6', 'Stage 7'});
% 设置 x 轴标签为各个阶段

% 调整坐标轴的粗细
ax = gca; % 获取当前坐标轴对象
ax.XAxis.LineWidth = 2; % 设置 x 轴粗细
ax.YAxis.LineWidth = 2; % 设置 y 轴粗细
ax.TickDir = 'out';
ax.XAxis.TickLength = [0.01, 0.01];  
ax.YAxis.TickLength = [0.01, 0.01];  
hold off;