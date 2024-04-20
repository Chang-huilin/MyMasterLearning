% 指定图像文件路径
filePath = 'D:\茶叶干燥过程\茶叶多光谱图像\热风第二批140个样+水分\1鲜叶_processed\1\25个波段对应的图像\interestingspace\1.bmp';

% 读取图像
img = imread(filePath);

% 将图像转换为灰度图像（如果图像不是灰度图）
if size(img, 3) > 1
    img_gray = rgb2gray(img);
else
    img_gray = img;
end

% 显示灰度图像
figure;
imshow(img_gray);
title('灰度图像');

% 计算灰度共生矩阵（GLCM）
offsets = [0 1; -1 1; -1 0; -1 -1];  % 定义GLCM的偏移量
glcm = graycomatrix(img_gray, 'Offset', offsets, 'NumLevels', 256, 'Symmetric', true);

% 计算GLCM的统计特征
stats = graycoprops(glcm, {'Contrast', 'Correlation', 'Energy', 'Homogeneity'});

% 显示GLCM统计特征
disp('GLCM统计特征：');
disp(['Contrast: ', num2str(stats.Contrast)]);
disp(['Correlation: ', num2str(stats.Correlation)]);
disp(['Energy: ', num2str(stats.Energy)]);
disp(['Homogeneity: ', num2str(stats.Homogeneity)]);

% 可视化GLCM（使用伪彩色）
figure;
for i = 1:size(offsets, 1)
    subplot(2, 2, i);
    imagesc(glcm(:, :, i));
    colormap(gca, jet);  % 使用jet colormap
    colorbar;
    title(['GLCM (', num2str(offsets(i, :)), ')']);
end

% 提示操作完成
disp('GLCM计算和彩色可视化完成。');
