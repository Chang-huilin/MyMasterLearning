%%  ��ջ�������
warning off             % �رձ�����Ϣ
close all               % �رտ�����ͼ��
clear                   % ��ձ���
clc                     % ���������

%%  ��������

file_path = 'C:\Users\79365\OneDrive\����\ͼ��-Ҷ����\Ҷ����\matlab����\�ȷ�ڶ���140.mat';

% ʹ��load������������
load(file_path);

Y=Y(:,1);

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
[p_train, ps_input] = mapminmax(P_train, 0, 1);
p_test = mapminmax('apply', P_test, ps_input);

[t_train, ps_output] = mapminmax(T_train, 0, 1);
t_test = mapminmax('apply', T_test, ps_output);

%%  ����ģ��
S1 = 5;           %  ���ز�ڵ����                
net = newff(p_train, t_train, S1);

%%  ���ò���
net.trainParam.epochs = 1000;        % ���������� 
net.trainParam.goal   = 1e-6;        % ���������ֵ
net.trainParam.lr     = 0.01;        % ѧϰ��

%%  �����Ż�����
gen = 50;                       % �Ŵ�����
pop_num = 5;                    % ��Ⱥ��ģ
S = size(p_train, 1) * S1 + S1 * size(t_train, 1) + S1 + size(t_train, 1);
                                % �Ż���������
bounds = ones(S, 1) * [-1, 1];  % �Ż������߽�

%%  ��ʼ����Ⱥ
prec = [1e-6, 1];               % epslin Ϊ1e-6, ʵ������
normGeomSelect = 0.09;          % ѡ�����Ĳ���
arithXover = 2;                 % ���溯���Ĳ���
nonUnifMutation = [2 gen 3];    % ���캯���Ĳ���

initPpp = initializega(pop_num, bounds, 'gabpEval', [], prec);  

%%  �Ż��㷨
[Bestpop, endPop, bPop, trace] = ga(bounds, 'gabpEval', [], initPpp, [prec, 0], 'maxGenTerm', gen,...
                           'normGeomSelect', normGeomSelect, 'arithXover', arithXover, ...
                           'nonUnifMutation', nonUnifMutation);

%%  ��ȡ���Ų���
[val, W1, B1, W2, B2] = gadecod(Bestpop);

%%  ������ֵ
net.IW{1, 1} = W1;
net.LW{2, 1} = W2;
net.b{1}     = B1;
net.b{2}     = B2;

%%  ģ��ѵ��
net.trainParam.showWindow = 1;       % ��ѵ������
net = train(net, p_train, t_train);  % ѵ��ģ��

%%  �������
t_sim1 = sim(net, p_train);
t_sim2 = sim(net, p_test );

%%  ���ݷ���һ��
T_sim1 = mapminmax('reverse', t_sim1, ps_output);
T_sim2 = mapminmax('reverse', t_sim2, ps_output);

%%  ���������
error1 = sqrt(sum((T_sim1 - T_train).^2) ./ M);
error2 = sqrt(sum((T_sim2 - T_test ).^2) ./ N);

%%  �Ż���������
figure
plot(trace(:, 1), 1 ./ trace(:, 2), 'LineWidth', 1.5);
xlabel('��������');
ylabel('��Ӧ��ֵ');
string = {'��Ӧ�ȱ仯����'};
title(string)
grid on

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
%  R2
R1 = 1 - norm(T_train - T_sim1)^2 / norm(T_train - mean(T_train))^2;
R2 = 1 - norm(T_test  - T_sim2)^2 / norm(T_test  - mean(T_test ))^2;

disp(['ѵ�������ݵ�R2Ϊ��', num2str(R1)])
disp(['���Լ����ݵ�R2Ϊ��', num2str(R2)])
% ����ƽ����
Rc = sqrt(R1);
Rp = sqrt(R2);

% ������
disp(['RcΪ��', num2str(Rc)]);
disp(['RpΪ��', num2str(Rp)]);

%  MAE
mae1 = sum(abs(T_sim1 - T_train)) ./ M ;
mae2 = sum(abs(T_sim2 - T_test )) ./ N ;

disp(['ѵ�������ݵ�MAEΪ��', num2str(mae1)])
disp(['���Լ����ݵ�MAEΪ��', num2str(mae2)])

%  MBE
mbe1 = sum(T_sim1 - T_train) ./ M ;
mbe2 = sum(T_sim2 - T_test ) ./ N ;

disp(['ѵ�������ݵ�MBEΪ��', num2str(mbe1)])
disp(['���Լ����ݵ�MBEΪ��', num2str(mbe2)])

%  RMSE
disp(['ѵ�������ݵ�RMSEΪ��', num2str(error1)])
disp(['���Լ����ݵ�RMSEΪ��', num2str(error2)])

% �����׼���ݣ�ʵ�ʹ۲����ݣ��ı�׼��
sd_reference_train = std(T_train);
sd_reference_test = std(T_test);

% ����RPD
rpd_train = sd_reference_train / error1;  % ʹ��ѵ�����ľ��������
rpd_test = sd_reference_test / error2;    % ʹ�ò��Լ��ľ��������

% ��ʾ���
disp(['ѵ�������ݵ�RPDΪ��', num2str(rpd_train)])
disp(['���Լ����ݵ�RPDΪ��', num2str(rpd_test)])
