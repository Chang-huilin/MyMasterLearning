
%snv:首先，计算每个样本的均值和标准差，然后将光谱数据减去均值，再除以标准差。这样，经过SNV预处理的数据在均值和标准差上保持一致。
xsnv=snv(x);%x=resultMatrixWithoutFirstFourColumns
plot(1:140,xsnv) ;