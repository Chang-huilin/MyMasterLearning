% ָ��ͼ���ļ�·��
filePath = 'D:\��Ҷ�������\��Ҷ�����ͼ��\�ȷ�ڶ���140����+ˮ��\1��Ҷ_processed\1\25�����ζ�Ӧ��ͼ��\interestingspace\1.bmp';

% ��ȡͼ��
img = imread(filePath);

% ��ʾͼ��
figure;
imshow(img);
title('ԭʼͼ��');

% ����Ҷ�ֱ��ͼ
[counts, binLocations] = imhist(img);

% ���ƻҶ�ֱ��ͼ
figure;
stem(binLocations, counts, 'Marker', 'none');
title('�Ҷ�ֱ��ͼ');
xlabel('�Ҷȼ���');
ylabel('��������');

% ����Ҷ�ֱ��ͼͼƬ
saveas(gcf, '�Ҷ�ֱ��ͼ.png');

% ��ʾ�������
disp('�Ҷ�ֱ��ͼ������ɣ����ѱ���ΪͼƬ��');
