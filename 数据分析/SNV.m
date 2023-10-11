

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
plot(1:3648,xsnv)  