% PLS
Model=ipls(Xc,Yc,10,'mean',1,[],'syst123',5); %10Ϊ���ɷ֣��ɸ�Ϊ15��1Ϊ������������Ϊһ�����䣬"mean"�ǹ���Ԥ����������syst123����5 ��ʾ���ý�����֤�ķ�����ÿ�ν�����֤��������������
iplsplot(Model,'intlabel');
plsrmse(Model,0);     %�ó����ɷ�����0�Ǹ�����

num_total =10;   %���ɷ���,�ݶ�Ϊ10
plspvsm(Model,num_total,1);
oneModel=plsmodel(Model,1,num_total,'mean','test',5);  
predModel=plspredict(Xc,oneModel,num_total,Yc);
plspvsm(predModel,num_total,1,1);    %��RMSEP�ĳ�RMSEC
predModel=plspredict(Xt,oneModel,num_total,Yt);
plspvsm(predModel,num_total,1,1);      %Ԥ�⼯�Ľ��  