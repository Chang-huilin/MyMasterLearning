%% 清空环境变量
warning off             % 关闭报警信息
close all               % 关闭开启的图窗
clear                   % 清空变量
clc                     % 清空命令行

%% 导入数据
file_path = "C:\Users\79365\Desktop\研究生\王雨\data.mat";

% 使用load函数导入数据
load(file_path);

%% 划分训练集和测试集
temp = randperm(175);

P_train = res(temp(1:125), 2:33)';
T_train = res(temp(1:125), 1)';
M = size(P_train, 2);

P_test = res(temp(125:end), 2:33)';
T_test = res(temp(125:end), 1)';
N = size(P_test, 2);

%% 数据归一化
[P_train, ps_input] = mapminmax(P_train, 0, 1);
P_test = mapminmax('apply', P_test, ps_input);

t_train = categorical(T_train)';
t_test = categorical(T_test)';

%% 数据平铺
% 将数据平铺成1维数据只是一种处理方式
% 也可以平铺成2维数据，以及3维数据，需要修改对应模型结构
% 但是应该始终和输入层数据结构保持一致
p_train = double(reshape(P_train, 32, 1, 1, M));
p_test = double(reshape(P_test, 32, 1, 1, N));

%% 构造网络结构
layers = [
    imageInputLayer([32, 1, 1])                                % 输入层
    convolution2dLayer([2, 1], 16, 'Padding', 'same')          % 初始卷积层
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer([2, 1], 'Stride', [2, 1])                % 最大池化层

    % 第一个残差块组
    residualBlock(16, 16)
    residualBlock(16, 16)

    % 第二个残差块组
    residualBlock(16, 32, 2)
    residualBlock(32, 32)

    % 第三个残差块组
    residualBlock(32, 64, 2)
    residualBlock(64, 64)

    % 第四个残差块组
    residualBlock(64, 128, 2)
    residualBlock(128, 128)

    globalAveragePooling2dLayer                                % 全局平均池化层
    fullyConnectedLayer(7)                                     % 全连接层（类别数） 
    softmaxLayer                                               % Softmax层
    classificationLayer                                        % 分类层
];

%% 参数设置
options = trainingOptions('adam', ...
    'MaxEpochs', 500, ...                  
    'InitialLearnRate', 1e-3, ...          
    'L2Regularization', 1e-4, ...          
    'LearnRateSchedule', 'piecewise', ...  
    'LearnRateDropFactor', 0.1, ...        
    'LearnRateDropPeriod', 400, ...        
    'Shuffle', 'every-epoch', ...          
    'ValidationPatience', Inf, ...         
    'Plots', 'training-progress', ...      
    'Verbose', false);

%% 训练模型
net = trainNetwork(p_train, t_train, layers, options);

%% 预测模型
t_sim1 = predict(net, p_train); 
t_sim2 = predict(net, p_test ); 

%% 反归一化
T_sim1 = vec2ind(t_sim1');
T_sim2 = vec2ind(t_sim2');

%% 性能评价
error1 = sum((T_sim1 == T_train)) / M * 100 ;
error2 = sum((T_sim2 == T_test )) / N * 100 ;

%% 绘制网络分析图
analyzeNetwork(layers)

%% 数据排序
[T_train, index_1] = sort(T_train);
[T_test , index_2] = sort(T_test );

T_sim1 = T_sim1(index_1);
T_sim2 = T_sim2(index_2);

%% 绘图
figure
plot(1: M, T_train, 'r-*', 1: M, T_sim1, 'b-o', 'LineWidth', 1)
legend('真实值', '预测值')
xlabel('预测样本')
ylabel('预测结果')
string = {'训练集预测结果对比'; ['准确率=' num2str(error1) '%']};
title(string)
xlim([1, M])
grid

figure
plot(1: N, T_test, 'r-*', 1: N, T_sim2, 'b-o', 'LineWidth', 1)
legend('真实值', '预测值')
xlabel('预测样本')
ylabel('预测结果')
string = {'测试集预测结果对比'; ['准确率=' num2str(error2) '%']};
title(string)
xlim([1, N])
grid

%% 混淆矩阵
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
