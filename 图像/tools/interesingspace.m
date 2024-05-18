%感兴趣区域提取

for i = 1:20 
    filename = strcat('C:\Users\79365\Desktop\多光谱数据\图像\1\',num2str(i),'.bmp');
    A=imread(filename);
    imshow(A)
    B=imcrop(A,[440,250,750,750]);
    imshow(B);
    imwrite(B,strcat('C:\Users\79365\Desktop\多光谱数据\图像\1\',num2str(i),'.bmp'));
end