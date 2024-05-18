% pca

%%  ��������

file_path = 'C:\Users\79365\Desktop\ͼ��-Ҷ����\Ҷ����\matlab����\35.mat';

% ʹ��load������������
load(file_path);

% ���ݱ�׼��
Z = zscore(X);

% ����Э�������
C = cov(Z);

% ����ֵ�ֽ�
[V, D] = eig(C);

% ��������ֵ��С������������
[~, idx] = sort(diag(D), 'descend');
principal_components = V(:, idx); % ѡ�����ɷ�

% ֻ�����������ɷֽ���ͶӰ
num_components = 2; % ѡ��Ҫ���������ɷ�����
reduced_data = Z * principal_components(:, 1:num_components); % ����ͶӰ

% ����׶ε���ɫӳ��
num_stages = ceil(size(X, 1) / 20); % ����׶�����
colors = parula(num_stages); % ���ɲ�ͬ�׶ε���ɫ

% �������ɷַ����Ľ����ÿ���׶��ò�ͬ��ɫ��ʾ
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

% ���ͼ����ʾ��ͬ�׶�
legend_cell = arrayfun(@(x) sprintf('Stage %d', x), 1:num_stages, 'UniformOutput', false);
legend(legend_cell);

% ��ʾ���ɷֵķ�����ͱ���
explained_variance_ratio = diag(D(idx, idx)) / sum(diag(D));
disp('Explained Variance Ratio of Principal Components:');
disp(explained_variance_ratio);

% ��ʾ�ۼƷ�����ͱ���
cumulative_variance_ratio = cumsum(explained_variance_ratio);
disp('Cumulative Explained Variance Ratio:');
disp(cumulative_variance_ratio);
