function [v,unv] = statmoments(p,n)
%STATMOMENTS 计算图像直方图的统计中心矩
%   [v,unv] = statmoments(p,n)计算直方图的第N个统计中心矩，其分量在向量P中。
%   P的长度必须等于256或者65536.程序输出一个向量v，其中v(1)为均值，v(2)为方差
%   v(3)即以后v(n)为对应阶的中心矩。随机变量值被归一化到[0,1]范围内，所以
%   所有矩也是在这个范围内。该程序还输出一个向量unv，其中包含和v相同的矩，
%   但使用未归一化的随机变量值（例如，如果length(P)=2^8，范围为[0 255]），例如
%   如果length(P)=256、v(1)=0.5，那么unv(1)=127.5，范围[0,255]的一半

Lp = length(p);
if (Lp ~= 256) & (Lp ~= 65536)
    error('P必须是256或65536长度的向量')
end
G = Lp - 1;
% 确保直方图有单位面积，并将其转换为列向量
p = p/sum(p); p = p(:);
% 形成一个包含所有可能的随机值向量
z = 0:G;
% 将z标准化到范围[0,1]
z = z./G;
% 得到平均数
m = z * p;
% 以均值为中心的随机变量
z = z - m;
% 计算中心矩
v = zeros(1,n);
v(1) = m;
for j=2:n
    v(j) = (z.^j)*p;
end
if nargout > 1
    % 计算非中心矩
    unv = zeros(1,n);
    unv(1) = m.*G;
    for j=2:n
        unv(j) = ((z*G).^j)*p;
    end
end
end

