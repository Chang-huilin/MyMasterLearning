% 指定文件夹路径
folder = 'D:\红茶数据\萎凋\自然萎凋（21-120）\自然萎调15小时';

% 构建匹配 BMP 文件的文件路径
filePattern = fullfile(folder, '*.bmp');

% 获取文件夹中的所有 BMP 文件信息
imageFiles = dir(filePattern);

% 按照文件修改时间排序文件
[~, idx] = sort([imageFiles.datenum]); % 按照修改时间排序
sortedImageFiles = imageFiles(idx); % 按排序后的顺序重新排列文件列表

% 循环重命名文件
for k = 1:length(sortedImageFiles)
    oldFileName = fullfile(folder, sortedImageFiles(k).name);
    newFileName = fullfile(folder, sprintf('%02d.bmp', k));
    movefile(oldFileName, newFileName);
end