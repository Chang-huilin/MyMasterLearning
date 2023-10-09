%数据分析算法
function snvSpectra = SNV(input_data)
    % 计算每个样本的均值和标准差
    meanSpectra = mean(input_data, 2);
    stdSpectra = std(input_data, 0, 2);

    % 计算SNV预处理后的光谱数据
    snvSpectra = zeros(size(input_data));
    for i = 1:size(input_data, 1)
        snvSpectra(i, :) = (input_data(i, :) - meanSpectra(i)) ./ stdSpectra(i);
    end
end