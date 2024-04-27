% ѡ��Ҫ���Ƶ�������
n = 1;  % ����Ҫ���Ƶ�һ������

% ����һ�����ݰ���ÿ��20�����ݽ��з���
numIntervals = floor(size(Y, 1) / 20);
groupedData = mat2cell(Y(1:numIntervals*20, n), 20*ones(1, numIntervals), 1);

% �Զ��岻ͬ�����ݶ�Ӧ����ɫ
customColors = [
    0 0.4470 0.7410;      % ��ɫ
    0.8500 0.3250 0.0980;      % ��ɫ
    0.9290 0.6940 0.1250;      % ��ɫ
    0.4940 0.1840 0.5560;  % ��ɫ
    0.4660 0.6740 0.1880;  % ��ɫ
    0.3010 0.7450 0.9330;  % ��ɫ
    0.6350 0.0780 0.1840;      % ��ɫ
];

% ���ƶ������ͼ��ÿ������һ������ͼ��
figure;
hold on;
for i = 1:numIntervals
    % ���Ƶ�ǰ�����ݵ�����ͼ
    bp = boxplot(groupedData{i}, 'Positions', i, 'Widths', 0.5); % ������Ⱥ��
    
    % �Զ������������ɫ
    h = findobj(bp, 'Tag', 'Box');
    patch(get(h(1), 'XData'), get(h(1), 'YData'), customColors(i, :), 'EdgeColor', 'k'); % �������������ɫ
    
    % ������λ����
    medians = findobj(bp, 'Tag', 'Median');
    for j = 1:length(medians)
        medianX = get(medians(j), 'XData');
        medianY = get(medians(j), 'YData');
        line(medianX, medianY, 'Color', 'k', 'LineWidth', 1.5); % ������λ����
    end
    
    % ����ƽ��ֵΪ��ɫԲȦ
    avgValue = mean(groupedData{i});
    plot(i, avgValue, 'ro', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'white', 'MarkerSize', 5, 'LineWidth', 1.5);
end

% ����ͼ������
ax = gca;
ax.FontSize = 20;  % ���������С
ax.FontName = 'Times New Roman';  % ��������Ϊ������
ax.FontWeight = 'bold';  % ��������Ӵ�
ax.LineWidth = 2;  % ����������������ϸΪ2

% ���ͼ�����ͱ�ǩ
title('');
xlabel('Tea Drying Stages');
ylabel('GLHD entropy');

% ���� Y �����귶Χ�����ݻ�ͼ�������ݣ�
ylim([min(Y(:, n))-0.05, max(Y(:, n))+0.05]);

% ���� X ��̶Ⱥͱ�ǩ
set(gca, 'XTick', 1:numIntervals, 'XTickLabel', 1:numIntervals);

% ȥ��ͼ��߿���Ҳ�/�ϲ�̶���
box off;
ax.TickDir = 'out';
ax.XAxis.TickLength = [0.01, 0.01];  
ax.YAxis.TickLength = [0.01, 0.01];  

hold off;