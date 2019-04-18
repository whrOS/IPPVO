function [AuxLM,I] = LocationMap(I)

[A,B] = size(I);

LM = zeros(1,A*B);
index = 0;
for i = 2:A-1               
    for j = 2:B-1
        if I(i,j) == 0;
            index = index + 1;
            I(i,j) = 1;
            LM(index) = 1;
        end
        
        if I(i,j) == 255
            index = index + 1;
            I(i,j) = 254;
            LM(index) = 1;
        end
        
        if I(i,j) == 1
            index = index +1;
            LM(index) = 0;
        end
        
        if I(i,j) == 254
            index = index +1;
            LM(index) = 0;
        end
    end
end

if index == 0
    AuxLM = 1;
else
    LM = LM(1:index);
    xC = cell(1,1);
    xC{1} = LM;
    data = arith07(xC);    
    AuxLM = 1 + 8*length(data);
end

end