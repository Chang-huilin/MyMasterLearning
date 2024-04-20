% 数据准备
% 假设 wavelength 是包含波长数据的 1x25 向量
% 假设 X 是包含反射率数据的 145x25 矩阵

% 显示反射率图
figure;
plot(wavelength, X);
title('Reflectance Plot');
xlabel('Wavelength (nm)');
ylabel('Reflectance');

% 设置图表样式
ax = gca;
ax.FontSize = 12;
ax.FontWeight = 'bold';
ax.XColor = 'k';
ax.YColor = 'k';
ax.FontName = 'Times New Roman';  % 设置字体为新罗马

% 网格线
grid off;

% 显示完成信息
disp('Reflectance plot generated.');
