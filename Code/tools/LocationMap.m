function [AuxLM I] = LocationMap(I)
% 2018/9/20 lwj LocationMap��Ϊ�˼�¼��0��255��λ�ã����Ұ�0��255�ĳ�1��254
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
data = arith07(xC);    %��mapͼ����ѹ������������

if 8*length(data) == 40
    AuxLM = 1;
else
    AuxLM = 1 + 8*length(data);
end