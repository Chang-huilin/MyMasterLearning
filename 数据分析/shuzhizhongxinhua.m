function centeredData = centerMean(data)
    % data����������ݣ�����������*�����ľ����������

    % �������ݵľ�ֵ
    meanValue = mean(data);

    % �������е�ÿ��Ԫ�ؼ�ȥ��ֵ��ʵ�־�ֵ���Ļ�
    centeredData = data - meanValue;
end
