%%  ��ջ�������
warning off             % �رձ�����Ϣ
close all               % �رտ�����ͼ��
clear                   % ��ձ���
clc                     % ���������

%%  ��������

file_path = 'C:\Users\79365\OneDrive\����\ͼ��-Ҷ����\Ҷ����\matlab����\�ȷ�ڶ���140.mat';

% ʹ��load������������
load(file_path);

Y=Y(:,3);

%%  ����ѵ�����Ͳ��Լ�
num_total=140;
[z1, z2]=sort(Y);           %#ok<*ASGLU> %��Y��������z1Ϊ��������z2��ӳ����ʲô�ı�
X1=X(1:5:num_total,:);   %ѵ����Ԥ����3:2��(�м�Ϊ5����1:1�����м�Ϊ2��ÿ5����Ϊһ�飬ÿ���� 1��3��5 Ϊѵ����2��4ΪԤ��
X2=X(2:5:num_total,:);
X3=X(3:5:num_total,:);
X4=X(4:5:num_total,:);
X5=X(5:5:num_total,:);

Y1=Y(1:5:num_total,:);   
Y2=Y(2:5:num_total,:);
Y3=Y(3:5:num_total,:);
Y4=Y(4:5:num_total,:);
Y5=Y(5:5:num_total,:);

Xc=[X1;X3;X5];
Xt=[X2;X4];
Yc=[Y1;Y3;Y5];
Yt=[Y2;Y4];

P_train=Xc';
T_train=Yc';
M=size(P_train,2);
P_test=Xt';
T_test=Yt';
N=size(P_test,2);


% �������Y1��Y5��X1��X5
clear Y1 Y2 Y3 Y4 Y5 X1 X2 X3 X4 X5 z1 z2 num_total;

%%  ���ݹ�һ��
[P_train, ps_input] = mapminmax(P_train, 0, 1);
P_test = mapminmax('apply', P_test, ps_input);

[t_train, ps_output] = mapminmax(T_train, 0, 1);
t_test = mapminmax('apply', T_test, ps_output);

%%  ����ƽ��
P_train =  double(reshape(P_train, 25, 1, 1, M));
P_test  =  double(reshape(P_test , 25, 1, 1, N));

t_train = t_train';
t_test  = t_test' ;

%%  ���ݸ�ʽת��
for i = 1 : M
    p_train{i, 1} = P_train(:, :, 1, i);
end

for i = 1 : N
    p_test{i, 1}  = P_test( :, :, 1, i);
end

%%  ����ģ��
layers = [
    sequenceInputLayer(25)               % ���������
    
    lstmLayer(4, 'OutputMode', 'last')  % LSTM��
    reluLayer                           % Relu�����
    
    fullyConnectedLayer(1)              % ȫ���Ӳ�
    regressionLayer];                   % �ع��
 
%%  ��������
options = trainingOptions('adam', ...      % Adam �ݶ��½��㷨
    'MaxEpochs', 1500, ...                 % ����������
    'InitialLearnRate', 0.01, ...          % ��ʼѧϰ��Ϊ 0.01
    'LearnRateSchedule', 'piecewise', ...  % ѧϰ���½�
    'LearnRateDropFactor', 0.1, ...        % ѧϰ���½�����
    'LearnRateDropPeriod', 1200, ...       % ���� 1200 ��ѵ���� ѧϰ��Ϊ 0.01 * 0.1
    'Shuffle', 'every-epoch', ...          % ÿ��ѵ���������ݼ�
    'Plots', 'training-progress', ...      % ��������
    'Verbose', false);

%%  ѵ��ģ��
net = trainNetwork(p_train, t_train, layers, options);

%%  ����Ԥ��
t_sim1 = predict(net, p_train);
t_sim2 = predict(net, p_test );

%%  ���ݷ���һ��
T_sim1 = mapminmax('reverse', t_sim1, ps_output);
T_sim2 = mapminmax('reverse', t_sim2, ps_output);

%%  ���������
error1 = sqrt(sum((T_sim1' - T_train).^2) ./ M);
error2 = sqrt(sum((T_sim2' - T_test ).^2) ./ N);

%%  �鿴����ṹ
analyzeNetwork(net)

%%  ��ͼ
figure
plot(1: M, T_train, 'r-*', 1: M, T_sim1, 'b-o', 'LineWidth', 1)
legend('��ʵֵ', 'Ԥ��ֵ')
xlabel('Ԥ������')
ylabel('Ԥ����')
string = {'ѵ����Ԥ�����Ա�'; ['RMSE=' num2str(error1)]};
title(string)
xlim([1, M])
grid

figure
plot(1: N, T_test, 'r-*', 1: N, T_sim2, 'b-o', 'LineWidth', 1)
legend('��ʵֵ', 'Ԥ��ֵ')
xlabel('Ԥ������')
ylabel('Ԥ����')
string = {'���Լ�Ԥ�����Ա�'; ['RMSE=' num2str(error2)]};
title(string)
xlim([1, N])
grid

%%  ���ָ�����
% R2
R1 = 1 - norm(T_train - T_sim1')^2 / norm(T_train - mean(T_train))^2;
R2 = 1 - norm(T_test  - T_sim2')^2 / norm(T_test  - mean(T_test ))^2;

disp(['ѵ�������ݵ�R2Ϊ��', num2str(R1)])
disp(['���Լ����ݵ�R2Ϊ��', num2str(R2)])
% ����ƽ����
Rc = sqrt(R1);
Rp = sqrt(R2);

% ������
disp(['RcΪ��', num2str(Rc)]);
disp(['RpΪ��', num2str(Rp)]);

% MAE
mae1 = sum(abs(T_sim1' - T_train)) ./ M ;
mae2 = sum(abs(T_sim2' - T_test )) ./ N ;

disp(['ѵ�������ݵ�MAEΪ��', num2str(mae1)])
disp(['���Լ����ݵ�MAEΪ��', num2str(mae2)])

% MBE
mbe1 = sum(T_sim1' - T_train) ./ M ;
mbe2 = sum(T_sim2' - T_test ) ./ N ;

disp(['ѵ�������ݵ�MBEΪ��', num2str(mbe1)])
disp(['���Լ����ݵ�MBEΪ��', num2str(mbe2)])
%% 

% �����׼���ݣ�ʵ�ʹ۲����ݣ��ı�׼��
sd_reference_train = std(T_train);
sd_reference_test = std(T_test);

% ����RPD
rpd_train = sd_reference_train / error1;  % ʹ��ѵ�����ľ��������
rpd_test = sd_reference_test / error2;    % ʹ�ò��Լ��ľ��������

% ��ʾ���
disp(['ѵ�������ݵ�RPDΪ��', num2str(rpd_train)])
disp(['���Լ����ݵ�RPDΪ��', num2str(rpd_test)])

%%  ����ɢ��ͼ
sz = 25;
c = 'b';

figure
scatter(T_train, T_sim1, sz, c)
hold on
plot(xlim, ylim, '--k')
xlabel('ѵ������ʵֵ');
ylabel('ѵ����Ԥ��ֵ');
xlim([min(T_train) max(T_train)])
ylim([min(T_sim1) max(T_sim1)])
title('ѵ����Ԥ��ֵ vs. ѵ������ʵֵ')

figure
scatter(T_test, T_sim2, sz, c)
hold on
plot(xlim, ylim, '--k')
xlabel('���Լ���ʵֵ');
ylabel('���Լ�Ԥ��ֵ');
xlim([min(T_test) max(T_test)])
ylim([min(T_sim2) max(T_sim2)])
title('���Լ�Ԥ��ֵ vs. ���Լ���ʵֵ')