% ��ȡBMPͼ��
imagePath = 'C:\Users\79365\OneDrive\����\���������\ͼ��\6\1.bmp';
original = imread(imagePath);
original_gray = rgb2gray(original); % ��ͼ��ת��Ϊ�Ҷ�ͼ��

% ��ͼ�������ֵ��Χӳ�䵽[0, 1]
original_gray = double(original_gray) / 255;

% ����Ҷ�ͼ��ֱ��ͼ
histogram = imhist(original_gray);

% ����ͼ�����������
totalPixels = numel(original_gray);

% ����ÿ���Ҷȼ���Ƶ��
frequency = histogram / totalPixels;

% ����ԭͼֱ��ͼ��Ƶ�ʱ�ʾ��
x = 0:255;
figure;
subplot(2, 2, 1);
bar(x, frequency);
title('Original Histogram (Frequency)');

% ֱ��ͼ���⻯���ֱ��ͼ��Ƶ�ʱ�ʾ��
result = histeq(original_gray);
histogram_equ = imhist(result);
frequency_equ = histogram_equ / totalPixels;

subplot(2, 2, 2);
bar(x, frequency_equ);
title('Equalized Histogram (Frequency)');

% ��ʾԭͼ�ʹ����ͼ��
subplot(2, 2, 3);
imshow(original_gray);
title('Original Image');
axis off;

subplot(2, 2, 4);
imshow(result);
title('Equalized Image');
axis off;
