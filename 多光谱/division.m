num_total=140;
[z1 z2]=sort(Y);         %��Y��������z1Ϊ��������z2��ӳ����ʲô�ı�
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

Xc=[X1;X3;X5];
Xt=[X2;X4];
Yc=[Y1;Y3;Y5];
Yt=[Y2;Y4];
