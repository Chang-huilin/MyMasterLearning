% 指定图像文件路径
filePath = 'D:\茶叶干燥过程\茶叶多光谱图像\热风第二批140个样+水分\1鲜叶_processed\1\25个波段对应的图像\interestingspace\1.bmp';

% 读取图像
img = imread(filePath);

% 显示图像
figure;
imshow(img);
title('原始图像');

% 计算灰度直方图
[counts, binLocations] = imhist(img);

% 绘制灰度直方图
figure;
stem(binLocations, counts, 'Marker', 'none');
title('灰度直方图');
xlabel('灰度级别');
ylabel('像素数量');

% 保存灰度直方图图片
saveas(gcf, '灰度直方图.png');

% 提示操作完成
disp('灰度直方图绘制完成，并已保存为图片。');
