%���ݷ����㷨
function snvSpectra = SNV(input_data)
    % ����ÿ�������ľ�ֵ�ͱ�׼��
    meanSpectra = mean(input_data, 2);
    stdSpectra = std(input_data, 0, 2);

    % ����SNVԤ�����Ĺ�������
    snvSpectra = zeros(size(input_data));
    for i = 1:size(input_data, 1)
        snvSpectra(i, :) = (input_data(i, :) - meanSpectra(i)) ./ stdSpectra(i);
    end
end