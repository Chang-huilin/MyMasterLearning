function centeredData = centerMean(data)
    % data是输入的数据，可以是样本*特征的矩阵或列向量

    % 计算数据的均值
    meanValue = mean(data);

    % 将数据中的每个元素减去均值，实现均值中心化
    centeredData = data - meanValue;
end
