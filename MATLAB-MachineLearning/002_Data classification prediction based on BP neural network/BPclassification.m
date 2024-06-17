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
[p_train, ps_input] = mapminmax(P_train, 0, 1);
p_test  = mapminmax('apply', P_test, ps_input);
t_train = ind2vec(T_train);
t_test  = ind2vec(T_test );

%%  ����ģ��
net = newff(p_train, t_train, 7);

%%  ����ѵ������
net.trainParam.epochs = 1000;   % ����������
net.trainParam.goal = 1e-6;     % Ŀ��ѵ�����
net.trainParam.lr = 0.001;       % ѧϰ��

%%  ѵ������
net = train(net, p_train, t_train);

%%  �������
t_sim1 = sim(net, p_train);
t_sim2 = sim(net, p_test );

%%  ���ݷ���һ��
T_sim1 = vec2ind(t_sim1);
T_sim2 = vec2ind(t_sim2);

%%  ��������
[T_train, index_1] = sort(T_train);
[T_test , index_2] = sort(T_test );

T_sim1 = T_sim1(index_1);
T_sim2 = T_sim2(index_2);

%%  ��������
error1 = sum((T_sim1 == T_train)) / M * 100 ;
error2 = sum((T_sim2 == T_test )) / N * 100 ;

%%  ��ͼ
figure
plot(1: M, T_train, 'r-*', 1: M, T_sim1, 'b-o', 'LineWidth', 1)
legend('��ʵֵ', 'Ԥ��ֵ')
xlabel('Ԥ������')
ylabel('Ԥ����')
string = {strcat('ѵ����Ԥ�����Աȣ�', ['׼ȷ��=' num2str(error1) '%'])};
title(string)
grid

figure
plot(1: N, T_test, 'r-*', 1: N, T_sim2, 'b-o', 'LineWidth', 1)
legend('��ʵֵ', 'Ԥ��ֵ')
xlabel('Ԥ������')
ylabel('Ԥ����')
string = {strcat('���Լ�Ԥ�����Աȣ�', ['׼ȷ��=' num2str(error2) '%'])};
title(string)
grid

%%  ��������
figure
cm = confusionchart(T_train, T_sim1);
cm.Title = 'Confusion Matrix for Train Data';
cm.ColumnSummary = 'column-normalized';
cm.RowSummary = 'row-normalized';
    
figure
cm = confusionchart(T_test, T_sim2);
cm.Title = 'Confusion Matrix for Test Data';
cm.ColumnSummary = 'column-normalized';
cm.RowSummary = 'row-normalized';
