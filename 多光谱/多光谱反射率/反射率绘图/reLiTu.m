% 数据准备
% 假设 wavelength 是包含波长数据的 1x25 向量
% 假设 X 是包含反射率数据的 145x25 矩阵

% 显示反射率热图
figure;
imagesc(wavelength, 1:size(X, 1), X);
title('Reflectance Heatmap');
xlabel('Wavelength (nm)');
ylabel('Sample Index');

% 添加颜色条
colorbar;
colormap(jet);  % 使用jet colormap，也可以根据需要选择其他的colormap

% 设置图表样式
ax = gca;
ax.FontSize = 12;
ax.FontWeight = 'bold';
ax.XColor = 'k';
ax.YColor = 'k';
ax.FontName = 'Times New Roman';  % 设置字体为新罗马

% 调整坐标轴显示
ax.YDir = 'normal';  % 设置 y 轴方向为正常方向

% 添加标题和标签
title('Reflectance Heatmap');
xlabel('Wavelength (nm)');
ylabel('Sample Index');

% 显示完成信息
disp('Reflectance heatmap generated.');
