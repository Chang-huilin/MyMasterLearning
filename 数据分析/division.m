%%��������3��2
num_total=12;
[z1 z2]=sort(Y);           %#ok<*ASGLU> %��Y��������z1Ϊ��������z2��ӳ����ʲô�ı�,��Ϊ����
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
Yt=[Y2;Y4]; %#ok<*NASGU>


%%��������2��1
X=NIR';
X=SNV(X); 
[z1 z2]=sort(Y);       %#ok<*NCOMMA> %��Y�������򣬰���2��1����ѵ������Ԥ�⼯
X=X(z2,:);
num_total=117;  
 t1=X(1:3:num_total,:);%���д���ĺ����ǴӾ���X�а��ղ���Ϊ3ѡȡ�У��ӵ�1�п�ʼ��һֱѡ����num_total�С�ð��(:)��ʾѡ���ά���ϵ�����Ԫ�ء����ԣ�t1������X������ÿ��3��ѡȡ���У��ӵ�1�п�ʼ��ֱ����num_total�С�
 t2=X(2:3:num_total,:);
 t3=X(3:3:num_total,:);
 Xc=[t1;t3];
 Xt=t2;
 t1=z1(1:3:num_total,:);
 t2=z1(2:3:num_total,:);
 t3=z1(3:3:num_total,:);
 Yc=[t1;t3];
 Yt=t2;