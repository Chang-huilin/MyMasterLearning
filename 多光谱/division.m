num_total=140;

X1=X(1:5:num_total,:);   %ѵ����Ԥ����3:2��(�м�Ϊ5����1:1�����м�Ϊ2��ÿ5����Ϊһ�飬ÿ���� 1��3��5 Ϊѵ����2��4ΪԤ��
X2=X(2:5:num_total,:);   %Y��ʾˮ�ֺ�������txt�ļ���
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

X1=X(1:5:num_total,:);   %ѵ����Ԥ����3:2��(�м�Ϊ5����1:1�����м�Ϊ2��ÿ5����Ϊһ�飬ÿ���� 1��3��5 Ϊѵ����2��4ΪԤ��
X2=X(2:5:num_total,:);   %Y��ʾˮ�ֺ�������txt�ļ���
X3=X(3:5:num_total,:);
X4=X(4:5:num_total,:);
X5=X(5:5:num_total,:);

Y1=Y(1:5:num_total,:);   
Y2=Y(2:5:num_total,:);
Y3=Y(3:5:num_total,:);
Y4=Y(4:5:num_total,:);
Y5=Y(5:5:num_total,:);

Xa=[X1;X5];%XaΪѵ����
Xb=[X2;X4];%XbΪ���Լ�
Xc=X3;%XbΪԤ�⼯


Ya=[Y1;Y5];%YaΪѵ����
Yb=[Y2;Y4];%YbΪ���Լ�
Yc=Y3;%YcΪԤ�⼯