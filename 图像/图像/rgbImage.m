% ���òü���ͼ��洢�ļ���·��
croppedFolder = 'D:\�������\test\�ü���';

% ��ȡ�ü���ͼ���ļ���������ͼ���ļ����б�
fileList = dir(fullfile(croppedFolder, '*.bmp'));

% ȷ���ļ��б�Ϊ��
if isempty(fileList)
    error('�ü���ͼ���ļ�����û���ҵ��κ� BMP ͼ���ļ���');
end

% ��ȡ��һ��ͼ��
firstImage = imread(fullfile(croppedFolder, fileList(1).name));

% ��ʾ��һ��ͼ�������ͨ��
figure;
subplot(1, 3, 1);
imshow(firstImage(:, :, 1));  % ��ʾ��ɫͨ��
title('��ɫͨ��');

subplot(1, 3, 2);
imshow(firstImage(:, :, 2));  % ��ʾ��ɫͨ��
title('��ɫͨ��');

subplot(1, 3, 3);
imshow(firstImage(:, :, 3));  % ��ʾ��ɫͨ��
title('��ɫͨ��');
