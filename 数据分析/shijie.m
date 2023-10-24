% % PLS
% Model=ipls(Xc,Yc,10,'mean',1,[],'syst123',5); %10Ϊ���ɷ֣��ɸ�Ϊ15��1Ϊ������������Ϊһ�����䣬"mean"�ǹ���Ԥ����������syst123����5 ��ʾ���ý�����֤�ķ�����ÿ�ν�����֤��������������
% iplsplot(Model,'intlabel');
% plsrmse(Model,0);     %�ó����ɷ�����0�Ǹ�����

% num_total =10;   %���ɷ���
% plspvsm(Model,num_total,1);
% oneModel=plsmodel(Model,1,num_total,'mean','test',5);  
% predModel=plspredict(Xc,oneModel,num_total,Yc);
% plspvsm(predModel,num_total,1,1);    %��RMSEP�ĳ�RMSEC
% predModel=plspredict(Xt,oneModel,num_total,Yt);
% plspvsm(predModel,num_total,1,1);      %Ԥ�⼯�Ľ��  



% % CARS
% MCCV=plsmccv(X,Y,15,'center',1000,0.8);
% CARS=carspls(X,Y,MCCV.optPC,5,'center',50); 
% plotcars(CARS);
% SelectedVariables=CARS.vsel;

% Xt3=Xt(:,SelectedVariables);
% Xc3=Xc(:,SelectedVariables);

% Model=ipls(Xc3,Yc,10,'mean',1,[],'syst123',5);
% iplsplot(Model,'intlabel')
% plsrmse(Model,0)

% num_total =8;   %���ɷ���
% plspvsm(Model,num_total,1);        %�������ɷ���
% oneModel=plsmodel(Model,1,num_total,'mean','syst123',5);
% predModel=plspredict(Xc3,oneModel,num_total,Yc);
% plspvsm(predModel,num_total)
% predModel=plspredict(Xt3,oneModel,num_total,Yt);
% plspvsm(predModel,num_total)

% Variables = xaxis(SelectedVariables,1);  %SelectedVariablesѡ�����ı�����xaxis��ժ����,��������    


% SiPLS

% siModel=sipls(Xc,Yc,10,'mean',11,2,xaxis2,'syst123',5);
% siplstable(siModel);

% num_total =6;   %���ɷ���
% FinalModel=plsmodel(siModel,[ 7    8] ,num_total,'mean','syst123',5);
% plspvsm(FinalModel,num_total,1);
% oneModel=plsmodel(siModel,[ 7    8] ,num_total,'mean','test',5);
% predModel=plspredict(Xc,oneModel,num_total,Yc);
% plspvsm(predModel,num_total,1,1);
% predModel=plspredict(Xt,oneModel,num_total,Yt);
% plspvsm(predModel,num_total,1,1);      %Ԥ�⼯�Ľ�� 

ACO  E:\������˶ʿ\�㷨����\ACO+SA+GA+siPLS\ACO+SA+GA+siPLS\ACO-PLS
Xcal=Xc;
Xtest=Xt;
Ycal=Yc;
Ytest=Yt;

Xtest=Xtest';
Xmon_sim1=Xtest;
save('Xmon_sim1.txt','Xmon_sim1','-ascii')
Xcal=Xcal';
Xcal_sim1=Xcal;
save('Xcal_sim1.txt','Xcal_sim1','-ascii')
ymon_sim1=Ytest;
save('ymon_sim1.txt','ymon_sim1','-ascii')
ycal_sim1=Ycal;
save('ycal_sim1.txt','ycal_sim1','-ascii'); 

    %����aco_pls_main_code.m�ļ�.����2924ͼ
    % ���������һ��ͼƬ����ɫ����ȥ�� ��Ҫ�ر����ͼƬ����ɾ������ڶ���ͼƬ���༭-ͼ������-deleteɾ��ͼƬ
    % ����aco_pls_selv�ļ�.����400-1000ͼ
    % ����aco_pls_cal�ļ�.����ͼ

%�õ�ѡ��� xaxis��xaxis_1%%xaxis_1����ɸѡ�������õ������
[m,n]=size(histo);
histo_1=zeros(m,1);
xaxis_1=zeros(m,1);
for i=1:m
    for j=1:n
        if histo(i,j) ~= 0
            histo_1(i,1) =i;
            xaxis_1(i,1) = xaxis(i,1);
            continue;
        end
    end
end
histo_1(all(histo_1==0,2),:)=[];
xaxis_1(all(xaxis_1==0,2),:)=[]; 

