%�Ŵ��㷨
dataset=[Xc Yc];
gaplsopt(dataset,1);    %1Ϊ�̶�
gaplsopt(dataset,2);    %2Ϊ�̶�

[bi,ci,di]=gapls(dataset,178);    %178Ϊ��һ�����еĽ��

boshu1=1:99;
GA1=bi(1:99);  %99Ϊ��һ�����еĽ����������
Xc1=Xc(:,GA1);
Xt1=Xt(:,GA1);   %ɸѡ������������������PLS��Ҳ����ʹ��ɸѡ�����ı�������PLS��ģ��
  
Model=ipls(Xc1,Yc,11,'mean',1,[],'syst123',5);   %����ͬPLS�㷨��ֻ�Ǳ���Ҫʹ��GA�㷨ɸѡ������
plsrmse(Model,0);   %�ó����ɷ�����0�Ǹ�����

plspvsm(Model,10,1); 
oneModel=plsmodel(Model,1,10,'mean','test',5);
predModel=plspredict(Xt1,oneModel,10,Yt);
plspvsm(predModel,10); 