% 设置文件夹路径
folderPath = 'D:/茶叶干燥过程/茶叶多光谱图像/热风第二批140个样+水分/纹理4/';

% 初始化结果矩阵
resultMatrix = [];

% 循环读取所有Excel文件
for i = 1:140
    % 构建文件名
    fileName = sprintf('%03d.xlsx', i); % 使用%03d确保文件名以三位数字形式表示

    % 构建完整文件路径
    filePath = fullfile(folderPath, fileName);

    % 读取Excel文件数据
    data = xlsread(filePath);

    % 计算每列的平均值
    columnMeans = mean(data);

    % 将平均值添加到结果矩阵
    resultMatrix = [resultMatrix; columnMeans];
end

% 保存结果矩阵到单独的Excel文件
resultFileName = fullfile(folderPath, 'result.xlsx');
writematrix(resultMatrix, resultFileName);

A=readmatrix("D:\茶叶干燥过程\茶叶多光谱图像\热风第二批140个样+水分\纹理3\result.xlsx");
B=readmatrix("D:\茶叶干燥过程\茶叶多光谱图像\热风第二批140个样+水分\纹理4\result.xlsx");
X=[A;B];