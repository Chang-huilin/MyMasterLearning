%%  清空环境变量
warning off             % 关闭报警信息
close all               % 关闭开启的图窗
clear                   % 清空变量
clc                     % 清空命令行

%%  导入数据

file_path = 'C:\Users\79365\Desktop\图像-叶绿素\叶绿素\matlab数据\wenli';
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

%%  转置以适应模型
p_train = p_train'; p_test = p_test';
t_train = t_train'; t_test = t_test';

%%  训练模型
trees = 7;                                      % 决策树数目
leaf  = 15;                                        % 最小叶子数
OOBPrediction = 'on';                             % 打开误差图
OOBPredictorImportance = 'on';                    % 计算特征重要性
Method = 'regression';                            % 分类还是回归
net = TreeBagger(trees, p_train, t_train, 'OOBPredictorImportance', OOBPredictorImportance,...
      'Method', Method, 'OOBPrediction', OOBPrediction, 'minleaf', leaf);
importance = net.OOBPermutedPredictorDeltaError;  % 重要性

%%  仿真测试
t_sim1 = predict(net, p_train);
t_sim2 = predict(net, p_test );

%%  数据反归一化
T_sim1 = mapminmax('reverse', t_sim1, ps_output);
T_sim2 = mapminmax('reverse', t_sim2, ps_output);

%%  均方根误差
error1 = sqrt(sum((T_sim1' - T_train).^2) ./ M);
error2 = sqrt(sum((T_sim2' - T_test ).^2) ./ N);


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
mae1 = sum(abs(T_sim1' - T_train)) ./ M;
mae2 = sum(abs(T_sim2' - T_test )) ./ N;

disp(['训练集数据的MAE为：', num2str(mae1)])
disp(['测试集数据的MAE为：', num2str(mae2)])

% MBE
mbe1 = sum(T_sim1' - T_train) ./ M ;
mbe2 = sum(T_sim2' - T_test ) ./ N ;

disp(['训练集数据的MBE为：', num2str(mbe1)])
disp(['测试集数据的MBE为：', num2str(mbe2)])

%  RMSE
disp(['训练集数据的RMSE为：', num2str(error1)])
disp(['测试集数据的RMSE为：', num2str(error2)])
% 计算基准数据（实际观测数据）的标准差
sd_reference_train = std(T_train);
sd_reference_test = std(T_test);

%% 


% 计算RPD
rpd_train = sd_reference_train / error1;  % 使用训练集的均方根误差
rpd_test = sd_reference_test / error2;    % 使用测试集的均方根误差

% 显示结果
disp(['训练集数据的RPD为：', num2str(rpd_train)])
disp(['测试集数据的RPD为：', num2str(rpd_test)])
% 绘制测试集实际值和预测值的散点图
% figure; % 创建新的图形窗口
% 

% %%  绘制散点图
% sz = 25;
% c = 'r';
% 
% figure
% scatter(T_train, T_sim1, sz, c)
% hold on
% plot(xlim, ylim, '--k')
% xlabel('训练集真实值');
% ylabel('训练集预测值');
% xlim([min(T_train) max(T_train)])
% ylim([min(T_sim1) max(T_sim1)])
% title('训练集预测值 vs. 训练集真实值')
% % 
% 
% figure
% scatter(T_test, T_sim2, sz, 'filled', c, 'Marker', '^')  % 使用红色实心三角作为点的标记
% hold on
% plot(xlim, ylim, '--k')
% xlabel('测试集真实值');
% ylabel('测试集预测值');
% legend('R_c=0.9732 RMSEP=0.3101','R_p=0.9396 RMSEP=0.4509','Location', 'Northwest','FontWeight', 'bold');
% xlim([min(T_test) max(T_test)])
% ylim([min(T_sim2) max(T_sim2)])
% title('测试集预测值 vs. 测试集真实值')
% % 
% 
% plot(T_train, T_sim1, 'ks', 'MarkerSize', 8, 'MarkerFaceColor', 'k'); % 黑色实心方块表示校正集
% hold on; 
% 绘制预测集的散点图（用红色实心三角形表示）
% plot(T_test, T_sim2, '^r', 'MarkerSize', 8, 'MarkerFaceColor', 'r'); % 红色实心三角形表示预测集
% hold on;
% hold on;
% x=0:0.05:0.2;
% y=x;
% plot(x,y);
% hold on;
% line([0, 90], [0, 90], 'Color', 'red', 'LineStyle', '--');%对角线，从（0，0)到（90，90）
% xlabel('Measured value (%)','FontWeight', 'bold');        %加粗，'FontWeight', 'bold'
% ylabel('Predicted value (%)','FontWeight', 'bold');
% legend('R_c=0.9732 RMSEP=0.3101','R_p=0.9396 RMSEP=0.4509','Location', 'Northwest','FontWeight', 'bold');