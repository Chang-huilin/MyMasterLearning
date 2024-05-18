function processAndDisplayMultispectralImage(hdrFilePath, selectedBands)
    % 读取多光谱图像
    hdrInfo = envihdrread(hdrFilePath);
    img = multibandread(hdrFilePath, [hdrInfo.lines hdrInfo.samples hdrInfo.bands], ...
                        hdrInfo.interleave, 0, hdrInfo.datatype, hdrInfo.byteorder);
    
    % 初始化二值化处理后的图像
    binaryImage = false(size(img, 1), size(img, 2), length(selectedBands));

    % 对特征波段进行二值化处理
    for i = 1:length(selectedBands)
        bandIndex = selectedBands(i);
        bandImage = img(:, :, bandIndex);
        threshold = graythresh(bandImage);
        binaryImage(:, :, i) = imbinarize(bandImage, threshold);
    end

    % 对其他波段进行处理，将背景像素的光谱设为零
    for i = 1:hdrInfo.bands
        if ~ismember(i, selectedBands)
            for j = 1:size(img, 1)
                for k = 1:size(img, 2)
                    if all(binaryImage(j, k, :))
                        img(j, k, i) = 0;
                    end
                end
            end
        end
    end

    % 将三维光谱数据转换为二维光谱数据
    [rows, cols, bands] = size(img);
    img2D = reshape(img, rows * cols, bands);

    % 显示处理结果
    disp('特征波段的二值化图像已处理并显示:');
    figure;
    montage(binaryImage, 'Size', [1 length(selectedBands)]);
    title('Selected Feature Bands Binary Images');

    % 生成伪彩色图像
    % 假设选用第一个、第二个和第三个特征波段来创建伪彩色图像
    pseudoColorImage = img(:, :, selectedBands(1:3));
    pseudoColorImage = uint8(255 * mat2gray(pseudoColorImage)); % 归一化并转换为uint8类型

    % 显示伪彩色图像
    figure;
    imshow(pseudoColorImage);
    title('Pseudo-color Image Using Selected Feature Bands');

    % 保存二维光谱数据
    save('processed_spectral_data.mat', 'img2D');

    % 输出二维光谱数据大小
    disp('二维光谱数据大小:');
    disp(size(img2D));
end
