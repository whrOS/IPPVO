function [AuxLM I] = LocationMap(I)
% 2018/9/20 lwj LocationMap是为了记录下0和255的位置，并且把0和255改成1和254
[A B] = size(I);

LM = zeros(A,B);
for i = 1:A
    for j = 1:B
        if I(i,j) == 0
            I(i,j) = 1;
            LM(i,j) = 1;
        end
        if I(i,j) == 255
            I(i,j) = 254;
            LM(i,j) = 1;
        end
    end
end
xC = cell(1,1);
xC{1} = LM;
data = arith07(xC);    %对map图进行压缩，算术编码

if 8*length(data) == 40
    AuxLM = 1;
else
    AuxLM = 1 + 8*length(data);
end