    %���׵���
    NIR=zeros(3648,20);
    for i=1:20
    t1=xlsread(strcat('C:\Users\79365\OneDrive\����\���� - ����\������300-1100\2023��������4��\20230504����-�ȷ�ɱ��\1��Ҷ\',num2str(i),'.xlsx'),'D1:D3648');
    t2=xlsread(strcat('C:\Users\79365\OneDrive\����\���� - ����\������300-1100\2023��������4��\20230504����-�ȷ�ɱ��\1��Ҷ\',num2str(i),'.xlsx'),'F1:F3648');
    t3=xlsread(strcat('C:\Users\79365\OneDrive\����\���� - ����\������300-1100\2023��������4��\20230504����-�ȷ�ɱ��\1��Ҷ\',num2str(i),'.xlsx'),'H1:H3648');
    t4=[t1 t2 t3];
    t=mean(t4,2);
    NIR(:,i)=t;
    end

-----------------------------------------------------
    %%������ɫ��Ϣ��ȡ
    NIR_color3=zeros(96,6);
    for i=1:96
        disp(num2str(i))
        filename=strcat('D:\������1\˶\ʵ��\����\zq2\��ɫ��\',num2str(i),'.xlsx');
        %filename=strcat('D:\������1\˶\ʵ��\����\zq2\��ɫ��\7.xlsx');
        t1=xlsread(filename,'B39:B44');
        t2=xlsread(filename,'E39:E44');
        t3=xlsread(filename,'H39:H44');
        t4=[t1 t2 t3];
        t=mean(t4,2);
        NIR_color3(i,:)=t';
    end

    
    %%����ѡȡ
    ���Ը���ʵ���������
    X2=X(260:3425,:);
    xaxis2=xaxis(261:3446,:);

    %%��������xaxis,�������Ƿ����ʻ�ǿ��
    plot(xaxis,X);
    ������������������������������������������������������������������������������������������������
    %%����Ԥ����
    Ԥ��������SNV�����ƽ��SG�������ź�У��(orthogonal signal correction, OSC) ���������ź� (net signal analysis, NAS) ������У�� (baseline correction, BC) ����Ԫɢ��У����MSC��

    %% SNV��  %X������*����       
    xsnv=SNV(X);
    plot(1:3648,xsnv)  %������ͼ��3648�Ǳ�����            

    %% һ���������׵���  �� \ D:\������1\˶\404\code\�㷨��CW)\�㷨��CW)\Ԥ����\  Ŀ¼������
    [dx1]=DERIV(X,1);      %X������*����
    [dx2]=DERIV(X,2);
    [dx3]=DERIV(X,3);
    plot(1:3648,dx1);     % ������ͼ

    %%center��ֵ���Ļ���%X������*����
    [cdata,me,ctest]=center(X',1,X');   %�������*������ ��Ҫת��
    plot(1:3648,cdata);  %������ͼ

    %MSC��%X������*����
    [xmsc,me,xtmsc]=MSC(x,first,last,xt);  %����Ҫ����
    [xmsc,me]=MSC(X,1,3648);  %1Ϊ��һ������ 3648Ϊ���һ������
    plot(1:3648,xmsc);  %������ͼ


    ������������������������������������������������������������������������������������������������
    %%��������3��2
    num_total=12;
    [z1 z2]=sort(Y);           %��Y��������z1Ϊ��������z2��ӳ����ʲô�ı�
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
    Yt=[Y2;Y4];

    %%��������2��1
    X=NIR';
    X=SNV(X); 
    [z1 z2]=sort(Y);       %��Y�������򣬰���2��1����ѵ������Ԥ�⼯
    X=X(z2,:);
    num_total=117;  
    t1=X(1:3:num_total,:);
    t2=X(2:3:num_total,:);
    t3=X(3:3:num_total,:);
    Xc=[t1;t3];
    Xt=[t2];
    t1=z1(1:3:num_total,:);
    t2=z1(2:3:num_total,:);
    t3=z1(3:3:num_total,:);
    Yc=[t1;t3];
    Yt=[t2];

    %%SPXY����   D:\������1\˶\404\code\matlab code\matlab code
    [Xc,Xt,Yc,Yt]=spxy(X,Y,96);        %66����ѵ�������ֵ���������
    ������������������������������������������������������������������������������������������������
    %%ɸѡ����
    ����SiPLS
    %% ouynag
    siModel=sipls(Xc,Yc,10,'mean',11,4,xaxis2,'syst123',5);
    siplstable(siModel);                     ����siModel-allint����֪����������Ĳ�����Χ��

    FinalModel=plsmodel(siModel,[ 1    4   10   11]  ,6,'mean','syst123',5);
    plspvsm(FinalModel,6,1);
    oneModel=plsmodel(siModel,  [ 1    4   10   11]  ,6,'mean','test',5);
    predModel=plspredict(Xc,oneModel,6,Yc);
    plspvsm(predModel,6,1,1)
    predModel=plspredict(Xt,oneModel,6,Yt);
    plspvsm(predModel,6,1,1);

    %% jianghao
    %% Si�������������䣩
    %jh_num=1;
    jh_nums=1;
    for js = 10:30
    for jh = 2:4
    siModel=sipls(X,Y,10,'mscmean',js,jh,[],'syst123',5);%ǰ��10��Ϊ���ɷ�������10��Ϊ����������2��������������
    %(siModel);%��ʾѵ���������һ������õģ��������Ҫ��Excelͳ�ƽ��

    %siplstable(siModel);%��ʾѵ���������һ������õģ��������Ҫ��Excelͳ�ƽ��
    result(jh_nums,1) = siModel.intervals;%����
    result(jh_nums,2) = siModel.minPLSC(1)%��������
    result(jh_nums,3) = max(siModel.IntComb{1});%���
    jh_intervals{jh_nums,1} = siModel.minComb{1};%��������
    result(jh_nums,4) = siModel.minRMSE(1);%��Сrmse
    %intervals(siModel);%��Model����ϸ��Ϣ������Щ���� ������ʼ��Χ
    %jh_num=jh_num+3;
    jh_nums=jh_nums+1;
    end
    end

    ������������������������������������������������������������������������������������������������
    ��������Ӧ��Ȩ�����㷨CARS       ��ŷ����  ��404\code\matlab code\matlab code\itoolbox\cars_pls�ļ���������
    MCCV=plsmccv(X,Y,15,'center',1000,0.8);
    CARS=carspls(X,Y,MCCV.optPC,5,'center',50); 
    plotcars(CARS);
    SelectedVariables=CARS.vsel;

    Xt3=Xt(:,SelectedVariables);
    Xc3=Xc(:,SelectedVariables);
    xaxis2=xaxis(:,SelectedVariables);

    Model=ipls(Xc3,Yc,7,'mean',1,[],'syst123',5);
    iplsplot(Model,'intlabel')
    plsrmse(Model,0)

    plspvsm(Model,6,1)
    oneModel=plsmodel(Model,1,6,'mean','syst123',5);
    predModel=plspredict(Xc3,oneModel,6,Yc);
    plspvsm(predModel,6)
    predModel=plspredict(Xt3,oneModel,6,Yt);
    plspvsm(predModel,6)

    %��SelectedVariablesѡ�����ı�����xaxis��ժ������Variables = xaxis(SelectedVariables,1);

    %��ԭͼ���������
    X0=mean(X);      %XΪԭʼ����*����
    plot(xaxis,X0);
    hold on;
    for i = 1:size(Variables,1)
    plot(xaxis(SelectedVariables(i)),X0(1,SelectedVariables(i)),'mp');
    hold on;
    end
    xlabel('Wavelength (nm)');
    ������������������������������������������������������������������������������������������������
    ������Ⱥ�㷨ACO ���������㷨���ڶ�Ӧ�ļ��������У�
    1.       D:\������1\˶\404\code\ACO+SA+GA+siPLS\ACO+SA+GA+siPLS\ACO-PLS
    Xcal_sim1=Xcal';
    save('Xcal_sim1.txt','Xcal_sim1','-ascii');
    ycal_sim1=Ycal;
    save('ycal_sim1.txt','ycal_sim1','-ascii');
    Xmon_sim1=Xtest';
    save('Xmon_sim1.txt','Xmon_sim1','-ascii');
    ymon_sim1=Ytest;
    save('ymon_sim1.txt','ymon_sim1','-ascii');
    2. ����aco_pls_main_code.m�ļ�.
    ���������һ��ͼƬ����ɫ����ȥ�� ��Ҫ�ر����ͼƬ����ɾ������ڶ���ͼƬ
    3. ����aco_pls_selv�ļ�.
    ����aco_pls_cal�ļ�.
    aco=[];
    aco=mean(X0')/max(mean(X0'));
    4.��excel�������ճ��
    ��һ����X��=(X-Xmin) / (Xmax-Xmin)   ��X��ָ3�е�[aco]��
    aco_new=[];
    ճ��
    hold on,plot(aco_new,'-r');      %���׹�һ������
    5.����ɸѡ�����ı�����XX=X(:,windows);      %XX������*����   �Ȳ���
    6. %�õ�ѡ��� xaxis��xaxis_1
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
    [Xc,Xt,Yc,Yt]=spxy(X,Y,96);

    %y0��Yc,ycal_sel��ѵ������Ԥ��ֵ��y1��Yt,ypred_sel��Ԥ�⼯��Ԥ��ֵ��
    %(cm^{-1}) ��ʾƽ������
    ������������������������������������������������������������������������������������������������
    ����ACO��·����D:\������1\˶\404\code\�㷨��CW)\ACO-pls��
    Xtest=Xtest';
    Xmon_sim1=Xtest;
    save('Xmon_sim1.txt','Xmon_sim1','-ascii')
    Xcal=Xcal';
    Xcal_sim1=Xcal;
    save('Xcal_sim1.txt','Xcal_sim1','-ascii')
    ymon_sim1=Ytest;
    save('ymon_sim1.txt','ymon_sim1','-ascii')
    ycal_sim1=Ycal;
    save('ycal_sim1.txt','ycal_sim1','-ascii'); %���ֺ����ѵ��Ԥ�⼯������ķ�������Ϊtxt�ļ�������>>��Ⱥ�㷨\ACO-pls�£�

    ����aco_pls_main_code.m�ļ�.Histo�������0��Ϊ��Ѳ��Σ�eg. X=B(:,[163 218 447 637 944 1063 1371 1445 1447 1501 1528 1602 1704 1861 1870 2004 2048 2073 2154 2195]);ѡ����Ѳ������ԭʼ���ݣ���������ּ���
    ����PLS        
    %  [Xc,Xt,Yc,Yt]=spxy(X,Y,66);
    %num_total=110;
    [z1 z2]=sort(Y);           
    X1=X(1:5:num_total,:);   
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

    %  ��Ⱥ�㷨��ɸѡ�����ķ�������GA�Աȣ�����ʱ·��Ҫѡ�������ļ��У�Initial   Final    Histo�������Histo�������0��Ϊ��Ѳ��Σ�����־����Ⱥ����
    Դ������ѵ����ת�� Ԥ�⼯��ת
    ��Ⱥ�㷨����Ҫ���ļ�����ѵ������Ԥ�⼯���ݻ����Լ������ݣ��ڸ���ʱ��Ԥ�⼯ֱ��ճ�����ļ���Ԥ�⼯txt���棬ѵ����Ҫ���������䣬ʵ��ת�ã������Զ�������ACO-pls�ļ���
    ����aco_pls_main_code.m�ļ�.
    ���ɵ�ͼƬ ֻ�����ϲ��� �������ɾ������ ������Ϊintensity ��ͬȨ�� 
    ����������������������������������������������������������������������������������������������������������������
    �����Ŵ��㷨GA
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

    ________________________________________________________________________________
    ����UVE ����Ϣ����������wjy    D:\������1\˶\404\code\matlab code\�㷨��SH��\���ݴ�������㷨\UVE-PLS��
    %[mean_b,std_b,t_values,var_retain,RMSECVnew,Yhat,E]=plsuve(X,Y,a,nxvals,pZ,cutoff); 
    %  X          predictor data matrix                    (n x px)   original   
    %  Y          predictand data vector                   (n x 1)    original   
    %  a          # components to determine the criterion  (1 x 1)   ���ɷ���Ŀ��ȡ10����15   
    %  nxvals     # jackknifing and CV groups            (1 x 1)   <optional> default: n  
    %  pZ         # of random variables                 (1 x 1)   <optional> default: px 
    %  cutoff     cutoff level considered             (1 x 1)   <optional> default: 0.99 

    %  var_retain indexes of the retained variables
    [mean_b,std_b,t_values,var_retain,RMSECVnew,Yhat,E]=plsuve(X,Y,20,144,2924,0.99);

    for i=1:73
        X1(:,i) = X(:,(var_retain(1,i)));      %�ǵ���������X
    end

    [Xc,Xt,Yc,Yt]=spxy(X,Y,96);        %66����ѵ�������ֵ���������
    %���»�������������PLS
    num_total = 144;
    [Y z2]=sort(Y);  %(XΪ������*������)
    X=X(z2,:);  
    X1=X(1:5:num_total ,:);   
    X2=X(2:5:num_total ,:);
    X3=X(3:5:num_total ,:);
    X4=X(4:5:num_total ,:);
    X5=X(5:5:num_total ,:); 
    Xc=[X1;X4;X5];  
    Xt=[X2;X3];
    Y1=Y(1:5:num_total ,:);   
    Y2=Y(2:5:num_total ,:);
    Y3=Y(3:5:num_total ,:);
    Y4=Y(4:5:num_total ,:);
    Y5=Y(5:5:num_total ,:); 
    Yc=[Y1;Y4;Y5];  
    Yt=[Y2;Y3];

    Model=ipls(Xc,Yc,10,'mean',1,[],'syst123',5);
    iplsplot(Model,'intlabel');
    plsrmse(Model,0);

    num_total =10;   %���ɷ���
    plspvsm(Model,num_total,1);
    oneModel=plsmodel(Model,1,num_total,'mean','test',5);  
    predModel=plspredict(Xc,oneModel,num_total,Yc);
    plspvsm(predModel,num_total,1,1);    %��RMSEP�ĳ�RMSEC
    predModel=plspredict(Xt,oneModel,num_total,Yt);
    plspvsm(predModel,num_total,1,1);      %Ԥ�⼯�Ľ��  

    X_new=XX(:,var_retain(:,1:967));      %��ѡ�еı����������һ���µľ���X_new
    xaxis1=xaxis(var_retain);     %ѡ����Ӧ�Ĳ���

    %��ԭͼ���������
    X0=mean(XX);      %XXΪԭʼ����*����
    plot(xaxis,X0);
    hold on;
    for i = 1:size(xaxis1,1)
    plot(xaxis(var_retain(i)),X0(1,var_retain(i)),'mp');
    hold on;
    end
    xlabel('Wavelength (nm)');
    ������������������������������������������������������������������������������������������������������������
    ����MCUVE��SH    D:\������1\˶\404\code\matlab code\�㷨��SH��\���ݴ�������㷨\����ɸѡ�㷨\UVE����Ϣ��������      mcuvepls.m��
    A=15;     %The max PC for cross-validation��һ��Ϊ10����15
    method='center';
    N=10000;       %��������
    ratio=0.75;     %У���������������ı���
    UVE=mcuvepls(Xcal,Ycal,A,method,N,ratio);
    plot(abs(UVE.RI),'linewidth',2);
    xlabel('variable index');
    ylabel('reliability index');
    set(gcf,'color','w');

    %����������MCUVE���ٽ����������� ��%MCUVE +%UVEɸѡ��������)
    %UVEɸѡ����
    All_RMSEP=[];
    All_optLV =[];
    All_R2 =[];
    for i = 1:449     %�������7��ϵ��7��Ϊһ�飬�ظ�����449�Σ�7���Ը��ݱ����䣬ʹ������
    Xcal1=Xcal(:,UVE.SortedVariable(1,1:i*7));%�����Ӻõ�����UVE.SortedVariable����
    ycal=Ycal;
    Xtest1=Xtest(:,UVE.SortedVariable(1,1:i*7));
    ytest=Ytest;
    CV=plscv(Xcal1,ycal,15,10);    %by default, 'center' is used for data pretreatment inside plscv.m.
    All_optLV(1,i) = CV.optLV;
    PLS=pls(Xcal1,ycal,CV.optLV,'center');  
    All_R2(1,i) = PLS.R2;    %�����Ѿ����ж���pls���㣬ÿ7��Ϊһ�飬ÿ��Ľ����All_R2չʾ���ҵ�����R2����Ӧ���кţ�����ѡ����ô���飬����ڰ���R2Ϊ0.998�������UVE.SortedVariable��ѡ��ǰ56��������*������������ɸѡ����������Լ���������pls
    [ypred,All_RMSEP(1,i)]=plsval(PLS,Xtest1,ytest); 
    end
    plot(1:449,All_RMSEP)   %��ֵ��forͬ��������ÿ����RMSEP�ı仯

    %������� �� All_R2��ѡ����������ҵ�����R����Ӧ�����֣�����*����������8=0.998������UVE.SortedVariable��ѡ��ǰ56��������
    [m n]=max(All_R2);

    %�����������ȡ����  �ѱ�����Ӧ�Ĳ���ѡȡ������ɸѡ����������Լ���������pls
    submatrix = zeros(110,56); %Ŀ������С
    for i = 1:56 %108ָҪѡ�ı�����
        submatrix(:,i) = X(:,UVE.SortedVariable(1,i));
    end
    xaxis1=xaxis(UVE.SortedVariable(1:28));
    ������������������������������������������������������������������������������������������������������������
    ������������㷨RF��randomfrog algorithm   D:\������1\˶\404\code\matlab code\�㷨��SH��\���ݴ�������㷨\����ɸѡ�㷨\RF��������㷨��
    %RF-PLS��һ�ֽ��������Ծ����ɷ������ؿ��޿�ܵ���ѧ�򵥡�����Ч�ʸߵĲ���ѡ���㷨��ÿ��������ѡ���������ͨ��ģ������ɷ���������ģ�������ѭģ�Ϳռ��е���̬�ֲ�
    %Random frog also belongs to the category of model population analysis (MPA) approaches
    %+++A��The maximal number of latent variables for cross-validation
    %+++N: here N is set to be small only for demo. Usually it is set to be 10000 or larger.
    %+++Q: the number of variables in the initial model for jumping

    Xcal=Xc;Xtest=Xt;Ycal=Yc;Ytest=Yt;
    A=10;
    method='center';
    N=10000;   
    Q=2;   
    Frog=randomfrog_pls(Xcal,Ycal,A,method,N,Q);
    plot(xaxis,Frog.probability);        %Frog.probability�����б�����ѡ��ĸ���
    xlabel('Wavelength (nm)');
    ylabel('Selection probability');
    set(gcf,'color','w');

    All_RMSEP=[];
    All_optLV =[];
    All_R2 =[];
    for i = 1:449      %�������7��ϵ��������ı������з��飬�ܹ���������
    Xcal1=Xcal(:,Frog.Vrank(1,1:i*7));   %�����Ӻõ�����UVE.SortedVariable����
    ycal=Ycal;
    Xtest1=Xtest(:,Frog.Vrank(1,1:i*7));
    ytest=Ytest;
    CV=plscv(Xcal1,ycal,15,10);  %by default, 'center' is used for data pretreatment inside plscv.m.
    All_optLV(1,i) = CV.optLV;
    PLS=pls(Xcal1,ycal,CV.optLV,'center');  
    All_R2(1,i) = PLS.R2; 
    [ypred,All_RMSEP(1,i)]=plsval(PLS,Xtest1,ytest); 
    end
    plot(1:449,All_RMSEP)    %��ֵ��forͬ��������ÿ����RMSEP�ı仯

    %�����������ȡ��������  �ѱ�����Ӧ�Ĳ���ѡȡ����
    [m n]=max(All_R2);
    submatrix = zeros(110,1323);   %110*28 Ŀ������С
    for i = 1:1323  %28ָҪѡ�ı�����
        submatrix(:,i) = X(:,Frog.Vrank(1,i));
    end
    xaxis1=xaxis(Frog.Vrank(1:21));
    %���·���Ԥ�⣬����PLS
    X=submatrix��

    %%%���ֱ������ randomfrog_pls.m �ļ���������������佫���ʴ���һ��ֵ�ı���ȡ����%%%
    nu_of_var=3143      %ȫ����������
    selectprobablity=0.75     %������ѡ�����
    waveselect=zeros(2,nu_of_var);
    for i=1:nu_of_var
        if F.probability(1,i)>selectprobablity
            waveselect(1,i)=i;
            waveselect(2,i)=F.probability(1,i);
        end
    end
    waveselect = nonzeros(waveselect)
    ������������������������������������������������������������������������������������������������
    ����BOSS
    ��D:\������1\˶\404\code\matlab code\matlab code\code-boss\bianliang.txt��
    [r,c]=find(BOSS.variable_index==1);

    ����
    L=[];
    M=[];
    N=[];
    for i=1:14
    L=find(BOSS.W(:,i)~=0);
    M=length(L);
    N=[N M ];
    end


    ��D:\������1\˶\404\code\matlab code\matlab code\code-boss\example.m��
    Xcal=Xc;
    ycal=Yc;
    Xtest=Xt;
    ytest=Yt;
    nLV_max=10;
    fold=5;
    method='center';
    num_bootstrap=1000;
    BOSS=boss(Xcal,ycal,nLV_max,fold,method,num_bootstrap,0);
    BOSS=boss(X,Y,nLV_max,fold,method,num_bootstrap,0);
    boss_rmsecv=BOSS.minRMSECV;
    boss_q2_cv=BOSS.Q2_max;
    boss_variable_index=BOSS.variable_index;
    [boss_rmsep,boss_rmsec,boss_q2_test,boss_q2_train, yfit, ypred]=predict(Xcal,ycal,Xtest,ytest,BOSS.variable_index==1,BOSS.optPC,method);

    ������������������������������������������������������������������������������������������������
    %%%%%%%%%%%%��ģ%%%%%%%%%%%%%%
    ������PLS��Si-PLS��CARS-PLS��ACO-PLS��GA-PLS
    ���ԣ����ɭ��RF�����ɷַ���PCA��Fisher�����б�LDA��K���ڽ��б�KNN��BP�����硢֧��������SVM������ѧϰ��ELM
    ����PLS
    %[Xc,Xt,Yc,Yt]=spxy(X,Y,66); 
    %num_total=110;
    [z1 z2]=sort(Y);           %��Y��������z1Ϊ��������z2��ӳ����ʲô�ı�
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
    Yt=[Y2;Y4];

    Model=ipls(Xc,Yc,10,'mean',1,[],'syst123',5);
    iplsplot(Model,'intlabel');
    plsrmse(Model,0);

    num_total =8;     %�������ɷ���
    plspvsm(Model,num_total,1);
    oneModel=plsmodel(Model,1,num_total,'mean','test',5);  
    predModel=plspredict(Xc,oneModel,num_total,Yc);
    plspvsm(predModel,num_total,1,1);
    predModel=plspredict(Xt,oneModel,num_total,Yt);
    plspvsm(predModel,num_total,1,1);

    ������������������������������������������������������������������������������������������������
    ����PCA ��PCA.m�ļ���
    [coeff1,score,latent1]=princomp(X);%ԭ���������ɷ֣�SCOREΪ��ȡ���ɷֺ�ı�����LATENTΪÿ�����ɷֵĹ����� ���Ծ���Ҫ�˲���% AΪ����*����ʱ����ת��
    scatter3(score(1:15,1),score(1:15,2),score(1:15,3),'ro')%����1234������л�ͼ 3D
    hold on
    scatter3(score(16:29,1),score(16:29,2),score(16:29,3),'g+')
    hold on
    scatter3(score(30:44,1),score(30:44,2),score(30:44,3),'ms')
    hold on
    scatter3(score(45:59,1),score(45:59,2),score(45:59,3),'k*')
    hold on
    scatter3(score(60:74,1),score(60:74,2),score(60:74,3),'b+')
    hold on
    scatter3(score(75:89,1),score(75:89,2),score(75:89,3),'yp');
    hold on
    scatter3(score(90:104,1),score(90:104,2),score(90:104,3),'b>')
    hold on

    ������������������������������������������������������������������������������������������������
    ����LDA (ֱ������LDA.m�ļ�) ��Y�Ƿ���ı�ǩ��
    x1=X(1:5:104,:);
    x2=X(2:5:104,:);
    x3=X(3:5:104,:);
    x4=X(4:5:104,:);
    x5=X(5:5:104,:);
    Xc=[x1;x3;x5];
    Xt=[x2;x4];
    Y1 = Y(1:5:104,1);
    Y2 = Y(2:5:104,1);
    Y3 = Y(3:5:104,1);
    Y4 = Y(4:5:104,1);
    Y5 = Y(5:5:104,1);
    Yc = [Y1;Y3;Y5];
    Yt = [Y2;Y4];
    [coeff1,score1,latent1] = princomp(Xc);
    PC1=score1;
    [coeff,score,latent] = princomp(Xt);
    PC2=score;
    for i=1:10   %ǰ����PC �����15ָ15�����ɷ֣����Զ���һ�㶼�Ƿ�15��
    xx1=PC1(:,1:i);
    xx2=PC2(:,1:i);
    class1 = classify(xx1,xx1,Yc);
    T=class1-Yc;
    L=find(T==0);
    r1(i)=length(L)/length(Yc);%ѵ����
    class2 = classify(xx2,xx1,Yc);                                                                                                   
    T2=class2-Yt;
    L2=find(T2==0);
    R(i)=length(L2)/length(Yt);%Ԥ�⼯
    end
    R
    r1
    KK=[r1;R];
    bar(KK')

    ����������������������������������������������������������������������������������������������
    ����KNN ������ʦ��knn.m,ֱ������m�ļ�����Y�Ƿ���ı�ǩ���������겻��12345������3 5 7 9 11��
    % ��һ������ȡ���ɷ֣������ݽ��н�ά
    %X = mapminmax(X,0,1); %�����ݽ��й�һ����X������*������
    [coeff, score, latent] = princomp(X);

    %�ڶ�����ѵ������
    x1=score(1:5:104,1:12);
    x2=score(2:5:104,1:12);
    x3=score(3:5:104,1:12);
    x4=score(4:5:104,1:12);
    x5=score(5:5:104,1:12);
    %x6=score(6:6:216,1:10);
    Xcal=[x1;x3;x5];
    Xtest=[x2;x4];%(�ȷ�ѵ����Ԥ�⣩yҲ��
    Y1 = Y(1:5:104,1);
    Y2 = Y(2:5:104,1);
    Y3 = Y(3:5:104,1);
    Y4 = Y(4:5:104,1);
    Y5 = Y(5:5:104,1);
    %Y6 = Y(6:6:216,1);
    Ycal = [Y1;Y3;Y5];
    Ytest = [Y2;Y4];
    xtrain=Xcal;
    xtest=Xtest;
    ytrain=Ycal;
    ytest=Ytest;

    %knn�㷨ʵ��
    for i=1:12;  %i is the row of ��E/F����On behalf of the principal component
    xtr=Xcal(:,1:i);%ѵ������ѡȡǰ12�����ɷ�
    xte=Xtest(:,1:i);%���Լ���ѡȡǰ12�����ɷ�
    [gamm,alpha] = knndsinit(xtr,ytrain);
        for k=2:12;  %j is the column of��E/F����On behalf of K value 
            if mod(k,2) ~= 0 %kֵֻ��������
                [m1,L1] = knndsval(xtr,ytrain,k,gamm,alpha,1);
                p1=ytrain-L1;
                I1=find(p1~=0);
                r1=length(I1);%ѵ���������еĽ��
                r2=length(ytrain);
                E(i,(k-1)/2)=1-r1/r2;%ѵ������ȷ������
                [m2,L2] = knndsval(xtr,ytrain,k,gamm,alpha,0,xte);
                p2=ytest-L2;
                I2=find(p2~=0);
                q1=length(I2);%���Լ������еĽ��
                q2=length(ytest);
                F(i,(k-1)/2)=1-q1/q2;%���Լ���ȷ������
            end
        end
    end
    %mesh (E);
    mesh(F);

    ������������������������������������������������������������������������������������������������
    ����RF ��D:\������1\˶\404\code\�㷨��CW)\�㷨��CW)\���ɭ��\RandomForest_matlab����ֱ�Ӱ�������RF.m�ļ�����Y�Ƿ���ı�ǩ��
    X1=dx2(1:5:104,:);   %ѵ����Ԥ����3:2��(�м�Ϊ5����1:1�����м�Ϊ2������50��������ÿ5����Ϊһ��                  С���� ÿ��С������ 1��3��5 Ϊѵ����2��4ΪԤ��
    X2=dx2(2:5:104,:);
    X3=dx2(3:5:104,:);
    X4=dx2(4:5:104,:);
    X5=dx2(5:5:104,:);

    Y1=Y(1:5:104,:);   %ѵ����Ԥ����3:2��(�м�Ϊ5����1:1�����м�Ϊ2������50��������ÿ5����Ϊһ��                  С���� ÿ��С������ 1��3��5 Ϊѵ����2��4ΪԤ��
    Y2=Y(2:5:104,:);
    Y3=Y(3:5:104,:);
    Y4=Y(4:5:104,:);
    Y5=Y(5:5:104,:);

    Xtr=[X1;X3;X5];
    Xte=[X2;X4];
    Ytr=[Y1;Y3;Y5];
    Yte=[Y2;Y4];

    % ѵ������
    P_train = Xtr;
    T_train = Ytr;
    % ��������
    P_test = Xte;
    T_test = Yte;

    %% ���ɭ���о��������������ܵ�Ӱ��
    Accuracy = zeros(1,10);
    for i = 50:50:150
        i
        %ÿ�����������100�Σ�ȡƽ��ֵ
        accuracy = zeros(1,100);
        for k = 1:100
            % �������ɭ��
            model = classRF_train(P_train,T_train,i);
            % �������
            T_sim = classRF_predict(P_test,model);
            accuracy(k) = length(find(T_sim == T_test)) / length(T_test);
        end
        Accuracy(i/50) = mean(accuracy);
    end

    % ��ͼ
    % figure
    % plot(50:50:150,Accuracy)
    % xlabel('���ɭ���о���������')
    % ylabel('������ȷ��')
    % title('���ɭ���о��������������ܵ�Ӱ��')

    ������������������������������������������������������������������������������������������������
    %%��ͼ��䣬��У������Ԥ�⼯����һ��ͼ��
    plot(Yc,Yc2,'o')         %model , Yc2��ʾУ������Ԥ��ֵ
    hold on
    plot(Yt,Yt2,'*')          %premodel �� Yt2��ʾԤ�⼯��Ԥ��ֵ
    hold on
    x=25:5:45;
    y=x;
    plot(x,y);
    hold on;
    xlabel('Measured value (%)');        %��λҪ����ʵ����������
    ylabel('Predicted value (%)');
    legend('R_c=0.8908 RMSEC=1.320','R_p=0.8026 RMSEP=1.460');


    SD=Yt/Yt2     ��Ԥ�⼯��Ԥ�⼯��Ԥ��ֵ��
    RPD=SD/RMSEP

    ����������������������������������������������������������������������������������������������������
    %%����modelģ��    D:\������1\˶\404\code\matlab code\����Ԥ��ģ�͵�������㷨-SH.txt
    %>>>>>>>>>>>>>>>>>>PLSģ�͵���
    %[model, error] = trainPLS(x, y, n, m, sampleNum);  %����ѵ��ģ�ͣ����Ϊ��������ϵ����
    % n ���Ա����ĸ���,m ��������ĸ������ó�һ��ֵ��Ϊ1��
    % x ���Ա������� y �����������

    %>>>>>>>>>>>>>>>>>>si-PLSģ��ϵ������
    x=[X(:,136:162)  X(:,163:189) X(:,217:243) X(:,271:296)];%ɸѡ�����Ա�����ɵľ���
    %x=X(:,ss);  
    y=Y;
    [model, error] = trainPLS(x, y,107, 1, 78)
    index=[(136:162)  (163:189) (217:243) (271:296)]';

    %>>>>>>>>>>>>>>>>����Ԥ�⼯ģ�ͺ�ϵ��(GA-PLS)
    x=X(:,GA1);
    y=Y;
    [model, error] = trainPLS(x,y,46,1,78);
    index=GA1';

    %>>>>>>>>>>>>>>>>����Ԥ�⼯ģ�ͺ�ϵ��(CARS)
    x=X��:,[ 1	4	9	12	14	18	27	38	61	65	67	108	119	122	123	132	141	143	151	153	165	181	187	192	193	223	224	230	343	347	349	351	369	372	379	380	383	394	397	398]); 
    y=Y;
    [model, error] = trainPLS(x, y,40, 1, 78)
    index=[1	4	9	12	14	18	27	38	61	65	67	108	119	122	123	132	141	143	151	153	165	181	187	192	193	223	224	230	343	347	349	351	369	372	379	380	383	394	397	398 ]';

    %>>>>>>>>>>>>>>>>����Ԥ�⼯ģ�ͺ�ϵ��(ACO)
    %x=X(:,[270	28	31	103	204	235	237	311	63	208	252	50	69	182	223	231	273	351	399]);
    x=X;
    y=Y;
    [model, error] = trainPLS(x, y,19, 1, 78)
    %index=[15	19	20	34	90	96	100	115	235	244	265	330	363	373	376	382	386	387	388	392	394	398]';


