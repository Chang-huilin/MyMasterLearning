% ����׼��
% ���� wavelength �ǰ����������ݵ� 1x25 ����
% ���� X �ǰ������������ݵ� 145x25 ����

% ��ʾ������ͼ
figure;
plot(wavelength, X);
title('Reflectance Plot');
xlabel('Wavelength (nm)');
ylabel('Reflectance');

% ����ͼ����ʽ
ax = gca;
ax.FontSize = 12;
ax.FontWeight = 'bold';
ax.XColor = 'k';
ax.YColor = 'k';
ax.FontName = 'Times New Roman';  % ��������Ϊ������

% ������
grid off;

% ��ʾ�����Ϣ
disp('Reflectance plot generated.');
