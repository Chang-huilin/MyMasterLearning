%%  清空环境变量
warning off             % 关闭报警信息
close all               % 关闭开启的图窗
clear                   % 清空变量
clc                     % 清空命令行

%%  导入数据

file_path = 'C:\Users\79365\OneDrive\桌面\图像-叶绿素\叶绿素\matlab数据\热风第二天140.mat';

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

%% # 定义模型的超参数
params = {
    'objective': 'reg:squarederror';
    'learning_rate': 0.1,
    'max_depth': 3,
    'subsample': 0.8
};
 
% 将数据转换为DMatrix格式
dtrain = xgb.DMatrix(p_train, label=t_train);
dtest = xgb.DMatrix(p_test, label=t_test);
 
% 训练模型
model = xgb.train(params, dtrain, num_boost_round=100);

% 对测试集进行预测
y_pred = model.predict(dtest)l;
 
% 计算均方根误差
rmse = np.sqrt(mean_squared_error(y_test, y_pred));