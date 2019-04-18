function [ ph,pl,heng,shu,NL,zhi] = error_compute_1( I )
[ NNLL,xposxpos,yposypos,pphh,ppll,zhizhi ] = edge_point( I );

[A,B] = size(I);
index = 0;
ph_x = zeros(1,A*B);
pl_x = zeros(1,A*B);
ph_y = zeros(1,A*B);
pl_y = zeros(1,A*B);

heng_x = zeros(1,A*B);
shu_x = zeros(1,A*B);
heng_y = zeros(1,A*B);
shu_y = zeros(1,A*B);
NL_x = zeros(1,A*B);
NL_y = zeros(1,A*B);

zhix = zeros(1,A*B);
zhiy = zeros(1,A*B);

for i = 3:2:A-3
    for j = 3:2:B-3
        
                 p1 = I(i-2,j-1);                p5 = I(i-2,j+1);
p2 = I(i-1,j-2);                  p4 = I(i-1,j);                 p6 = I(i-1,j+2);
                 p3 = I(i,j-1);   x  = I(i,j);   p7 = I(i,j+1);                   p13 = I(i,j+3);
p12 = I(i+1,j-2);                p10 = I(i+1,j);  y = I(i+1,j+1); p8 = I(i+1,j+2);
                 p11 = I(i+2,j-1);               p9 = I(i+2,j+1);                 p14 = I(i+2,j+3);
                                 p15 = I(i+3,j);                  p16 = I(i+3,j+2);
        index = index+1;
        xu_x = sort([p3,p4,p7,p10]);
        xu_y = sort([p7,p8,p9,p10]);
        
        %%%%%%%%%%%%%%%%%% Predictor 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ph_x(index) = xu_x(4);
        pl_x(index) = xu_x(1);
        if ph_x(index) == pl_x(index)
            pl_x(index) = pl_x(index) - 1;
        end
        
        ph_y(index) = xu_y(4);
        pl_y(index) = xu_y(1);  
        if ph_y(index) == pl_y(index)
            pl_y(index) = pl_y(index) - 1;
        end
%         
%         %%%%%%%%%%%%%%%%%% Predictor 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         ph_x(index) = round((xu_x(4)+xu_x(3))/2);
%         pl_x(index) = round((xu_x(1)+xu_x(2))/2);
% 
%         if ph_x(index) == pl_x(index)
%             pl_x(index) = pl_x(index) - 1;
%         end
%         
%         ph_y(index) = round((xu_y(4)+xu_y(3))/2);
%         pl_y(index) = round((xu_y(1)+xu_y(2))/2);   
% 
%         if ph_y(index) == pl_y(index)
%             pl_y(index) = pl_y(index) - 1;
%         end
%         
%         %%%%%%%%%%%%%%%%%% Predictor 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         ph_x(index) = round((xu_x(4)+xu_x(3)+xu_x(2))/3);
%         pl_x(index) = round((xu_x(1)+xu_x(2)+xu_x(3))/3);
% 
%         if ph_x(index) == pl_x(index)
%             pl_x(index) = pl_x(index) - 1;
%         end
%         
%         ph_y(index) = round((xu_y(4)+xu_y(3)+xu_y(2))/3);
%         pl_y(index) = round((xu_y(1)+xu_y(2)+xu_y(3))/3);  
% 
%         if ph_y(index) == pl_y(index)
%             pl_y(index) = pl_y(index) - 1;
%         end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        heng_x(index) = i;
        shu_x(index) = j;
        
        heng_y(index) = i+1;
        shu_y(index) = j+1;
        
        zhix(index) = x;
        zhiy(index) = y;
        
        NL_x(index) = noise_level(p1,p2,p3,p4) + noise_level(p5,p4,p7,p6) + noise_level(p7,p10,p9,p8) + noise_level(p3,p12,p11,p10) + noise_level(p4,p3,p10,p7);
        NL_y(index) = noise_level(p4,p3,p10,p7) + noise_level(p6,p7,p8,p13) + noise_level(p8,p9,p16,p14) + noise_level(p10,p11,p15,p9) + noise_level(p7,p10,p9,p8);      
    end
end
        ph_x = ph_x(1:index);
        pl_x = pl_x(1:index);
        ph_y = ph_y(1:index);
        pl_y = pl_y(1:index);
        heng_x = heng_x(1:index);
        shu_x = shu_x(1:index);
        heng_y = heng_y(1:index);
        shu_y = shu_y(1:index);
        NL_x = NL_x(1:index);
        NL_y = NL_y(1:index);
        
        zhix = zhix(1:index);
        zhiy = zhiy(1:index);
        zhi = [zhix zhiy zhizhi];
        

        heng = [heng_x heng_y xposxpos];
        shu = [shu_x shu_y yposypos];
        ph = [ph_x ph_y pphh];
        pl = [pl_x pl_y ppll];
        NL = [NL_x NL_y NNLL];
end




