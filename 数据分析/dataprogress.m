            

%% һ���������׵���  �� \ D:\������1\˶\404\code\�㷨��CW)\�㷨��CW)\Ԥ����\  Ŀ¼������
[dx1]=DERIV(X,1);      %X������*����
[dx2]=DERIV(X,2);
[dx3]=DERIV(X,3);
plot(1:3648,dx1);     % ������ͼ

%%center��ֵ���Ļ���%X������*����
[cdata,me,ctest]=center(X',1,X');   %#ok<*ASGLU> %�������*������ ��Ҫת��
plot(1:3648,cdata);  %������ͼ

%MSC��%X������*����
[xmsc,me,xtmsc]=MSC(x,first,last,xt);  %����Ҫ����
[xmsc,me]=MSC(X,1,3648);  %1Ϊ��һ������ 3648Ϊ���һ������
plot(1:3648,xmsc);  %������ͼ
