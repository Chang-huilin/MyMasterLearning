num_total=140;

X1=X(1:5:num_total,:);   %训练与预测以3:2分(中间为5，若1:1分则中间为2）每5个分为一组，每组中 1、3、5 为训练；2、4为预测
X2=X(2:5:num_total,:);   %Y表示水分含量，在txt文件中
X3=X(3:5:num_total,:);
X4=X(4:5:num_total,:);
X5=X(5:5:num_total,:);

Y1=Y(1:5:num_total,:);   
Y2=Y(2:5:num_total,:);
Y3=Y(3:5:num_total,:);
Y4=Y(4:5:num_total,:);
Y5=Y(5:5:num_total,:);

Xc=[X1;X3;X5]; %#ok<NASGU>
Xt=[X2;X4];
Yc=[Y1;Y3;Y5]; %#ok<NASGU>
Yt=[Y2;Y4];


num_total=140;

X1=X(1:5:num_total,:);   %训练与预测以3:2分(中间为5，若1:1分则中间为2）每5个分为一组，每组中 1、3、5 为训练；2、4为预测
X2=X(2:5:num_total,:);   %Y表示水分含量，在txt文件中
X3=X(3:5:num_total,:);
X4=X(4:5:num_total,:);
X5=X(5:5:num_total,:);

Y1=Y(1:5:num_total,:);   
Y2=Y(2:5:num_total,:);
Y3=Y(3:5:num_total,:);
Y4=Y(4:5:num_total,:);
Y5=Y(5:5:num_total,:);

Xa=[X1;X5];%Xa为训练集
Xb=[X2;X4];%Xb为测试集
Xc=X3;%Xb为预测集


Ya=[Y1;Y5];%Ya为训练集
Yb=[Y2;Y4];%Yb为测试集
Yc=Y3;%Yc为预测集