% ����׼��
% ���� wavelength �ǰ����������ݵ� 1x25 ����
% ���� X �ǰ������������ݵ� 145x25 ����

% ��ʾ��������ͼ
figure;
imagesc(wavelength, 1:size(X, 1), X);
title('Reflectance Heatmap');
xlabel('Wavelength (nm)');
ylabel('Sample Index');

% �����ɫ��
colorbar;
colormap(jet);  % ʹ��jet colormap��Ҳ���Ը�����Ҫѡ��������colormap

% ����ͼ����ʽ
ax = gca;
ax.FontSize = 12;
ax.FontWeight = 'bold';
ax.XColor = 'k';
ax.YColor = 'k';
ax.FontName = 'Times New Roman';  % ��������Ϊ������

% ������������ʾ
ax.YDir = 'normal';  % ���� y �᷽��Ϊ��������

% ��ӱ���ͱ�ǩ
title('Reflectance Heatmap');
xlabel('Wavelength (nm)');
ylabel('Sample Index');

% ��ʾ�����Ϣ
disp('Reflectance heatmap generated.');
