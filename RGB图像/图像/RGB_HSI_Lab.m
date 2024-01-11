%��ȡҶ����������rgb��hsi��lab
X=zeros(120,18);
for i = 1:120
    filename = strcat('C:\Users\79365\OneDrive\����\���������\Ҷ����\1\',num2str(i),'.bmp');
 

    B=imread(filename);%��ȡһ�Ų�ɫͼ��
    r=B(:,:,1);
    g=B(:,:,2);
    b=B(:,:,3);%��ȡ��ɫͼ��3������
    X={r,g,b};
    B1=cat(3,r,g,b);%���ºϳɲ�ɫͼ��
    B1_lab=rgb2lab(B1);%ת����Lab��ɫ�ռ�
    Lab_l=B1_lab(:,:,1);
    Lab_a=B1_lab(:,:,2);
    Lab_b=B1_lab(:,:,3);
    r=im2double(r);%RGBתHSIʱ ��Ҫ��unit8��ת����[0,1]double����
    %im2double������ת��Ϊdouble�ࡣ
    %��������unit8,unit16��logical�࣬�����ת���ɷ�ΧΪ[0��1]��double�ࣻ
    %�������Ѿ���double�������������һ����������ͬ�����顣
    %mat2gray �ǰ�һ��double�������ת����ȡֵ��ΧΪ[0,1]�Ĺ�һ��double�����顣
    g=im2double(g);
    b=im2double(b);
    
    %��RGB�ռ�ת����HSI�ռ䣺
    num=0.5*((r-g)+(r-b));
    nun=sqrt((r-g).^2+(r-b).*(g-b));
    theta=acos(num./(nun+eps));
    H=theta;
    H(b>g)=2*pi-H(b>g);
    H=H/(2*pi);
    num=min(min(r,g),b);
    den=r+g+b;
    den(den==0)=eps;
    S=1-3.*num./(den);
    I=(r+g+b)/3;
    
    %�ϳ�HSIͼ��
    HSI=cat(3,H,S,I);
    
    %subplot(2,2,1),imshow(B);
    %subplot(2,2,2),imshow(B1);
    %subplot(2,2,3),imshow(HSI);%һ�Ż�����ͬʱ��ʾ3��ͼ
    
    %��R��G��B�����ľ�ֵ.1-3��
    mR=mean2(r);
    mG=mean2(g);
    mB=mean2(b);
    %��R��G��B�������4-6��
    sR=std2(r);
    sG=std2(g);
    sB=std2(b);
    %��H��S��I�����ľ�ֵ��7-9��
    mH=mean2(H);
    mI=mean2(I);
    mS=mean2(S);
    %��H��S��I�����ķ��10-12��
    sH=std2(H);
    sS=std2(S);
    sI=std2(I);
    %����Lab�ռ��µľ�ֵ�ͷ��13-18��
    mLab_l=mean2(Lab_l);
    mLab_a=mean2(Lab_a);
    mLab_b=mean2(Lab_b);
    sLab_l=std2(Lab_l);
    sLab_a=std2(Lab_a);
    sLab_b=std2(Lab_b);
    %     T1=[];%����һ���վ���
    T=[mR mG mB sR sG sB mH mS mI sH sS sI mLab_l mLab_a mLab_b sLab_l sLab_a sLab_b];%ͳ����������
    %     T1=[T1;T];%��������ÿ��������������Ϊһ��
    Iw(i,:)=T; %#ok<SAGROW>
end
xlswrite('C:\Users\79365\OneDrive\����\���������\Ҷ����\120.xls',Iw); %#ok<XLSWT> %�����ݱ��浽excel