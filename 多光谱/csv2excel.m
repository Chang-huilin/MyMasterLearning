%% 这是一个将csv文件批量转化为excel文件并存入一个数组矩阵，最后提取数组矩阵内的值到一个大矩阵内

% 指定文件夹路径
folderPath = 'C:\Users\79365\OneDrive\桌面\多光谱数据\热风1\1';

% 获取文件夹内所有CSV文件的信息
fileList = dir(fullfile(folderPath, '*.csv'));

% 初始化一个空的矩阵数组
dataMatrices = [];

% 循环读取每个CSV文件并保存到矩阵数组中
for i = 1:length(fileList)
    % 构建完整的文件路径
    filePath = fullfile(folderPath, fileList(i).name);
    
    % 使用readmatrix函数读取CSV文件
    data = readmatrix(filePath);
    
    % 将读取的数据添加到矩阵数组中
    dataMatrices{i} = data;
end

% 现在dataMatrices是一个包含所有CSV文件数据的矩阵数组
% 可以通过dataMatrices{1}, dataMatrices{2}, ... 访问各个矩阵

 % 使用cat函数进行水平拼接
mergedData = cat(1, dataMatrices{:});
 