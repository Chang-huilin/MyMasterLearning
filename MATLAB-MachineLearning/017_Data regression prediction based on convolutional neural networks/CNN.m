%%  清空环境变量
warning off             % 关闭报警信息
close all               % 关闭开启的图窗
clear                   % 清空变量
clc                     % 清空命令行

%%  导入数据

file_path = 'C:\Users\79365\Desktop\图像-叶绿素\叶绿素\matlab数据\wenli.mat';

% 使用load函数导入数据
load(file_path);

Y=Y(:,3);

%%  划分训练集和测试集
num_total=140;
[z1, z2]=sort(Y);           %#ok<*ASGLU> %对Y进行排序，z1为排序结果，z2反映做了什么改变
X1=X(1:5:num_total,:);   %训练与预测以3:2分(中间为5，若1:1分则中间为2）每5个分为一组，每组中 1、3、5 为训练；2、4为预测
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


% 清除变量Y1到Y5和X1到X5
clear Y1 Y2 Y3 Y4 Y5 X1 X2 X3 X4 X5 z1 z2 num_total;

%%  数据归一化
[p_train, ps_input] = mapminmax(P_train, 0, 1);
p_test = mapminmax('apply', P_test, ps_input);

[t_train, ps_output] = mapminmax(T_train, 0, 1);
t_test = mapminmax('apply', T_test, ps_output);

%%  数据平铺
%   将数据平铺成1维数据只是一种处理方式
%   也可以平铺成2维数据，以及3维数据，需要修改对应模型结构
%   但是应该始终和输入层数据结构保持一致
p_train = double(reshape(p_train, [10, 1, 1, M]));
p_test = double(reshape(p_test, [10, 1, 1, N]));
t_train =  double(t_train)';
t_test  =  double(t_test )';

%%  构造网络结构
layers = [
 imageInputLayer([10, 1, 1])                         % 输入层 输入数据规模[N, 1, 1]
 
 convolution2dLayer([3, 1], 16, 'Padding', 'same')  % 卷积核大小 3*1 生成16张特征图
 batchNormalizationLayer                            % 批归一化层
 reluLayer                                          % Relu激活层
 
 maxPooling2dLayer([2, 1], 'Stride', [1, 1])        % 最大池化层 池化窗口 [2, 1] 步长 [1, 1]

 convolution2dLayer([3, 1], 32, 'Padding', 'same')  % 卷积核大小 3*1 生成32张特征图
 batchNormalizationLayer                            % 批归一化层
 reluLayer                                          % Relu激活层

 dropoutLayer(0.1)                                  % Dropout层
 fullyConnectedLayer(1)                             % 全连接层
 regressionLayer];                                  % 回归层

%%  参数设置
options = trainingOptions('sgdm', ...      % SGDM 梯度下降算法
    'MiniBatchSize', 32, ...               % 批大小,每次训练样本个数 32
    'MaxEpochs', 500, ...                 % 最大训练次数 1200
    'InitialLearnRate', 1e-2, ...          % 初始学习率为0.01
    'LearnRateSchedule', 'piecewise', ...  % 学习率下降
    'LearnRateDropFactor', 0.1, ...        % 学习率下降因子
    'LearnRateDropPeriod', 800, ...        % 经过 800 次训练后 学习率为 0.01 * 0.1
    'Shuffle', 'every-epoch', ...          % 每次训练打乱数据集
    'Plots', 'training-progress', ...      % 画出曲线
    'Verbose', false);

%%  训练模型
net = trainNetwork(p_train, t_train, layers, options);

%%  模型预测
t_sim1 = predict(net, p_train);
t_sim2 = predict(net, p_test );

%%  数据反归一化
T_sim1 = mapminmax('reverse', t_sim1, ps_output);
T_sim2 = mapminmax('reverse', t_sim2, ps_output);

%%  均方根误差
error1 = sqrt(sum((T_sim1' - T_train).^2) ./ M);
error2 = sqrt(sum((T_sim2' - T_test ).^2) ./ N);
disp(['训练集数据的RMES为：', num2str(error1)])
disp(['测试集数据的RMSE为：', num2str(error2)])
%%  绘制网络分析图
analyzeNetwork(layers)

%%  绘图
figure
plot(1: M, T_train, 'r-*', 1: M, T_sim1, 'b-o', 'LineWidth', 1)
legend('真实值', '预测值')
xlabel('预测样本')
ylabel('预测结果')
string = {'训练集预测结果对比'; ['RMSE=' num2str(error1)]};
title(string)
xlim([1, M])
grid

figure
plot(1: N, T_test, 'r-*', 1: N, T_sim2, 'b-o', 'LineWidth', 1)
legend('真实值', '预测值')
xlabel('预测样本')
ylabel('预测结果')
string = {'测试集预测结果对比'; ['RMSE=' num2str(error2)]};
title(string)
xlim([1, N])
grid

%%  相关指标计算
% R2
R1 = 1 - norm(T_train - T_sim1')^2 / norm(T_train - mean(T_train))^2;
R2 = 1 - norm(T_test  - T_sim2')^2 / norm(T_test  - mean(T_test ))^2;

disp(['训练集数据的R2为：', num2str(R1)])
disp(['测试集数据的R2为：', num2str(R2)])
% 计算平方根
Rc = sqrt(R1);
Rp = sqrt(R2);

% 输出结果
disp(['Rc为：', num2str(Rc)]);
disp(['Rp为：', num2str(Rp)]);

% MAE
mae1 = sum(abs(T_sim1' - T_train)) ./ M ;
mae2 = sum(abs(T_sim2' - T_test )) ./ N ;

disp(['训练集数据的MAE为：', num2str(mae1)])
disp(['测试集数据的MAE为：', num2str(mae2)])

% MBE
mbe1 = sum(T_sim1' - T_train) ./ M ;
mbe2 = sum(T_sim2' - T_test ) ./ N ;

disp(['训练集数据的MBE为：', num2str(mbe1)])
disp(['测试集数据的MBE为：', num2str(mbe2)])

% 计算基准数据（实际观测数据）的标准差
sd_reference_train = std(T_train);
sd_reference_test = std(T_test);

% 计算RPD
rpd_train = sd_reference_train / error1;  % 使用训练集的均方根误差
rpd_test = sd_reference_test / error2;    % 使用测试集的均方根误差

% 显示结果
disp(['训练集数据的RPD为：', num2str(rpd_train)])
disp(['测试集数据的RPD为：', num2str(rpd_test)])

%%  绘制散点图
sz = 25;
c = 'b';

figure
scatter(T_train, T_sim1, sz, c)
hold on
plot(xlim, ylim, '--k')
xlabel('训练集真实值');
ylabel('训练集预测值');
xlim([min(T_train) max(T_train)])
ylim([min(T_sim1) max(T_sim1)])
title('训练集预测值 vs. 训练集真实值')

figure
scatter(T_test, T_sim2, sz, c)
hold on
plot(xlim, ylim, '--k')
xlabel('测试集真实值');
ylabel('测试集预测值');
xlim([min(T_test) max(T_test)])
ylim([min(T_sim2) max(T_sim2)])
title('测试集预测值 vs. 测试集真实值')