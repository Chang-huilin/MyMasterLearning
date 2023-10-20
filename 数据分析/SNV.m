

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
plot(1:140,xsnv)


num_total =140;   %���ɷ���
plspvsm(Model,num_total,1);
oneModel=plsmodel(Model,1,num_total,'mean','test',5);  
predModel=plspredict(Xc,oneModel,num_total,Yc);
plspvsm(predModel,num_total,1,1);    %��RMSEP�ĳ�RMSEC
predModel=plspredict(Xt,oneModel,num_total,Yt);
plspvsm(predModel,num_total1,1);      %Ԥ�⼯�Ľ��  