X_new=X(:,histo_1);   %��ѡ������ı����ϲ����µľ���
X= X_new;

Xcc=Xcal0';
Xtt=Xtest';
 Xc2=Xcc(:,histo_1);
 Xt2=Xtt(:,histo_1);

Model=ipls(Xc2,Yc,15,'mean',1,[],'syst123',5); %10Ϊ���ɷ֣��ɸ�Ϊ15��1Ϊ������������Ϊһ�����䣬"mean"�ǹ���Ԥ����������syst123����5 ��ʾ���ý�����֤�ķ�����ÿ�ν�����֤��������������
iplsplot(Model,'intlabel');
plsrmse(Model,0);     %�ó����ɷ�����0�Ǹ�����

num_total =5;   %���ɷ���
plspvsm(Model,num_total,1);
oneModel=plsmodel(Model,1,num_total,'mean','test',5);  
predModel=plspredict(Xc2,oneModel,num_total,Yc);
plspvsm(predModel,num_total,1,1);    %��RMSEP�ĳ�RMSEC
predModel=plspredict(Xt2,oneModel,num_total,Yt);
plspvsm(predModel,num_total,1,1);      %Ԥ�⼯�Ľ��                                
 


%��ɸѡ�������PLS���ɷֻ�ͼ

UVE ����Ϣ��������E:\������˶ʿ\�㷨����\matlab code\�㷨(SH)\���ݴ�������㷨\UVE-PLS
 [mean_b,std_b,t_values,var_retain,RMSECVnew,Yhat,E]=plsuve(X,Y,20,144,2924,0.99);

 for i=1:47 %����var_retain��
     X1(:,i) = X(:,(var_retain(1,i)));      %#ok<*SAGROW,*NASGU> %�ǵ���������X1�ĳ�X
 end

 [Xc,Xt,Yc,Yt]=spxy(X,Y,96);        %#ok<*ASGLU> %66����ѵ�������ֵ��������������»�������PLS��ͼ


% % % Boss E:\������˶ʿ\�㷨����\matlab code\matlab code\code-boss
% Xcal=Xc;
% ycal=Yc;
% Xtest=Xt;
% ytest=Yt;
% nLV_max=10;
% fold=5;
% method='center';
% num_bootstrap=1000;
% BOSS=boss(Xcal,ycal,nLV_max,fold,method,num_bootstrap,0); 
% boss_rmsecv=BOSS.minRMSECV;
% boss_q2_cv=BOSS.Q2_max;
% boss_variable_index=BOSS.variable_index;
% [boss_rmsep,boss_rmsec,boss_q2_test,boss_q2_train, yfit, ypred]=predict(Xcal,ycal,Xtest,ytest,BOSS.variable_index==1,BOSS.optPC,method);

% [r,c]=find(BOSS.variable_index==1);

% Xt3=Xt(:,r);
% Xc3=Xc(:,r);
% xaxis2=xaxis(r);    %ɸѡ���ı���

% Model=ipls(Xc3,Yc,10,'mean',1,1:12,'syst123',5);    %23Ϊɸѡ�����ı��������޸�
% iplsplot(Model,'intlabel')
% plsrmse(Model,0)

% num_total =5;    %�޸����ɷ���
% plspvsm(Model,num_total,1)
% oneModel=plsmodel(Model,1,num_total,'mean','syst123',5);
% predModel=plspredict(Xc3,oneModel,num_total,Yc);
% plspvsm(predModel,num_total)
% predModel=plspredict(Xt3,oneModel,num_total,Yt);
% plspvsm(predModel,num_total)

%Ԥ����
%% SNV��  %X������*����       
X=SNV(X); 
[Xc,Xt,Yc,Yt]=spxy(X,Y,86);
plot(1:3648,X)  %������ͼ��3648�Ǳ�����            

%% һ���������׵���  �� \ D:\������1\˶\404\code\�㷨��CW)\�㷨��CW)\Ԥ����\  Ŀ¼������
[dx1]=DERIV(X,1);      %X������*����
X1=X;
X=dx1;
[Xc,Xt,Yc,Yt]=spxy(X,Y,96);

[dx2]=DERIV(X,2);
X1=X;
X=dx2;
[Xc,Xt,Yc,Yt]=spxy(X,Y,86);

[dx3]=DERIV(X,3);
plot(1:2808,dx1);     % ������ͼ

