% 设置裁剪后图像存储文件夹路径
croppedFolder = 'D:\红茶数据\test\裁剪后';

% 获取裁剪后图像文件夹中所有图像文件的列表
fileList = dir(fullfile(croppedFolder, '*.bmp'));

% 存储每张图像的平均 RGB 值
averageRGBValues = zeros(numel(fileList), 3);

% 遍历每张图像文件
for i = 1:numel(fileList)
    % 读取图像
    img = imread(fullfile(croppedFolder, fileList(i).name));
    
    % 获取图像尺寸
    [height, width, ~] = size(img);
    
    % 初始化 RGB 值的累加器
    totalR = 0;
    totalG = 0;
    totalB = 0;
    
    % 遍历图像的每个像素
    for y = 1:height
        for x = 1:width
            totalR = totalR + double(img(y, x, 1));
            totalG = totalG + double(img(y, x, 2));
            totalB = totalB + double(img(y, x, 3));
        end
    end
    
    % 计算平均 RGB 值
    numPixels = height * width;
    avgR = totalR / numPixels;
    avgG = totalG / numPixels;
    avgB = totalB / numPixels;
    
    % 将平均 RGB 值存储到数组中
    averageRGBValues(i, :) = [avgR, avgG, avgB];
end

% 保存平均 RGB 值到 CSV 文件
csvFileName = 'D:\红茶数据\test\平均RGB值.csv';
csvwrite(csvFileName, averageRGBValues);

disp(['平均 RGB 值已保存到文件：', csvFileName]);
