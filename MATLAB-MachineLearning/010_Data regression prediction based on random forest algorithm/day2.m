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

%%  ת������Ӧģ��
p_train = p_train'; p_test = p_test';
t_train = t_train'; t_test = t_test';

%%  ѵ��ģ��
trees = 1000;                                      % ��������Ŀ
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
mae1 = sum(abs(T_sim1' - T_train)) ./ M;
mae2 = sum(abs(T_sim2' - T_test )) ./ N;

disp(['ѵ�������ݵ�MAEΪ��', num2str(mae1)])
disp(['���Լ����ݵ�MAEΪ��', num2str(mae2)])

% MBE
mbe1 = sum(T_sim1' - T_train) ./ M ;
mbe2 = sum(T_sim2' - T_test ) ./ N ;

disp(['ѵ�������ݵ�MBEΪ��', num2str(mbe1)])
disp(['���Լ����ݵ�MBEΪ��', num2str(mbe2)])

%  RMSE
disp(['ѵ�������ݵ�RMSEΪ��', num2str(error1)])
disp(['���Լ����ݵ�RMSEΪ��', num2str(error2)])
% �����׼���ݣ�ʵ�ʹ۲����ݣ��ı�׼��
sd_reference_train = std(T_train);
sd_reference_test = std(T_test);

%% 


% ����RPD
rpd_train = sd_reference_train / error1;  % ʹ��ѵ�����ľ��������
rpd_test = sd_reference_test / error2;    % ʹ�ò��Լ��ľ��������

% ��ʾ���
disp(['ѵ�������ݵ�RPDΪ��', num2str(rpd_train)])
disp(['���Լ����ݵ�RPDΪ��', num2str(rpd_test)])
