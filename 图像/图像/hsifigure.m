% ��ȡBMPͼ��
imagePath = 'C:\Users\79365\OneDrive\����\���������\ͼ��\1\1.bmp';
rgbImage = imread(imagePath);

% ��ȡͼ��ĳߴ�
[height, width, ~] = size(rgbImage);

% ��RGBͼ��ת��ΪHSIͼ��
hsiImage = zeros(height, width, 3);

for i = 1:height
    for j = 1:width
        hsiPixel = rgb_to_hsi(rgbImage(i, j, :));
        hsiImage(i, j, :) = hsiPixel;
    end
end

% ��ʾHSIͼ��
figure;
imshow(hsiImage);

% ����HSIͼ��ָ��Ŀ¼
savePath = 'C:\Users\79365\OneDrive\����\���������\HSI\hsi_image1.bmp';
imwrite(hsiImage, savePath);