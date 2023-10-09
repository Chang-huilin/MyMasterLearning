NIR=zeros(3648,20);
for i=1:20
t1=xlsread(strcat('C:\Users\79365\OneDrive\桌面\数据 - 副本\近红外300-1100\2023春茶试验4批\20230504春茶-热风杀青\1鲜叶\',num2str(i),'.xlsx'),'D1:D3648');
t2=xlsread(strcat('C:\Users\79365\OneDrive\桌面\数据 - 副本\近红外300-1100\2023春茶试验4批\20230504春茶-热风杀青\1鲜叶\',num2str(i),'.xlsx'),'F1:F3648');
t3=xlsread(strcat('C:\Users\79365\OneDrive\桌面\数据 - 副本\近红外300-1100\2023春茶试验4批\20230504春茶-热风杀青\1鲜叶\',num2str(i),'.xlsx'),'H1:H3648');
t4=[t1 t2 t3];
t=mean(t4,2);
NIR(:,i)=t;
end
