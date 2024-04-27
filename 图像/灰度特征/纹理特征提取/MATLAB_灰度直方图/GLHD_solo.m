WL9=zeros(25,16);
for i=1:25 %i为样本图像的张数
    filename = strcat('D:\茶叶干燥过程\茶叶多光谱图像\热风第二批140个样+水分\1鲜叶_processed\1\25个波段对应的图像\interestingspace\',num2str(i),'.bmp');
    A = imread(filename);
    A=im2gray(A);
    p=imhist(A);                  %获取直方图,得到p是256*1的列向量
    p=p./numel(A);                %numel(f)给出数组中f中的元素个数（即图像中的像素数），这步就可以简单地获得归一化直方图
    L=length(p);
    [v,mu]=moments(p,3);
    t(1)=mu(1);                   %平均值
    t(2)=mu(2).^0.5;              %标准差
    varn=mu(2)/(L-1)^2;
    t(3)=1-1/(1+varn);            %平滑度首先为（0~1）区间通过除以（L-1）^2将变量标准化
    t(4)=mu(3)/(L-1)^2;           %三阶矩就是mu(3)，这步就是通过除以（L-1）^2将变量实现标准化到[0 1]
    t(5)=sum(p.^2);               %一致性
    t(6)=-sum(p.*(log2(p+eps)));  %熵
    T=[t(1) t(2) t(3) t(4) t(5) t(6)];
    WL9(i,:)=T;
end
xlswrite('D:\茶叶干燥过程\茶叶多光谱图像\热风第二批140个样+水分\1鲜叶_processed\1\25个波段对应的图像\interestingspace\',WL9);