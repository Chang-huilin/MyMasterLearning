% ���� Y ������һ�� 140x3 �ľ���ÿ�зֱ����Ҷ���� a��Ҷ���� b��Ҷ����

% ����׶���Ϊ 7��ÿ���׶��� 20 ������
num_stages = 7;
samples_per_stage = 20;

% ��ʼ���洢ÿ���׶�ƽ��ֵ������
stage_means = zeros(num_stages, 3); % 7�У��׶�����x 3�У�ָ������

% ����ÿ���׶ε�ƽ��ֵ
for stage = 1:num_stages
    % ��ȡ��ǰ�׶ε�����������Χ
    sample_start = (stage - 1) * samples_per_stage + 1;
    sample_end = stage * samples_per_stage;
    
    % ��ȡ��ǰ�׶ε���������
    stage_samples = Y(sample_start:sample_end, :);
    
    % ���㵱ǰ�׶ε�ƽ��ֵ��ÿ�е�ƽ��ֵ��
    stage_mean = mean(stage_samples, 1); % ���ŵ�һά���У�����ƽ��ֵ
    
    % �洢��ǰ�׶ε�ƽ��ֵ
    stage_means(stage, :) = stage_mean;
end

% ����ÿ���׶ε���״ͼλ��
bar_positions = 1:num_stages; % ÿ���׶ε�λ��

% ������ɫ
colors = lines(3); % ���ɰ���������ɫ�ĵ�ɫ��

% ������״ͼ
figure;
hold on;
bar(bar_positions - 0.2, stage_means(:, 1), 0.2, 'FaceColor', colors(1, :), 'EdgeColor', 'none'); % ��һ��ָ�������
bar(bar_positions, stage_means(:, 2), 0.2, 'FaceColor', colors(2, :), 'EdgeColor', 'none'); % �ڶ���ָ�������
bar(bar_positions + 0.2, stage_means(:, 3), 0.2, 'FaceColor', colors(3, :), 'EdgeColor', 'none'); % ������ָ�������

% ���ͼ���ͱ�ǩ
legend('Chlorophyll a', 'Chlorophyll b', 'Total Chlorophyll', 'FontSize', 14, 'FontName', 'Times New Roman');
xlabel('Stage', 'FontSize', 20, 'FontName', 'Times New Roman');
ylabel('Mean Value', 'FontSize', 20, 'FontName', 'Times New Roman');
title('Mean Values of Chlorophylls Across Stages', 'FontSize', 24, 'FontName', 'Times New Roman');
xticks(1:num_stages); % ���� x ��̶�Ϊ�׶���
xticklabels({'Stage 1', 'Stage 2', 'Stage 3', 'Stage 4', 'Stage 5', 'Stage 6', 'Stage 7'});
% ���� x ���ǩΪ�����׶�

% ����������Ĵ�ϸ
ax = gca; % ��ȡ��ǰ���������
ax.XAxis.LineWidth = 2; % ���� x ���ϸ
ax.YAxis.LineWidth = 2; % ���� y ���ϸ
ax.TickDir = 'out';
ax.XAxis.TickLength = [0.01, 0.01];  
ax.YAxis.TickLength = [0.01, 0.01];  
hold off;