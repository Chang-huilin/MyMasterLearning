% 保留偶数行的索引
evenRows = 2:2:size(mergedData, 1);

% 从 mergedData 中提取偶数行
evenRowsMatrix = mergedData(evenRows, :);%这里我们选择保留偶数行反射率的值，奇数行是25个固定的光谱


%或者

% 保留奇数行的索引
oddRows = 1:2:size(mergedData, 1);

% 从 mergedData 中提取奇数行
resultMatrix = mergedData(oddRows, :);


% 假设 resultMatrix 是一个包含奇数行的矩阵，其维度为 m x n

% 去掉前四列
resultMatrixWithoutFirstFourColumns = resultMatrix(:, 5:end);
   
X = resultMatrixWithoutFirstFourColumns;

%新建wavelength数据，表格第一行25个光谱值，复制黏贴即可，命名为WAVE
%或者
WAVE = WAVE(:, 5:end);%截取掉前4列，从第5列开始保留

%作图

plot(WAVE,X)

