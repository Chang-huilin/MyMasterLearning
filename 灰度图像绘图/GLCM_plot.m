% ָ��ͼ���ļ�·��
filePath = 'D:\��Ҷ�������\��Ҷ�����ͼ��\�ȷ�ڶ���140����+ˮ��\1��Ҷ_processed\1\25�����ζ�Ӧ��ͼ��\interestingspace\1.bmp';

% ��ȡͼ��
img = imread(filePath);

% ��ͼ��ת��Ϊ�Ҷ�ͼ�����ͼ���ǻҶ�ͼ��
if size(img, 3) > 1
    img_gray = rgb2gray(img);
else
    img_gray = img;
end

% ��ʾ�Ҷ�ͼ��
figure;
imshow(img_gray);
title('�Ҷ�ͼ��');

% ����Ҷȹ�������GLCM��
offsets = [0 1; -1 1; -1 0; -1 -1];  % ����GLCM��ƫ����
glcm = graycomatrix(img_gray, 'Offset', offsets, 'NumLevels', 256, 'Symmetric', true);

% ����GLCM��ͳ������
stats = graycoprops(glcm, {'Contrast', 'Correlation', 'Energy', 'Homogeneity'});

% ��ʾGLCMͳ������
disp('GLCMͳ��������');
disp(['Contrast: ', num2str(stats.Contrast)]);
disp(['Correlation: ', num2str(stats.Correlation)]);
disp(['Energy: ', num2str(stats.Energy)]);
disp(['Homogeneity: ', num2str(stats.Homogeneity)]);

% ���ӻ�GLCM��ʹ��α��ɫ��
figure;
for i = 1:size(offsets, 1)
    subplot(2, 2, i);
    imagesc(glcm(:, :, i));
    colormap(gca, jet);  % ʹ��jet colormap
    colorbar;
    title(['GLCM (', num2str(offsets(i, :)), ')']);
end

% ��ʾ�������
disp('GLCM����Ͳ�ɫ���ӻ���ɡ�');