%%center��ֵ���Ļ���%X������*����
[cdata,me,ctest]=center(X',1,X');   %�������*������ ��Ҫת��
plot(1:3648,cdata);  %������ͼ

%MSC��%X������*����
[xmsc,me,xtmsc]=MSC(x,first,last,xt);  %����Ҫ����
[xmsc,me]=MSC(X,1,3648);  %1Ϊ��һ������ 3648Ϊ���һ������
plot(1:3648,xmsc);  %������ͼ


%������������
 ZX=SNV(X); 

[dx1]=DERIV(X,1);      %X������*����
X1=X;
X=dx1;

[dx2]=DERIV(X,2);
X1=X;
X=dx2;

ZX=X;
[z1, z2]=sort(Y);       %��Y�������򣬰���3��2����ѵ������Ԥ�⼯,z1Ϊ����֮�����ֵ�����z2Ϊ�µ�����˳��
ZX2=ZX(z2,:);
num_total=72;
X1=ZX2(1:5:num_total,:);   %ѵ����Ԥ����3:2��(�м�Ϊ5����1:1�����м�Ϊ2��ÿ5����Ϊһ�飬ÿ���� 1��3��5 Ϊѵ����2��4ΪԤ��
X2=ZX2(2:5:num_total,:);
X3=ZX2(3:5:num_total,:);
X4=ZX2(4:5:num_total,:);
X5=ZX2(5:5:num_total,:);

Y1=z1(1:5:num_total,:);   
Y2=z1(2:5:num_total,:);
Y3=z1(3:5:num_total,:);
Y4=z1(4:5:num_total,:);
Y5=z1(5:5:num_total,:);

Xc=[X1;X3;X5];
Xt=[X2;X4];
Yc=[Y1;Y3;Y5];
Yt=[Y2;Y4];


X=NIR';
X=SNV(X); 

[dx1]=DERIV(X,1);      %X������*����
X1=X;
X=dx1;

[dx2]=DERIV(X,2);
X1=X;
X=dx2;

[z1, z2]=sort(Y);       %��Y�������򣬰���2��1����ѵ������Ԥ�⼯
X=X(z2,:);
num_total=150;  
 t1=X(1:3:num_total,:);
 t2=X(2:3:num_total,:);
 t3=X(3:3:num_total,:);
 Xc=[t1;t3];
 Xt=t2;
 t1=z1(1:3:num_total,:);
 t2=z1(2:3:num_total,:);
 t3=z1(3:3:num_total,:);
 Yc=[t1;t3];
 Yt=t2;


%%SPXY����   D:\������1\˶\404\code\matlab code\matlab code
[Xc,Xt,Yc,Yt]=spxy(X,Y,48);        %66����ѵ�������ֵ���������                           

%%��ͼ��䣬��У������Ԥ�⼯����һ��ͼ��
plot(Yc,Yc2,'o')         %model , Yc2��ʾУ������Ԥ��ֵ
hold on
plot(Yt,Yt2,'*')          %premodel �� Yt2��ʾԤ�⼯��Ԥ��ֵ
hold on
x=0:0.05:0.2;
y=x;
plot(x,y);
hold on;
xlabel('Measured value (mol��mL^{-1}��L^{-1})');        %��λҪ����ʵ����������
ylabel('Predicted value (mol��mL^{-1}��L^{-1})');
legend('R_c=0.9258 RMSEC=0.011','R_p=0.9030 RMSEP=0.014');




%ɸѡ������ԭͼ����
X0=mean(X);
plot(xaxis,X0);
hold on;
plot(xaxis(MMb),X0(1,MMb),'ro');
hold on;
plot(xaxis(CARS),X0(1,CARS),'bs');
hold on;
plot(xaxis(BOSS),X0(1,BOSS),'m+');
hold on;
xlabel('Wavelength (nm)');

X01=mean(X1);
plot(xaxis,X01);
hold on;
plot(xaxis(first),X01(1,first),'ro');

X07=mean(X7);
plot(xaxis,X07);
hold on;
plot(xaxis(second),X07(1,second),'ro');

X09=mean(X9);
plot(xaxis,X09);
hold on;
plot(xaxis(third),X09(1,third),'ro');

%ɸѡ������Ӧ����
xaxisCha = xaxis(cha,:);
xaxisFen = xaxis(fen,:);
xaxisTang = xaxis(tang,:);
xaxisKa = xaxis(ka,:);
xaxisYou = xaxis(you,:);

%��ӦY��
X0=mean(X);
plot(xaxis,X0);
%%plot(xaxis,[X1;x2])
hold on;
plot(xaxis1(MMb),-0.2,'ro');
hold on;
plot(xaxis2(DMb),-0.25,'bs');
hold on;
plot(xaxis3(OMb),-0.3,'m+');
hold on;
plot(xaxis4(Mb),-0.35,'g*');
hold on;
xlabel('Wavelength (nm)');



%Y����123456
for i=1:5
    Y(20*(i-1)+1:20*i,1) = i;
end

%ɸѡ�����ı�������Ӧ�Ĳ���


%%%%Siɸѡ�����������ȡ
intervals = oneModel.selected_intervals;
allint = oneModel.allint;
[m,n]=size(intervals);
[m1,n1] = size(allint);
allints=zeros(m,2);
for j=1:n
    for i=1:m1
        if allint(i,1) == intervals(1,j)
            allints(j,:) = allint(i,2:3);
        end
    end
end
%��ȡ��Ӧ�Ĳ�����
xaxisC = xaxis; 
rep1 = X; 
for i=1:n
    if i==1
        data1=rep1(:,allints(i,1):allints(i,2));
        xaxis1 = xaxisC(allints(i,1):allints(i,2));
        xaxis = xaxis1;
        X=data1;
    elseif i==2
        data2=rep1(:,allints(i,1):allints(i,2));
        xaxis2 = xaxisC(allints(i,1):allints(i,2));
        xaxis = [xaxis1;xaxis2];
        X=[data1,data2];
    elseif i==3
        data3= rep1(:,allints(i,1):allints(i,2));
        xaxis3 = xaxisC(allints(i,1):allints(i,2));
        xaxis = [xaxis1;xaxis2;xaxis3];
        X=[data1,data2,data3];
    elseif i==4
        data4= rep1(:,allints(i,1):allints(i,2));
        xaxis4 = xaxisC(allints(i,1):allints(i,2));
        xaxis = [xaxis1;xaxis2;xaxis3;xaxis4];
        X=[data1 data2 data3 data4];
    end
end


rep2 = Xc;
for i=1:n
    if i==1
        data1=rep2(:,allints(i,1):allints(i,2));
        Xc=data1;
    elseif i==2
        data2=rep2(:,allints(i,1):allints(i,2));
        Xc=[data1,data2];
    elseif i==3
        data3= rep2(:,allints(i,1):allints(i,2));
        Xc=[data1 data2 data3];
    elseif i==4
        data4= rep2(:,allints(i,1):allints(i,2));
        Xc=[data1 data2 data3 data4];
    end
end


rep3 = Xt;
for i=1:n
    if i==1
        data1=rep3(:,allints(i,1):allints(i,2));
        Xt=data1;
    elseif i==2
        data2=rep3(:,allints(i,1):allints(i,2));
        Xt=[data1,data2];
    elseif i==3
        data3= rep3(:,allints(i,1):allints(i,2));
        Xt=[data1 data2 data3];
    elseif i==4
        data4= rep3(:,allints(i,1):allints(i,2));
        Xt=[data1 data2 data3 data4];
    end
end

%%%%����si����ɸѡ���ֽ�һ������ɸѡ���ı���ͼ
X0=mean(X);
[m,n]=size(X0);
[m1,n1]=size(xaxis1);
[m2,n2]=size(xaxis2);
[m3,n3]=size(xaxis3);
[m4,n4]=size(xaxis4);
for i=1:n
    for j=1:m1
        if xaxis1(j) == xaxis(i)
            X1(1,j) = X0(1,i);
        end
    end
     for j=1:m2
        if xaxis2(j) == xaxis(i)
            X2(1,j) = X0(1,i);
        end
     end
     for j=1:m3
        if xaxis3(j) == xaxis(i)
            X3(1,j) = X0(1,i);
        end
     end
     for j=1:m4
        if xaxis4(j) == xaxis(i)
            X4(1,j) = X0(1,i);
        end
    end
end
figure,plot(xaxis,X0);
hold on;
plot(xaxis1(MMb),X1(MMb),'m*');
figure,plot(xaxis,X0);
hold on;
plot(xaxis2(DMb),X2(DMb),'m*');
figure,plot(xaxis,X0);
hold on;
plot(xaxis3(OMb),X3(OMb),'m*');
figure,plot(xaxis,X0);
hold on;
plot(xaxis4(Mb),X4(Mb),'m*');
hold on;
xlabel('Wavelength (nm)');