% 选择要绘制的数据列
n = 1;  % 假设要绘制第一列数据

% 将第一列数据按照每组20个数据进行分组
numIntervals = floor(size(Y, 1) / 20);
groupedData = mat2cell(Y(1:numIntervals*20, n), 20*ones(1, numIntervals), 1);

% 自定义不同组数据对应的颜色
customColors = [
    0 0.4470 0.7410;      % 蓝色
    0.8500 0.3250 0.0980;      % 红色
    0.9290 0.6940 0.1250;      % 绿色
    0.4940 0.1840 0.5560;  % 棕色
    0.4660 0.6740 0.1880;  % 青色
    0.3010 0.7450 0.9330;  % 紫色
    0.6350 0.0780 0.1840;      % 黄色
];

% 绘制多个箱线图（每个区间一个箱线图）
figure;
hold on;
for i = 1:numIntervals
    % 绘制当前组数据的箱线图
    bp = boxplot(groupedData{i}, 'Positions', i, 'Widths', 0.5); % 隐藏离群点
    
    % 自定义箱体填充颜色
    h = findobj(bp, 'Tag', 'Box');
    patch(get(h(1), 'XData'), get(h(1), 'YData'), customColors(i, :), 'EdgeColor', 'k'); % 设置箱体填充颜色
    
    % 绘制中位数线
    medians = findobj(bp, 'Tag', 'Median');
    for j = 1:length(medians)
        medianX = get(medians(j), 'XData');
        medianY = get(medians(j), 'YData');
        line(medianX, medianY, 'Color', 'k', 'LineWidth', 1.5); % 绘制中位数线
    end
    
    % 绘制平均值为红色圆圈
    avgValue = mean(groupedData{i});
    plot(i, avgValue, 'ro', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'white', 'MarkerSize', 5, 'LineWidth', 1.5);
end

% 设置图表属性
ax = gca;
ax.FontSize = 20;  % 设置字体大小
ax.FontName = 'Times New Roman';  % 设置字体为新罗马
ax.FontWeight = 'bold';  % 设置字体加粗
ax.LineWidth = 2;  % 设置坐标轴线条粗细为2

% 添加图表标题和标签
title('');
xlabel('Tea Drying Stages');
ylabel('GLHD entropy');

% 设置 Y 轴坐标范围（根据绘图的列数据）
ylim([min(Y(:, n))-0.05, max(Y(:, n))+0.05]);

% 设置 X 轴刻度和标签
set(gca, 'XTick', 1:numIntervals, 'XTickLabel', 1:numIntervals);

% 去除图表边框和右侧/上侧刻度线
box off;
ax.TickDir = 'out';
ax.XAxis.TickLength = [0.01, 0.01];  
ax.YAxis.TickLength = [0.01, 0.01];  

hold off;