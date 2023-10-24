% 假设 X 是训练数据的特征矩阵，Y 是对应的标签
% Xtest 是待预测数据的特征矩阵

% 构建 k-NN 分类器，假设 k=3
k = 12;%样本量开根号
knnModel = fitcknn(X, Y, 'NumNeighbors', k);

% 使用分类器进行预测
predictedLabels = predict(knnModel, Xtest);

% 显示预测结果
disp(predictedLabels);
