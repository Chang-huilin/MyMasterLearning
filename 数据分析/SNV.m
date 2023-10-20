

function snvData = snv(X)
    % X是样本*变量的矩阵
    
    % 按列计算均值和标准差
    meanValues = mean(X);
    stdValues = std(X, 0, 1);
    
    % SNV预处理
    snvData = zeros(size(X));
    for i = 1:size(X, 2)
        snvData(:, i) = (X(:, i) - meanValues(i)) / stdValues(i);
    end
end

xsnv=snv(X);
plot(1:140,xsnv)


num_total =140;   %主成分数
plspvsm(Model,num_total,1);
oneModel=plsmodel(Model,1,num_total,'mean','test',5);  
predModel=plspredict(Xc,oneModel,num_total,Yc);
plspvsm(predModel,num_total,1,1);    %把RMSEP改成RMSEC
predModel=plspredict(Xt,oneModel,num_total,Yt);
plspvsm(predModel,num_total1,1);      %预测集的结果  
