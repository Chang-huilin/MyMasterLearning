    %光谱导入
    NIR=zeros(3648,20);
    for i=1:20
    t1=xlsread(strcat('C:\Users\79365\OneDrive\桌面\数据 - 副本\近红外300-1100\2023春茶试验4批\20230504春茶-热风杀青\1鲜叶\',num2str(i),'.xlsx'),'D1:D3648');
    t2=xlsread(strcat('C:\Users\79365\OneDrive\桌面\数据 - 副本\近红外300-1100\2023春茶试验4批\20230504春茶-热风杀青\1鲜叶\',num2str(i),'.xlsx'),'F1:F3648');
    t3=xlsread(strcat('C:\Users\79365\OneDrive\桌面\数据 - 副本\近红外300-1100\2023春茶试验4批\20230504春茶-热风杀青\1鲜叶\',num2str(i),'.xlsx'),'H1:H3648');
    t4=[t1 t2 t3];
    t=mean(t4,2);
    NIR(:,i)=t;
    end

-----------------------------------------------------
    %%光谱颜色信息提取
    NIR_color3=zeros(96,6);
    for i=1:96
        disp(num2str(i))
        filename=strcat('D:\刘丽华1\硕\实验\翟琪\zq2\颜色长\',num2str(i),'.xlsx');
        %filename=strcat('D:\刘丽华1\硕\实验\翟琪\zq2\颜色长\7.xlsx');
        t1=xlsread(filename,'B39:B44');
        t2=xlsread(filename,'E39:E44');
        t3=xlsread(filename,'H39:H44');
        t4=[t1 t2 t3];
        t=mean(t4,2);
        NIR_color3(i,:)=t';
    end

    
    %%波段选取
    可以根据实际情况调整
    X2=X(260:3425,:);
    xaxis2=xaxis(261:3446,:);

    %%横坐标是xaxis,纵坐标是反射率或强度
    plot(xaxis,X);
    ————————————————————————————————————————————————
    %%光谱预处理
    预处理方法：SNV、卷积平滑SG、正交信号校正(orthogonal signal correction, OSC) 、净分析信号 (net signal analysis, NAS) 、基线校正 (baseline correction, BC) 、多元散射校正（MSC）

    %% SNV：  %X是样本*变量       
    xsnv=SNV(X);
    plot(1:3648,xsnv)  %输出结果图，3648是变量数            

    %% 一、二、三阶导：  在 \ D:\刘丽华1\硕\404\code\算法（CW)\算法（CW)\预处理\  目录下运行
    [dx1]=DERIV(X,1);      %X是样本*变量
    [dx2]=DERIV(X,2);
    [dx3]=DERIV(X,3);
    plot(1:3648,dx1);     % 输出结果图

    %%center均值中心化：%X是样本*变量
    [cdata,me,ctest]=center(X',1,X');   %如果变量*样本数 需要转置
    plot(1:3648,cdata);  %输出结果图

    %MSC：%X是样本*变量
    [xmsc,me,xtmsc]=MSC(x,first,last,xt);  %不需要输入
    [xmsc,me]=MSC(X,1,3648);  %1为第一个变量 3648为最后一个变量
    plot(1:3648,xmsc);  %输出结果图


    ————————————————————————————————————————————————
    %%划分样本3：2
    num_total=12;
    [z1 z2]=sort(Y);           %对Y进行排序，z1为排序结果，z2反映做了什么改变
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

    %%划分样本2：1
    X=NIR';
    X=SNV(X); 
    [z1 z2]=sort(Y);       %对Y进行排序，按照2：1划分训练集和预测集
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

    %%SPXY划分   D:\刘丽华1\硕\404\code\matlab code\matlab code
    [Xc,Xt,Yc,Yt]=spxy(X,Y,96);        %66代表训练集划分的样本数量
    ————————————————————————————————————————————————
    %%筛选变量
    ——SiPLS
    %% ouynag
    siModel=sipls(Xc,Yc,10,'mean',11,4,xaxis2,'syst123',5);
    siplstable(siModel);                     （看siModel-allint可以知道具体区间的波长范围）

    FinalModel=plsmodel(siModel,[ 1    4   10   11]  ,6,'mean','syst123',5);
    plspvsm(FinalModel,6,1);
    oneModel=plsmodel(siModel,  [ 1    4   10   11]  ,6,'mean','test',5);
    predModel=plspredict(Xc,oneModel,6,Yc);
    plspvsm(predModel,6,1,1)
    predModel=plspredict(Xt,oneModel,6,Yt);
    plspvsm(predModel,6,1,1);

    %% jianghao
    %% Si（初步划分区间）
    %jh_num=1;
    jh_nums=1;
    for js = 10:30
    for jh = 2:4
    siModel=sipls(X,Y,10,'mscmean',js,jh,[],'syst123',5);%前“10”为主成分数，后“10”为区间数，“2”是联合区间数
    %(siModel);%显示训练结果，第一行是最好的，所以最后要用Excel统计结果

    %siplstable(siModel);%显示训练结果，第一行是最好的，所以最后要用Excel统计结果
    result(jh_nums,1) = siModel.intervals;%区间
    result(jh_nums,2) = siModel.minPLSC(1)%主因子数
    result(jh_nums,3) = max(siModel.IntComb{1});%间隔
    jh_intervals{jh_nums,1} = siModel.minComb{1};%具体区间
    result(jh_nums,4) = siModel.minRMSE(1);%最小rmse
    %intervals(siModel);%看Model的详细信息，有哪些变量 波长起始范围
    %jh_num=jh_num+3;
    jh_nums=jh_nums+1;
    end
    end

    ————————————————————————————————————————————————
    ——自适应加权抽样算法CARS       用欧阳的  在404\code\matlab code\matlab code\itoolbox\cars_pls文件夹下运行
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

    %将SelectedVariables选出来的变量从xaxis里摘出来：Variables = xaxis(SelectedVariables,1);

    %在原图上做出标记
    X0=mean(X);      %X为原始样本*变量
    plot(xaxis,X0);
    hold on;
    for i = 1:size(Variables,1)
    plot(xaxis(SelectedVariables(i)),X0(1,SelectedVariables(i)),'mp');
    hold on;
    end
    xlabel('Wavelength (nm)');
    ————————————————————————————————————————————————
    ——蚁群算法ACO （看郭闯算法，在对应文件夹下运行）
    1.       D:\刘丽华1\硕\404\code\ACO+SA+GA+siPLS\ACO+SA+GA+siPLS\ACO-PLS
    Xcal_sim1=Xcal';
    save('Xcal_sim1.txt','Xcal_sim1','-ascii');
    ycal_sim1=Ycal;
    save('ycal_sim1.txt','ycal_sim1','-ascii');
    Xmon_sim1=Xtest';
    save('Xmon_sim1.txt','Xmon_sim1','-ascii');
    ymon_sim1=Ytest;
    save('ymon_sim1.txt','ymon_sim1','-ascii');
    2. 运行aco_pls_main_code.m文件.
    保留上面第一幅图片（红色曲线去除 不要关闭这个图片），删除下面第二幅图片
    3. 运行aco_pls_selv文件.
    运行aco_pls_cal文件.
    aco=[];
    aco=mean(X0')/max(mean(X0'));
    4.在excel中运算后粘贴
    均一化法X’=(X-Xmin) / (Xmax-Xmin)   （X代指3中的[aco]）
    aco_new=[];
    粘贴
    hold on,plot(aco_new,'-r');      %光谱归一化曲线
    5.导出筛选出来的变量：XX=X(:,windows);      %XX是样本*变量   先不看
    6. %得到选择的 xaxis即xaxis_1
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

    X_new=X(:,histo_1);   %将选择出来的变量合并成新的矩阵
    X= X_new;
    [Xc,Xt,Yc,Yt]=spxy(X,Y,96);

    %y0即Yc,ycal_sel是训练集的预测值，y1即Yt,ypred_sel是预测集的预测值。
    %(cm^{-1}) 表示平方厘米
    ————————————————————————————————————————————————
    》》ACO（路径：D:\刘丽华1\硕\404\code\算法（CW)\ACO-pls）
    Xtest=Xtest';
    Xmon_sim1=Xtest;
    save('Xmon_sim1.txt','Xmon_sim1','-ascii')
    Xcal=Xcal';
    Xcal_sim1=Xcal;
    save('Xcal_sim1.txt','Xcal_sim1','-ascii')
    ymon_sim1=Ytest;
    save('ymon_sim1.txt','ymon_sim1','-ascii')
    ycal_sim1=Ycal;
    save('ycal_sim1.txt','ycal_sim1','-ascii'); %将分好类的训练预测集按上面的方法保存为txt文件放置在>>蚁群算法\ACO-pls下，

    运行aco_pls_main_code.m文件.Histo结果不是0的为最佳波段，eg. X=B(:,[163 218 447 637 944 1063 1371 1445 1447 1501 1528 1602 1704 1861 1870 2004 2048 2073 2154 2195]);选出最佳波段组成原始数据，重新排序分集。
    运行PLS        
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

    %  蚁群算法是筛选变量的方法，与GA对比，运行时路径要选中整个文件夹，Initial   Final    Histo最后结果，Histo结果不是0的为最佳波段，看郭志明蚁群论文
    源代码中训练集转置 预测集不转
    蚁群算法首先要将文件夹中训练集和预测集数据换成自己的数据，在更换时，预测集直接粘贴在文件中预测集txt里面，训练集要运行这个语句，实现转置，数据自动保存在ACO-pls文件夹
    运行aco_pls_main_code.m文件.
    生成的图片 只保留上部分 把下面的删除即可 纵坐标为intensity 如同权重 
    ————————————————————————————————————————————————————————
    ——遗传算法GA
    dataset=[Xc Yc];
    gaplsopt(dataset,1);    %1为固定
    gaplsopt(dataset,2);    %2为固定

    [bi,ci,di]=gapls(dataset,178);    %178为上一步运行的结果

    boshu1=1:99;
    GA1=bi(1:99);  %99为上一步运行的结果，变量数
    Xc1=Xc(:,GA1);
    Xt1=Xt(:,GA1);   %筛选变量结束，下面运行PLS（也就是使用筛选出来的变量进行PLS建模）
    
    Model=ipls(Xc1,Yc,11,'mean',1,[],'syst123',5);   %基本同PLS算法，只是变量要使用GA算法筛选出来的
    plsrmse(Model,0);   %得出主成分数，0是个参数

    plspvsm(Model,10,1); 
    oneModel=plsmodel(Model,1,10,'mean','test',5);
    predModel=plspredict(Xt1,oneModel,10,Yt);
    plspvsm(predModel,10); 

    ________________________________________________________________________________
    ——UVE 无信息变量消除（wjy    D:\刘丽华1\硕\404\code\matlab code\算法（SH）\数据处理相关算法\UVE-PLS）
    %[mean_b,std_b,t_values,var_retain,RMSECVnew,Yhat,E]=plsuve(X,Y,a,nxvals,pZ,cutoff); 
    %  X          predictor data matrix                    (n x px)   original   
    %  Y          predictand data vector                   (n x 1)    original   
    %  a          # components to determine the criterion  (1 x 1)   主成分数目，取10或者15   
    %  nxvals     # jackknifing and CV groups            (1 x 1)   <optional> default: n  
    %  pZ         # of random variables                 (1 x 1)   <optional> default: px 
    %  cutoff     cutoff level considered             (1 x 1)   <optional> default: 0.99 

    %  var_retain indexes of the retained variables
    [mean_b,std_b,t_values,var_retain,RMSECVnew,Yhat,E]=plsuve(X,Y,20,144,2924,0.99);

    for i=1:73
        X1(:,i) = X(:,(var_retain(1,i)));      %记得重新命名X
    end

    [Xc,Xt,Yc,Yt]=spxy(X,Y,96);        %66代表训练集划分的样本数量
    %重新划分样本，运行PLS
    num_total = 144;
    [Y z2]=sort(Y);  %(X为样本数*变量数)
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

    num_total =10;   %主成分数
    plspvsm(Model,num_total,1);
    oneModel=plsmodel(Model,1,num_total,'mean','test',5);  
    predModel=plspredict(Xc,oneModel,num_total,Yc);
    plspvsm(predModel,num_total,1,1);    %把RMSEP改成RMSEC
    predModel=plspredict(Xt,oneModel,num_total,Yt);
    plspvsm(predModel,num_total,1,1);      %预测集的结果  

    X_new=XX(:,var_retain(:,1:967));      %将选中的变量重新组成一个新的矩阵X_new
    xaxis1=xaxis(var_retain);     %选出对应的波长

    %在原图上做出标记
    X0=mean(XX);      %XX为原始样本*变量
    plot(xaxis,X0);
    hold on;
    for i = 1:size(xaxis1,1)
    plot(xaxis(var_retain(i)),X0(1,var_retain(i)),'mp');
    hold on;
    end
    xlabel('Wavelength (nm)');
    ——————————————————————————————————————————————————————
    ——MCUVE（SH    D:\刘丽华1\硕\404\code\matlab code\算法（SH）\数据处理相关算法\变量筛选算法\UVE无信息变量消除      mcuvepls.m）
    A=15;     %The max PC for cross-validation，一般为10或者15
    method='center';
    N=10000;       %迭代次数
    ratio=0.75;     %校正样本与总样本的比例
    UVE=mcuvepls(Xcal,Ycal,A,method,N,ratio);
    plot(abs(UVE.RI),'linewidth',2);
    xlabel('variable index');
    ylabel('reliability index');
    set(gcf,'color','w');

    %运行完上面MCUVE后，再进行下面运算 （%MCUVE +%UVE筛选变量整体)
    %UVE筛选变量
    All_RMSEP=[];
    All_optLV =[];
    All_R2 =[];
    for i = 1:449     %与下面的7联系，7个为一组，重复运行449次；7可以根据变量变，使得整除
    Xcal1=Xcal(:,UVE.SortedVariable(1,1:i*7));%变量从好到坏在UVE.SortedVariable排序
    ycal=Ycal;
    Xtest1=Xtest(:,UVE.SortedVariable(1,1:i*7));
    ytest=Ytest;
    CV=plscv(Xcal1,ycal,15,10);    %by default, 'center' is used for data pretreatment inside plscv.m.
    All_optLV(1,i) = CV.optLV;
    PLS=pls(Xcal1,ycal,CV.optLV,'center');  
    All_R2(1,i) = PLS.R2;    %上面已经进行多组pls运算，每7个为一组，每组的结果在All_R2展示，找到最大的R2所对应的列号，就是选择那么多组，比如第八列R2为0.998最大，则在UVE.SortedVariable中选择前56个（数字*组数）变量；筛选出变量后可自己重新运算pls
    [ypred,All_RMSEP(1,i)]=plsval(PLS,Xtest1,ytest); 
    end
    plot(1:449,All_RMSEP)   %数值与for同步，画出每组中RMSEP的变化

    %运行完后 看 All_R2，选最大数，再找到最大的R所对应的数字，数字*组数，比如8=0.998，则在UVE.SortedVariable中选择前56个变量；
    [m n]=max(All_R2);

    %用以下语句提取变量  把变量对应的波长选取出来，筛选出变量后可自己重新运算pls
    submatrix = zeros(110,56); %目标矩阵大小
    for i = 1:56 %108指要选的变量数
        submatrix(:,i) = X(:,UVE.SortedVariable(1,i));
    end
    xaxis1=xaxis(UVE.SortedVariable(1:28));
    ——————————————————————————————————————————————————————
    ——随机蛙跳算法RF（randomfrog algorithm   D:\刘丽华1\硕\404\code\matlab code\算法（SH）\数据处理相关算法\变量筛选算法\RF随机蛙跳算法）
    %RF-PLS是一种借鉴可逆跳跃马尔可夫链蒙特卡罗框架的数学简单、计算效率高的波数选择算法；每个波数的选择可能性是通过模拟马尔可夫链来计算的，该链遵循模型空间中的稳态分布
    %Random frog also belongs to the category of model population analysis (MPA) approaches
    %+++A：The maximal number of latent variables for cross-validation
    %+++N: here N is set to be small only for demo. Usually it is set to be 10000 or larger.
    %+++Q: the number of variables in the initial model for jumping

    Xcal=Xc;Xtest=Xt;Ycal=Yc;Ytest=Yt;
    A=10;
    method='center';
    N=10000;   
    Q=2;   
    Frog=randomfrog_pls(Xcal,Ycal,A,method,N,Q);
    plot(xaxis,Frog.probability);        %Frog.probability是所有变量被选择的概率
    xlabel('Wavelength (nm)');
    ylabel('Selection probability');
    set(gcf,'color','w');

    All_RMSEP=[];
    All_optLV =[];
    All_R2 =[];
    for i = 1:449      %与下面的7联系，对整体的变量进行分组，能够整除即可
    Xcal1=Xcal(:,Frog.Vrank(1,1:i*7));   %变量从好到坏在UVE.SortedVariable排序
    ycal=Ycal;
    Xtest1=Xtest(:,Frog.Vrank(1,1:i*7));
    ytest=Ytest;
    CV=plscv(Xcal1,ycal,15,10);  %by default, 'center' is used for data pretreatment inside plscv.m.
    All_optLV(1,i) = CV.optLV;
    PLS=pls(Xcal1,ycal,CV.optLV,'center');  
    All_R2(1,i) = PLS.R2; 
    [ypred,All_RMSEP(1,i)]=plsval(PLS,Xtest1,ytest); 
    end
    plot(1:449,All_RMSEP)    %数值与for同步，画出每组中RMSEP的变化

    %用以下语句提取特征变量  把变量对应的波长选取出来
    [m n]=max(All_R2);
    submatrix = zeros(110,1323);   %110*28 目标矩阵大小
    for i = 1:1323  %28指要选的变量数
        submatrix(:,i) = X(:,Frog.Vrank(1,i));
    end
    xaxis1=xaxis(Frog.Vrank(1:21));
    %重新分组预测，运行PLS
    X=submatrix；

    %%%如果直接运行 randomfrog_pls.m 文件，可以用以下语句将概率大于一定值的变量取出来%%%
    nu_of_var=3143      %全部变量个数
    selectprobablity=0.75     %变量被选择概率
    waveselect=zeros(2,nu_of_var);
    for i=1:nu_of_var
        if F.probability(1,i)>selectprobablity
            waveselect(1,i)=i;
            waveselect(2,i)=F.probability(1,i);
        end
    end
    waveselect = nonzeros(waveselect)
    ————————————————————————————————————————————————
    ——BOSS
    《D:\刘丽华1\硕\404\code\matlab code\matlab code\code-boss\bianliang.txt》
    [r,c]=find(BOSS.variable_index==1);

    江辉
    L=[];
    M=[];
    N=[];
    for i=1:14
    L=find(BOSS.W(:,i)~=0);
    M=length(L);
    N=[N M ];
    end


    《D:\刘丽华1\硕\404\code\matlab code\matlab code\code-boss\example.m》
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

    ————————————————————————————————————————————————
    %%%%%%%%%%%%建模%%%%%%%%%%%%%%
    定量：PLS、Si-PLS、CARS-PLS、ACO-PLS、GA-PLS
    定性：随机森林RF、主成分分析PCA、Fisher线性判别LDA、K最邻近判别法KNN、BP神经网络、支持向量机SVM、极限学习机ELM
    ——PLS
    %[Xc,Xt,Yc,Yt]=spxy(X,Y,66); 
    %num_total=110;
    [z1 z2]=sort(Y);           %对Y进行排序，z1为排序结果，z2反映做了什么改变
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

    Model=ipls(Xc,Yc,10,'mean',1,[],'syst123',5);
    iplsplot(Model,'intlabel');
    plsrmse(Model,0);

    num_total =8;     %更改主成分数
    plspvsm(Model,num_total,1);
    oneModel=plsmodel(Model,1,num_total,'mean','test',5);  
    predModel=plspredict(Xc,oneModel,num_total,Yc);
    plspvsm(predModel,num_total,1,1);
    predModel=plspredict(Xt,oneModel,num_total,Yt);
    plspvsm(predModel,num_total,1,1);

    ————————————————————————————————————————————————
    ——PCA （PCA.m文件）
    [coeff1,score,latent1]=princomp(X);%原数据作主成分，SCORE为提取主成分后的变量，LATENT为每个主成分的贡献率 定性均需要此步骤% A为样本*变量时不用转置
    scatter3(score(1:15,1),score(1:15,2),score(1:15,3),'ro')%按照1234分类进行画图 3D
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

    ————————————————————————————————————————————————
    ——LDA (直接运行LDA.m文件) （Y是分组的标签）
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
    for i=1:10   %前面有PC 因而此15指15个主成分，可自定但一般都是分15个
    xx1=PC1(:,1:i);
    xx2=PC2(:,1:i);
    class1 = classify(xx1,xx1,Yc);
    T=class1-Yc;
    L=find(T==0);
    r1(i)=length(L)/length(Yc);%训练集
    class2 = classify(xx2,xx1,Yc);                                                                                                   
    T2=class2-Yt;
    L2=find(T2==0);
    R(i)=length(L2)/length(Yt);%预测集
    end
    R
    r1
    KK=[r1;R];
    bar(KK')

    ———————————————————————————————————————————————
    ——KNN （蒋浩师兄knn.m,直接运行m文件）（Y是分组的标签）（横坐标不是12345，而是3 5 7 9 11）
    % 第一步，提取主成分，对数据进行降维
    %X = mapminmax(X,0,1); %对数据进行归一化，X是样本*变量数
    [coeff, score, latent] = princomp(X);

    %第二步，训练数据
    x1=score(1:5:104,1:12);
    x2=score(2:5:104,1:12);
    x3=score(3:5:104,1:12);
    x4=score(4:5:104,1:12);
    x5=score(5:5:104,1:12);
    %x6=score(6:6:216,1:10);
    Xcal=[x1;x3;x5];
    Xtest=[x2;x4];%(先分训练和预测）y也是
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

    %knn算法实现
    for i=1:12;  %i is the row of （E/F），On behalf of the principal component
    xtr=Xcal(:,1:i);%训练集，选取前12个主成分
    xte=Xtest(:,1:i);%测试集，选取前12个主成分
    [gamm,alpha] = knndsinit(xtr,ytrain);
        for k=2:12;  %j is the column of（E/F），On behalf of K value 
            if mod(k,2) ~= 0 %k值只能是奇数
                [m1,L1] = knndsval(xtr,ytrain,k,gamm,alpha,1);
                p1=ytrain-L1;
                I1=find(p1~=0);
                r1=length(I1);%训练集，错判的结果
                r2=length(ytrain);
                E(i,(k-1)/2)=1-r1/r2;%训练集正确分类率
                [m2,L2] = knndsval(xtr,ytrain,k,gamm,alpha,0,xte);
                p2=ytest-L2;
                I2=find(p2~=0);
                q1=length(I2);%测试集，错判的结果
                q2=length(ytest);
                F(i,(k-1)/2)=1-q1/q2;%测试集正确分类率
            end
        end
    end
    %mesh (E);
    mesh(F);

    ————————————————————————————————————————————————
    ——RF （D:\刘丽华1\硕\404\code\算法（CW)\算法（CW)\随机森林\RandomForest_matlab）（直接按节运行RF.m文件）（Y是分组的标签）
    X1=dx2(1:5:104,:);   %训练与预测以3:2分(中间为5，若1:1分则中间为2），共50个样本，每5个分为一个                  小部分 每个小部分中 1、3、5 为训练；2、4为预测
    X2=dx2(2:5:104,:);
    X3=dx2(3:5:104,:);
    X4=dx2(4:5:104,:);
    X5=dx2(5:5:104,:);

    Y1=Y(1:5:104,:);   %训练与预测以3:2分(中间为5，若1:1分则中间为2），共50个样本，每5个分为一个                  小部分 每个小部分中 1、3、5 为训练；2、4为预测
    Y2=Y(2:5:104,:);
    Y3=Y(3:5:104,:);
    Y4=Y(4:5:104,:);
    Y5=Y(5:5:104,:);

    Xtr=[X1;X3;X5];
    Xte=[X2;X4];
    Ytr=[Y1;Y3;Y5];
    Yte=[Y2;Y4];

    % 训练数据
    P_train = Xtr;
    T_train = Ytr;
    % 测试数据
    P_test = Xte;
    T_test = Yte;

    %% 随机森林中决策树棵数对性能的影响
    Accuracy = zeros(1,10);
    for i = 50:50:150
        i
        %每种情况，运行100次，取平均值
        accuracy = zeros(1,100);
        for k = 1:100
            % 创建随机森林
            model = classRF_train(P_train,T_train,i);
            % 仿真测试
            T_sim = classRF_predict(P_test,model);
            accuracy(k) = length(find(T_sim == T_test)) / length(T_test);
        end
        Accuracy(i/50) = mean(accuracy);
    end

    % 绘图
    % figure
    % plot(50:50:150,Accuracy)
    % xlabel('随机森林中决策树棵数')
    % ylabel('分类正确率')
    % title('随机森林中决策树棵数对性能的影响')

    ————————————————————————————————————————————————
    %%画图语句，将校正集和预测集放在一张图里
    plot(Yc,Yc2,'o')         %model , Yc2表示校正集的预测值
    hold on
    plot(Yt,Yt2,'*')          %premodel ， Yt2表示预测集的预测值
    hold on
    x=25:5:45;
    y=x;
    plot(x,y);
    hold on;
    xlabel('Measured value (%)');        %单位要根据实际做出更改
    ylabel('Predicted value (%)');
    legend('R_c=0.8908 RMSEC=1.320','R_p=0.8026 RMSEP=1.460');


    SD=Yt/Yt2     （预测集和预测集的预测值）
    RPD=SD/RMSEP

    ——————————————————————————————————————————————————
    %%导出model模型    D:\刘丽华1\硕\404\code\matlab code\定量预测模型导出相关算法-SH.txt
    %>>>>>>>>>>>>>>>>>>PLS模型导出
    %[model, error] = trainPLS(x, y, n, m, sampleNum);  %用于训练模型，输出为数组类型系数表
    % n 是自变量的个数,m 是因变量的个数（得出一个值即为1）
    % x 是自变量矩阵， y 是因变量矩阵

    %>>>>>>>>>>>>>>>>>>si-PLS模型系数导出
    x=[X(:,136:162)  X(:,163:189) X(:,217:243) X(:,271:296)];%筛选出的自变量组成的矩阵
    %x=X(:,ss);  
    y=Y;
    [model, error] = trainPLS(x, y,107, 1, 78)
    index=[(136:162)  (163:189) (217:243) (271:296)]';

    %>>>>>>>>>>>>>>>>导出预测集模型和系数(GA-PLS)
    x=X(:,GA1);
    y=Y;
    [model, error] = trainPLS(x,y,46,1,78);
    index=GA1';

    %>>>>>>>>>>>>>>>>导出预测集模型和系数(CARS)
    x=X（:,[ 1	4	9	12	14	18	27	38	61	65	67	108	119	122	123	132	141	143	151	153	165	181	187	192	193	223	224	230	343	347	349	351	369	372	379	380	383	394	397	398]); 
    y=Y;
    [model, error] = trainPLS(x, y,40, 1, 78)
    index=[1	4	9	12	14	18	27	38	61	65	67	108	119	122	123	132	141	143	151	153	165	181	187	192	193	223	224	230	343	347	349	351	369	372	379	380	383	394	397	398 ]';

    %>>>>>>>>>>>>>>>>导出预测集模型和系数(ACO)
    %x=X(:,[270	28	31	103	204	235	237	311	63	208	252	50	69	182	223	231	273	351	399]);
    x=X;
    y=Y;
    [model, error] = trainPLS(x, y,19, 1, 78)
    %index=[15	19	20	34	90	96	100	115	235	244	265	330	363	373	376	382	386	387	388	392	394	398]';


