%%  ��ջ�������
warning off             % �رձ�����Ϣ
close all               % �رտ�����ͼ��
clear                   % ��ձ���
clc                     % ���������

%%  �������ݣ�ʱ�����еĵ������ݣ�
result = xlsread('���ݼ�.xlsx');

%%  ���ݷ���
num_samples = length(result);  % �������� 
kim = 15;                      % ��ʱ������kim����ʷ������Ϊ�Ա�����
zim =  1;                      % ��zim��ʱ������Ԥ��

%%  �������ݼ�
for i = 1: num_samples - kim - zim + 1
    res(i, :) = [reshape(result(i: i + kim - 1), 1, kim), result(i + kim + zim - 1)];
end

%%  ����ѵ�����Ͳ��Լ�
temp = 1: 1: 922;

P_train = res(temp(1: 700), 1: 15)';
T_train = res(temp(1: 700), 16)';
M = size(P_train, 2);

P_test = res(temp(701: end), 1: 15)';
T_test = res(temp(701: end), 16)';
N = size(P_test, 2);

%%  ���ݹ�һ��
[p_train, ps_input] = mapminmax(P_train, 0, 1);
p_test = mapminmax('apply', P_test, ps_input);

[t_train, ps_output] = mapminmax(T_train, 0, 1);
t_test = mapminmax('apply', T_test, ps_output);

%%  ת������Ӧģ��
p_train = p_train'; p_test = p_test';
t_train = t_train'; t_test = t_test';

%%  ѵ��ģ��
trees = 100;                                      % ��������Ŀ
leaf  = 5;                                        % ��СҶ����
OOBPrediction = 'on';                             % �����ͼ
OOBPredictorImportance = 'on';                    % ����������Ҫ��
Method = 'regression';                            % ���໹�ǻع�
net = TreeBagger(trees, p_train, t_train, 'OOBPredictorImportance', OOBPredictorImportance,...
      'Method', Method, 'OOBPrediction', OOBPrediction, 'minleaf', leaf);
importance = net.OOBPermutedPredictorDeltaError;  % ��Ҫ��

%%  �������
t_sim1 = predict(net, p_train);
t_sim2 = predict(net, p_test );

%%  ���ݷ���һ��
T_sim1 = mapminmax('reverse', t_sim1, ps_output);
T_sim2 = mapminmax('reverse', t_sim2, ps_output);

%%  ���������
error1 = sqrt(sum((T_sim1' - T_train).^2) ./ M);
error2 = sqrt(sum((T_sim2' - T_test ).^2) ./ N);

%%  ��ͼ
figure
plot(1: M, T_train, 'r-', 1: M, T_sim1, 'b-', 'LineWidth', 1)
legend('��ʵֵ', 'Ԥ��ֵ')
xlabel('Ԥ������')
ylabel('Ԥ����')
string = {'ѵ����Ԥ�����Ա�'; ['RMSE=' num2str(error1)]};
title(string)
xlim([1, M])
grid

figure
plot(1: N, T_test, 'r-', 1: N, T_sim2, 'b-', 'LineWidth', 1)
legend('��ʵֵ', 'Ԥ��ֵ')
xlabel('Ԥ������')
ylabel('Ԥ����')
string = {'���Լ�Ԥ�����Ա�'; ['RMSE=' num2str(error2)]};
title(string)
xlim([1, N])
grid

%%  �����������
figure
plot(1: trees, oobError(net), 'b-', 'LineWidth', 1)
legend('�������')
xlabel('��������Ŀ')
ylabel('���')
xlim([1, trees])
grid

%%  ����������Ҫ��
figure
bar(importance)
legend('��Ҫ��')
xlabel('����')
ylabel('��Ҫ��')

%%  ���ָ�����
% R2
R1 = 1 - norm(T_train - T_sim1')^2 / norm(T_train - mean(T_train))^2;
R2 = 1 - norm(T_test  - T_sim2')^2 / norm(T_test  - mean(T_test ))^2;

disp(['ѵ�������ݵ�R2Ϊ��', num2str(R1)])
disp(['���Լ����ݵ�R2Ϊ��', num2str(R2)])

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