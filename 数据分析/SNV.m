

function snvData = snv(X)
    % X������*�����ľ���
    
    % ���м����ֵ�ͱ�׼��
    meanValues = mean(X);
    stdValues = std(X, 0, 1);
    
    % SNVԤ����
    snvData = zeros(size(X));
    for i = 1:size(X, 2)
        snvData(:, i) = (X(:, i) - meanValues(i)) / stdValues(i);
    end
end

xsnv=snv(X);
plot(1:3648,xsnv)  