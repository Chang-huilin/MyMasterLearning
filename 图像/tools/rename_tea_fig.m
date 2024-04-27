% ָ���ļ���·��
folder = 'D:\�������\ή��\��Ȼή��21-120��\��Ȼή��15Сʱ';

% ����ƥ�� BMP �ļ����ļ�·��
filePattern = fullfile(folder, '*.bmp');

% ��ȡ�ļ����е����� BMP �ļ���Ϣ
imageFiles = dir(filePattern);

% �����ļ��޸�ʱ�������ļ�
[~, idx] = sort([imageFiles.datenum]); % �����޸�ʱ������
sortedImageFiles = imageFiles(idx); % ��������˳�����������ļ��б�

% ѭ���������ļ�
for k = 1:length(sortedImageFiles)
    oldFileName = fullfile(folder, sortedImageFiles(k).name);
    newFileName = fullfile(folder, sprintf('%02d.bmp', k));
    movefile(oldFileName, newFileName);
end