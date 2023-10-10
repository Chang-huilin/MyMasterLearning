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