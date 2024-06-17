%%  清空环境变量
warning off             % 关闭报警信息
close all               % 关闭开启的图窗
clear                   % 清空变量
clc                     % 清空命令行

%%  导入数据
file_path = "C:\Users\79365\Desktop\研究生\王雨\data.mat";

% 使用load函数导入数据
load(file_path);

%%  划分训练集和测试集
temp = randperm(175);

P_train = res(temp(1: 125), 2: 33)';
T_train = res(temp(1: 125), 1)';
M = size(P_train, 2);

P_test = res(temp(125: end), 2: 33)';
T_test = res(temp(125: end), 1)';
N = size(P_test, 2);

%%  数据归一化
[p_train, ps_input] = mapminmax(P_train, 0, 1);
p_test = mapminmax('apply', P_test, ps_input );
t_train = T_train;
t_test  = T_test ;

%%  转置以适应模型
p_train = p_train'; p_test = p_test';
t_train = t_train'; t_test = t_test';

%%  创建模型
c = 10.0;      % 惩罚因子
g = 0.01;      % 径向基函数参数
cmd = ['-t 2', '-c', num2str(c), '-g', num2str(g)];
model = svmtrain(t_train, p_train, cmd);

%%  仿真测试
T_sim1 = svmpredict(t_train, p_train, model);
T_sim2 = svmpredict(t_test , p_test , model);

%%  性能评价
error1 = sum((T_sim1' == T_train)) / M * 100;
error2 = sum((T_sim2' == T_test )) / N * 100;

%%  数据排序
[T_train, index_1] = sort(T_train);
[T_test , index_2] = sort(T_test );

T_sim1 = T_sim1(index_1);
T_sim2 = T_sim2(index_2);

% %%  绘图
% figure
% plot(1: M, T_train, 'r-*', 1: M, T_sim1, 'b-o', 'LineWidth', 1)
% legend('真实值', '预测值')
% xlabel('预测样本')
% ylabel('预测结果')
% string = {'训练集预测结果对比'; ['准确率=' num2str(error1) '%']};
% title(string)
% grid
% 
% figure
% plot(1: N, T_test, 'r-*', 1: N, T_sim2, 'b-o', 'LineWidth', 1)
% legend('真实值', '预测值')
% xlabel('预测样本')
% ylabel('预测结果')
% string = {'测试集预测结果对比'; ['准确率=' num2str(error2) '%']};
% title(string)
% grid
% 
% %%  混淆矩阵
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
