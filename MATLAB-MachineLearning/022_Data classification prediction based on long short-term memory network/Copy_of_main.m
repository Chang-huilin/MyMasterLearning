%%  ��ջ�������
warning off             % �رձ�����Ϣ
close all               % �رտ�����ͼ��
clear                   % ��ձ���
clc                     % ���������

%%  ��������
file_path = "C:\Users\79365\Desktop\�о���\����\data.mat";

% ʹ��load������������
load(file_path);

%%  ����ѵ�����Ͳ��Լ�
temp = randperm(175);

P_train = res(temp(1: 125), 2: 33)';
T_train = res(temp(1: 125), 1)';
M = size(P_train, 2);

P_test = res(temp(125: end), 2: 33)';
T_test = res(temp(125: end), 1)';
N = size(P_test, 2);

%%  ���ݹ�һ��
[P_train, ps_input] = mapminmax(P_train, 0, 1);
P_test = mapminmax('apply', P_test, ps_input);

t_train = categorical(T_train)';
t_test  = categorical(T_test )';

%%  ����ƽ��
% ������ƽ�̳�1ά����ֻ��һ�ִ���ʽ
% Ҳ����ƽ�̳�2ά���ݣ��Լ�3ά���ݣ���Ҫ�޸Ķ�Ӧģ�ͽṹ
% ����Ӧ��ʼ�պ���������ݽṹ����һ��
P_train =  double(reshape(P_train, 32, 1, M));
P_test  =  double(reshape(P_test , 32, 1, N));
% ת�����ݸ�ʽΪLSTM�������������ʽ
p_train = cell(M, 1);
p_test  = cell(N, 1);
%%  ���ݸ�ʽת��
for i = 1 : M
    p_train{i, 1} = P_train(:, :,  i);
end

for i = 1 : N
    p_test{i, 1} = P_test( :, :,  i);
end

layers = [
    sequenceInputLayer(32)                    % �����
    
    lstmLayer(48, 'OutputMode', 'last')       % ��һ��LSTM�㣬���ģʽΪlast
    batchNormalizationLayer                   % ������һ����
    reluLayer                                 % Relu�����
   
    dropoutLayer(0.5)                         % Dropout�㣬��ֹ�����
    fullyConnectedLayer(60)                   % ȫ���Ӳ㣬������Ԫ����
    reluLayer                                 % Relu�����
    
    fullyConnectedLayer(7)                    % ȫ���Ӳ㣬���Ϊ7�����
    softmaxLayer                              % Softmax�����
    classificationLayer                       % �����
];

%%  ��������
options = trainingOptions('adam', ...         % ʹ��Adam�Ż��㷨
    'MaxEpochs', 500, ...                    % ����������
    'InitialLearnRate', 0.01, ...            % ��ʼѧϰ��
    'LearnRateSchedule', 'piecewise', ...     % ѧϰ���½�
    'LearnRateDropFactor', 0.01, ...           % ѧϰ���½�����
    'LearnRateDropPeriod', 750, ...           % ���� 750 ��ѵ���� ѧϰ���½�
    'Shuffle', 'every-epoch', ...             % ÿ��ѵ���������ݼ�
    'ValidationPatience', Inf, ...            % �ر���֤
    'Plots', 'training-progress', ...         % ��������
    'Verbose', false);


%%  ѵ��ģ��
net = trainNetwork(p_train, t_train, layers, options);

%%  ����Ԥ��
t_sim1 = predict(net, p_train); 
t_sim2 = predict(net, p_test ); 

%%  ���ݷ���һ��
T_sim1 = vec2ind(t_sim1');
T_sim2 = vec2ind(t_sim2');

%%  ��������
error1 = sum((T_sim1 == T_train)) / M * 100 ;
error2 = sum((T_sim2 == T_test )) / N * 100 ;

% %%  �鿴����ṹ
% analyzeNetwork(net)

%%  ��������
[T_train, index_1] = sort(T_train);
[T_test , index_2] = sort(T_test );

T_sim1 = T_sim1(index_1);
T_sim2 = T_sim2(index_2);

% %%  ��ͼ
% figure
% plot(1: M, T_train, 'r-*', 1: M, T_sim1, 'b-o', 'LineWidth', 1)
% legend('��ʵֵ', 'Ԥ��ֵ')
% xlabel('Ԥ������')
% ylabel('Ԥ����')
% string = {'ѵ����Ԥ�����Ա�'; ['׼ȷ��=' num2str(error1) '%']};
% title(string)
% xlim([1, M])
% grid
% 
% figure
% plot(1: N, T_test, 'r-*', 1: N, T_sim2, 'b-o', 'LineWidth', 1)
% legend('��ʵֵ', 'Ԥ��ֵ')
% xlabel('Ԥ������')
% ylabel('Ԥ����')
% string = {'���Լ�Ԥ�����Ա�'; ['׼ȷ��=' num2str(error2) '%']};
% title(string)
% xlim([1, N])
% grid
% 
% %%  ��������
% figure
% cm = confusionchart(T_train, T_sim1);
% cm.Title = 'Confusion Matrix for Train Data';
% cm.ColumnSummary = 'column-normalized';
% cm.RowSummary = 'row-normalized';
% 
% figure
% cm = confusionchart(T_test, T_sim2);
% cm.Title = 'Confusion Matrix for Test Data';
% cm.ColumnSummary = 'column-normalized';
% cm.RowSummary = 'row-normalized';
