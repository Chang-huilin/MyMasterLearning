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
[p_train, ps_input] = mapminmax(P_train, 0, 1);
p_test = mapminmax('apply', P_test, ps_input);

[t_train, ps_output] = mapminmax(T_train, 0, 1);
t_test = mapminmax('apply', T_test, ps_output);

%%  �ڵ����
inputnum  = size(p_train, 1);  % �����ڵ���
hiddennum = 5;                 % ���ز�ڵ���
outputnum = size(t_train,1);   % �����ڵ���

%%  ��������
net = newff(p_train, t_train, hiddennum);

%%  ����ѵ������
net.trainParam.epochs     = 1000;      % ѵ������
net.trainParam.goal       = 1e-6;      % Ŀ�����
net.trainParam.lr         = 0.01;      % ѧϰ��
net.trainParam.showWindow = 0;         % �رմ���

%%  ������ʼ��
c1      = 4.494;       % ѧϰ����
c2      = 4.494;       % ѧϰ����
maxgen  =   50;        % ��Ⱥ���´���  
sizepop =    5;        % ��Ⱥ��ģ
Vmax    =  1.0;        % ����ٶ�
Vmin    = -1.0;        % ��С�ٶ�
popmax  =  1.0;        % ���߽�
popmin  = -1.0;        % ��С�߽�

%%  �ڵ�����
numsum = inputnum * hiddennum + hiddennum + hiddennum * outputnum + outputnum;

for i = 1 : sizepop
    pop(i, :) = rands(1, numsum);  % ��ʼ����Ⱥ
    V(i, :) = rands(1, numsum);    % ��ʼ���ٶ�
    fitness(i) = fun(pop(i, :), hiddennum, net, p_train, t_train);
end

%%  ���弫ֵ��Ⱥ�弫ֵ
[fitnesszbest, bestindex] = min(fitness);
zbest = pop(bestindex, :);     % ȫ�����
gbest = pop;                   % �������
fitnessgbest = fitness;        % ���������Ӧ��ֵ
BestFit = fitnesszbest;        % ȫ�������Ӧ��ֵ

%%  ����Ѱ��
for i = 1 : maxgen
    for j = 1 : sizepop
        
        % �ٶȸ���
        V(j, :) = V(j, :) + c1 * rand * (gbest(j, :) - pop(j, :)) + c2 * rand * (zbest - pop(j, :));
        V(j, (V(j, :) > Vmax)) = Vmax;
        V(j, (V(j, :) < Vmin)) = Vmin;
        
        % ��Ⱥ����
        pop(j, :) = pop(j, :) + 0.2 * V(j, :);
        pop(j, (pop(j, :) > popmax)) = popmax;
        pop(j, (pop(j, :) < popmin)) = popmin;
        
        % ����Ӧ����
        pos = unidrnd(numsum);
        if rand > 0.85
            pop(j, pos) = rands(1, 1);
        end
        
        % ��Ӧ��ֵ
        fitness(j) = fun(pop(j, :), hiddennum, net, p_train, t_train);

    end
    
    for j = 1 : sizepop

        % �������Ÿ���
        if fitness(j) < fitnessgbest(j)
            gbest(j, :) = pop(j, :);
            fitnessgbest(j) = fitness(j);
        end

        % Ⱥ�����Ÿ��� 
        if fitness(j) < fitnesszbest
            zbest = pop(j, :);
            fitnesszbest = fitness(j);
        end

    end

    BestFit = [BestFit, fitnesszbest];    
end

%%  ��ȡ���ų�ʼȨֵ����ֵ
w1 = zbest(1 : inputnum * hiddennum);
B1 = zbest(inputnum * hiddennum + 1 : inputnum * hiddennum + hiddennum);
w2 = zbest(inputnum * hiddennum + hiddennum + 1 : inputnum * hiddennum ...
    + hiddennum + hiddennum * outputnum);
B2 = zbest(inputnum * hiddennum + hiddennum + hiddennum * outputnum + 1 : ...
    inputnum * hiddennum + hiddennum + hiddennum * outputnum + outputnum);

%%  ����ֵ��ֵ
net.Iw{1, 1} = reshape(w1, hiddennum, inputnum);
net.Lw{2, 1} = reshape(w2, outputnum, hiddennum);
net.b{1}     = reshape(B1, hiddennum, 1);
net.b{2}     = B2';

%%  ��ѵ������ 
net.trainParam.showWindow = 1;        % �򿪴���

%%  ����ѵ��
net = train(net, p_train, t_train);

%%  ����Ԥ��
t_sim1 = sim(net, p_train);
t_sim2 = sim(net, p_test );

%%  ���ݷ���һ��
T_sim1 = mapminmax('reverse', t_sim1, ps_output);
T_sim2 = mapminmax('reverse', t_sim2, ps_output);

%%  ���������
error1 = sqrt(sum((T_sim1 - T_train).^2, 2)' ./ M);
error2 = sqrt(sum((T_sim2 - T_test) .^2, 2)' ./ N);

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

%%  ������ߵ���ͼ
figure;
plot(1 : length(BestFit), BestFit, 'LineWidth', 1.5);
xlabel('����Ⱥ��������');
ylabel('��Ӧ��ֵ');
xlim([1, length(BestFit)])
string = {'ģ�͵������仯'};
title(string)
grid on

%%  ���ָ�����
% R2
R1 = 1 - norm(T_train - T_sim1)^2 / norm(T_train - mean(T_train))^2;
R2 = 1 - norm(T_test  - T_sim2)^2 / norm(T_test  - mean(T_test ))^2;

disp(['ѵ�������ݵ�R2Ϊ��', num2str(R1)])
disp(['���Լ����ݵ�R2Ϊ��', num2str(R2)])

% MAE
mae1 = sum(abs(T_sim1 - T_train), 2)' ./ M ;
mae2 = sum(abs(T_sim2 - T_test ), 2)' ./ N ;

disp(['ѵ�������ݵ�MAEΪ��', num2str(mae1)])
disp(['���Լ����ݵ�MAEΪ��', num2str(mae2)])

% MBE
mbe1 = sum(T_sim1 - T_train, 2)' ./ M ;
mbe2 = sum(T_sim2 - T_test , 2)' ./ N ;

disp(['ѵ�������ݵ�MBEΪ��', num2str(mbe1)])
disp(['���Լ����ݵ�MBEΪ��', num2str(mbe2)])
% ����ƽ����
Rc = sqrt(R1);
Rp = sqrt(R2);

% ������
disp(['RcΪ��', num2str(Rc)]);
disp(['RpΪ��', num2str(Rp)]);

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