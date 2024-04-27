% 文件夹路径
folderPath = 'C:\Users\79365\Desktop\红外处理3h';

% 初始化矩阵 X
X = [];

% 循环读取每个 CSV 文件并插入到矩阵 X 中
for i = 1:120
    % 构建当前文件的完整路径
    fileName = sprintf('%d.csv', i); % 根据循环变量 i 构建文件名
    filePath = fullfile(folderPath, fileName); % 构建完整文件路径
    
    % 检查文件是否存在
    if exist(filePath, 'file')
        % 读取 CSV 文件数据，从第二行第五列开始读取数据
        data = readmatrix(filePath, 'Range', 'E2'); % 从第二行第五列开始读取数据
        
        % 将数据按行插入到矩阵 X 中
        X = [X; data]; %#ok
    else
        fprintf('文件 %s 不存在.\n', fileName);
    end
end

% 显示读取数据后的矩阵 X 的大小
fprintf('矩阵 X 的大小: %d 行 x %d 列\n', size(X, 1), size(X, 2));