% ����Y��ԭʼ����Ҫ���Ƶ�һ������

% ����һ�����ݰ���20Ϊһ���������
numIntervals = floor(size(Y, 1) / 20);
groupedData = mat2cell(Y(1:numIntervals*20, 1), 20*ones(1, numIntervals), 1);%����ǻ��Ƶڶ������ݣ���Y(1:numIntervals*20, 1)��ΪY(1:numIntervals*20, 2)���Դ�����
% �ֶ����岻ͬ��ɫ
colors = [
    0 0 1;  % ��ɫ
    1 0 0;  % ��ɫ
    0 1 0;  % ��ɫ
    0.5 0.5 0;  % ��ɫ
    0 0.5 0.5;  % ��ɫ
    0.5 0 0.5;  % ��ɫ
];

% ���ƶ������ͼ��ÿ������һ������ͼ��
figure;
hold on;
for i = 1:numIntervals
    boxplot(groupedData{i}, 'Positions', i, 'Widths', 0.5, 'Colors', colors(i, :), 'MedianStyle', 'line');%�����Ҫ��Ⱥ�㣬��������,'symbol','','Labels','��ͼ'
    
    % ���㲢��ʾƽ��ֵ���ÿ���СԲ���ʾ����ɫ������ͼһ�£�
    avgValue = mean(groupedData{i});
    plot(i, avgValue, 'o', 'MarkerEdgeColor', colors(i, :), 'MarkerFaceColor', colors(i, :), 'MarkerSize', 2,'LineWidth', 1.5);  % ����СԲ���ʾƽ��ֵ����ɫ������ͼһ�£�
                                                                                                                                 % ���Ҫ�޸Ĵ�С����MarkerSize��������ָ�Ϊ2����3
end
ax = gca; % ��ȡ��ǰ��������
ax.LineWidth = 1; % �����������������Ϊ1.5
xlabel('��Ҷɱ�����');
ylabel('mGֵ');
title('');
ylim([0.20 0.55]);  % ���������귶ΧΪ0.15��0.30
set(gca, 'XTick', 1:numIntervals, 'XTickLabel', 1:6);  % ���ú������ǩ

box off;%ֻ��ʾ��ߺ��±ߵ�������

set(gca, 'TickDir', 'out');%������̶ȳ��⣬������ڣ���out��Ϊin
hold off;



%ʵ������ͼ
% ����Y��ԭʼ����Ҫ���Ƶ�һ������

% ����һ�����ݰ���20Ϊһ���������
numIntervals = floor(size(Y, 1) / 20);
groupedData = mat2cell(Y(1:numIntervals*20, 2), 20*ones(1, numIntervals), 1);
% �ֶ����岻ͬ��ɫ
customColors = [
    0 0 1;  % ��ɫ
    1 0 0;  % ��ɫ
    0 1 0;  % ��ɫ
    0.5 0.5 0;  % ��ɫ
    0 0.5 0.5;  % ��ɫ
    0.5 0 0.5;  % ��ɫ
];

% ���ƶ������ͼ��ÿ������һ������ͼ��
figure;
hold on;
for i = 1:numIntervals
    bp = boxplot(groupedData{i}, 'Positions', i, 'Widths', 0.5, 'Symbol', ''); % ����SymbolΪ�գ�����ʾ��Ⱥ��
    h = findobj(bp, 'Tag', 'Box');
    patch(get(h(1), 'XData'), get(h(1), 'YData'), customColors(i, :), 'EdgeColor', 'k'); % �������������ɫ
    % ������λ����
    medians = findobj(bp, 'Tag', 'Median');
    for j = 1:length(medians)
        medianX = get(medians(j), 'XData');
        medianY = get(medians(j), 'YData');
        line(medianX, medianY, 'Color', 'k', 'LineWidth', 1.5);%�����ߣ���ɫΪ��ɫ���߿�Ϊ1.5
    end
    avgValue = mean(groupedData{i});
    plot(i, avgValue, 'ro', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'white', 'MarkerSize', 5,'LineWidth', 1.5);
end

ax = gca; % ��ȡ��ǰ��������
ax.LineWidth = 1.5; % �����������������Ϊ1.5
xlabel('��Ҷɱ�����');
ylabel('mGֵ');
title('');
ylim([0.20 0.55]);  % ���������귶ΧΪ0.15��0.30
set(gca, 'XTick', 1:numIntervals, 'XTickLabel', 1:6);  % ���ú������ǩ
box off;
set(gca, 'TickDir', 'out');
hold off;
