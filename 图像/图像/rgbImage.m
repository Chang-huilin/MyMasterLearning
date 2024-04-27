% 设置裁剪后图像存储文件夹路径
croppedFolder = 'D:\红茶数据\test\裁剪后';

% 获取裁剪后图像文件夹中所有图像文件的列表
fileList = dir(fullfile(croppedFolder, '*.bmp'));

% 确保文件列表不为空
if isempty(fileList)
    error('裁剪后图像文件夹中没有找到任何 BMP 图像文件。');
end

% 读取第一张图像
firstImage = imread(fullfile(croppedFolder, fileList(1).name));

% 显示第一张图像的三个通道
figure;
subplot(1, 3, 1);
imshow(firstImage(:, :, 1));  % 显示红色通道
title('红色通道');

subplot(1, 3, 2);
imshow(firstImage(:, :, 2));  % 显示绿色通道
title('绿色通道');

subplot(1, 3, 3);
imshow(firstImage(:, :, 3));  % 显示蓝色通道
title('蓝色通道');
