WL9=zeros(180,9);
for i=1:180 %iΪ����ͼ�������
    filename = strcat('E:\tea\interesting\6\',num2str(i),'.bmp');
    A = imread(filename);
    A=rgb2gray(A);
    p=imhist(A);                  %��ȡֱ��ͼ,�õ�p��256*1��������
    p=p./numel(A);                %numel(f)����������f�е�Ԫ�ظ�������ͼ���е������������ⲽ�Ϳ��Լ򵥵ػ�ù�һ��ֱ��ͼ
    L=length(p);
    [v,mu]=statmoments(p,3);
    t(1)=mu(1);                   %ƽ��ֵ
    t(2)=mu(2).^0.5;              %��׼��
    varn=mu(2)/(L-1)^2;
    t(3)=1-1/(1+varn);            %ƽ��������Ϊ��0~1������ͨ�����ԣ�L-1��^2��������׼��
    t(4)=mu(3)/(L-1)^2;           %���׾ؾ���mu(3)���ⲽ����ͨ�����ԣ�L-1��^2������ʵ�ֱ�׼����[0 1]
    t(5)=sum(p.^2);               %һ����
    t(6)=-sum(p.*(log2(p+eps)));  %��
    T=[t(1) t(2) t(3) t(4) t(5) t(6)];
    WL9(i,:)=T;
end
xlswrite('C:\Users\You\Desktop\26.xls',WL9); %#ok<XLSWT>