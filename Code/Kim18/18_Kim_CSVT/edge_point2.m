% function [ NNLL,xposxpos,yposypos,pphh,ppll ] = edge_point2( I )
% 
% [A,B] = size(I);
% % 处理第二行（除去右上角的点）
% NL = zeros(1,A*B);
% xpos = zeros(1,A*B);
% ypos = zeros(1,A*B);
% ph_x = zeros(1,A*B);
% pl_x = zeros(1,A*B);
% index = 0;
% 
% for i=2
%     for j=3:2:B-2
%                 p1 = I(i-1,j-1);                p5 = I(i-1,j+1);
% p2 = I(i-1,j-2);                  p4 = I(i-1,j);                 p6 = I(i-1,j+2);
%                  p3 = I(i,j-1);   x  = I(i,j);   p7 = I(i,j+1);                   
% p12 = I(i+1,j-2);                p10 = I(i+1,j);                 p8 = I(i+1,j+2);
%                  p11 = I(i+2,j-1);               p9 = I(i+2,j+1);  
%         
%         index = index+1;
%         xu_x = sort([p3,p4,p7,p10]);
%         
%         ph_x(index) = xu_x(4);
%         pl_x(index) = xu_x(1);
%         if ph_x(index) == pl_x(index)
%             pl_x(index) = pl_x(index) - 1;
%         end
%         
%         NL(index) = noise_level(p1,p2,p3,p4) + noise_level(p5,p4,p7,p6) + noise_level(p7,p10,p9,p8) + noise_level(p3,p12,p11,p10) + noise_level(p4,p3,p10,p7);
%         xpos(index) = i;
%         ypos(index) = j;
%     end
% end
% 
% NL = NL(1:index);
% xpos = xpos(1:index);
% ypos = ypos(1:index);
% ph_x = ph_x(1:index);
% pl_x = pl_x(1:index);
% 
% NL_a=NL;
% xpos_a=xpos;ypos_a=ypos;
% ph_x_a = ph_x; pl_x_a = pl_x;
% 
% % 处理倒数第二行（除去左下角的点）
% NL = zeros(1,A*B);
% xpos = zeros(1,A*B);
% ypos = zeros(1,A*B);
% ph_x = zeros(1,A*B);
% pl_x = zeros(1,A*B);
% index = 0;
% 
% 
% for i=A-1
%     for j=4:2:B-2
%                 p1 = I(i-2,j-1);                p5 = I(i-2,j+1);
% p2 = I(i-1,j-2);                  p4 = I(i-1,j);                 p6 = I(i-1,j+2);
%                  p3 = I(i,j-1);   x  = I(i,j);   p7 = I(i,j+1);                   
% p12 = I(i+1,j-2);                p10 = I(i+1,j);                 p8 = I(i+1,j+2);
%                  p11 = I(i+1,j-1);               p9 = I(i+1,j+1);  
%         
% 
%         index = index+1;
%         xu_x = sort([p3,p4,p7,p10]);
%         
%         ph_x(index) = xu_x(4);
%         pl_x(index) = xu_x(1);
%         if ph_x(index) == pl_x(index)
%             pl_x(index) = pl_x(index) - 1;
%         end
%         
%         NL(index) = noise_level(p1,p2,p3,p4) + noise_level(p5,p4,p7,p6) + noise_level(p7,p10,p9,p8) + noise_level(p3,p12,p11,p10) + noise_level(p4,p3,p10,p7);
%         xpos(index) = i;
%         ypos(index) = j;
%     end
% end
% 
% NL = NL(1:index);
% xpos = xpos(1:index);
% ypos = ypos(1:index);
% ph_x = ph_x(1:index);
% pl_x = pl_x(1:index);
% 
% NL_b=NL;
% xpos_b=xpos;ypos_b=ypos;
% ph_x_b = ph_x; pl_x_b = pl_x;
% 
% 
% % 处理第二列（除去左下角的点）
% NL = zeros(1,A*B);
% xpos = zeros(1,A*B);
% ypos = zeros(1,A*B);
% ph_x = zeros(1,A*B);
% pl_x = zeros(1,A*B);
% index = 0;
% 
% 
% for i=3:2:A-2
%     for j=2
%                 p1 = I(i-2,j-1);                p5 = I(i-2,j+1);
% p2 = I(i-1,j-1);                  p4 = I(i-1,j);                 p6 = I(i-1,j+2);
%                  p3 = I(i,j-1);   x  = I(i,j);   p7 = I(i,j+1);                   
% p12 = I(i+1,j-1);                p10 = I(i+1,j);                 p8 = I(i+1,j+2);
%                  p11 = I(i+2,j-1);               p9 = I(i+2,j+1);  
%         
% 
%         index = index+1;
%         xu_x = sort([p3,p4,p7,p10]);
%         
%         ph_x(index) = xu_x(4);
%         pl_x(index) = xu_x(1);
%         if ph_x(index) == pl_x(index)
%             pl_x(index) = pl_x(index) - 1;
%         end
%         
%         NL(index) = noise_level(p1,p2,p3,p4) + noise_level(p5,p4,p7,p6) + noise_level(p7,p10,p9,p8) + noise_level(p3,p12,p11,p10) + noise_level(p4,p3,p10,p7);
%         xpos(index) = i;
%         ypos(index) = j;
%     end
% end
% 
% NL = NL(1:index);
% xpos = xpos(1:index);
% ypos = ypos(1:index);
% ph_x = ph_x(1:index);
% pl_x = pl_x(1:index);
% 
% 
% NL_c=NL;
% xpos_c=xpos;ypos_c=ypos;
% ph_x_c = ph_x; pl_x_c = pl_x;
% 
% 
% % 处理倒数第二列（除去右上角的点）
% NL = zeros(1,A*B);
% xpos = zeros(1,A*B);
% ypos = zeros(1,A*B);
% ph_x = zeros(1,A*B);
% pl_x = zeros(1,A*B);
% index = 0;
% 
% 
% for i=4:2:A-2
%     for j=B-1
%                 p1 = I(i-2,j-1);                p5 = I(i-2,j+1);
% p2 = I(i-1,j-2);                  p4 = I(i-1,j);                 p6 = I(i-1,j+1);
%                  p3 = I(i,j-1);   x  = I(i,j);   p7 = I(i,j+1);                   
% p12 = I(i+1,j-2);                p10 = I(i+1,j);                 p8 = I(i+1,j+1);
%                  p11 = I(i+2,j-1);               p9 = I(i+2,j+1);  
%         
% 
%         index = index+1;
%         xu_x = sort([p3,p4,p7,p10]);
%         
%         ph_x(index) = xu_x(4);
%         pl_x(index) = xu_x(1);
%         if ph_x(index) == pl_x(index)
%             pl_x(index) = pl_x(index) - 1;
%         end
% 
%         NL(index) = noise_level(p1,p2,p3,p4) + noise_level(p5,p4,p7,p6) + noise_level(p7,p10,p9,p8) + noise_level(p3,p12,p11,p10) + noise_level(p4,p3,p10,p7);
%         xpos(index) = i;
%         ypos(index) = j;
%     end
% end
% 
% NL = NL(1:index);
% xpos = xpos(1:index);
% ypos = ypos(1:index);
% ph_x = ph_x(1:index);
% pl_x = pl_x(1:index);
% 
% 
% NL_d=NL;
% xpos_d=xpos;ypos_d=ypos;
% ph_x_d = ph_x; pl_x_d = pl_x;
% 
% NNLL = [NL_a NL_b NL_c NL_d];
% xposxpos = [xpos_a xpos_b xpos_c xpos_d];
% yposypos = [ypos_a ypos_b ypos_c ypos_d];
% pphh = [ph_x_a ph_x_b ph_x_c ph_x_d];
% ppll = [pl_x_a pl_x_b pl_x_c pl_x_d];
% 
% end

%%
function [ NNLL,xposxpos,yposypos,pphh,ppll ] = edge_point2( I )

[A,B] = size(I);
% 处理第二行（除去右上角的点）
NL = zeros(1,A*B);
xpos = zeros(1,A*B);
ypos = zeros(1,A*B);
ph_x = zeros(1,A*B);
pl_x = zeros(1,A*B);
index = 0;

for i=2
    for j=3:2:B-3

                 p4 = I(i-1,j);                
p3 = I(i,j-1);   x  = I(i,j);   p7 = I(i,j+1);                   
                 p10 = I(i+1,j);               
 
        
        index = index+1;
        xu_x = sort([p3,p4,p7,p10]);
        
        ph_x(index) = xu_x(4);
        pl_x(index) = xu_x(1);
        if ph_x(index) == pl_x(index)
            pl_x(index) = pl_x(index) - 1;
        end
        
        NL(index) = noise_level(p4,p3,p10,p7)*5;
        xpos(index) = i;
        ypos(index) = j;
    end
end

NL = NL(1:index);
xpos = xpos(1:index);
ypos = ypos(1:index);
ph_x = ph_x(1:index);
pl_x = pl_x(1:index);

NL_a=NL;
xpos_a=xpos;ypos_a=ypos;
ph_x_a = ph_x; pl_x_a = pl_x;

% 处理倒数第二行（除去左下角的点）
NL = zeros(1,A*B);
xpos = zeros(1,A*B);
ypos = zeros(1,A*B);
ph_x = zeros(1,A*B);
pl_x = zeros(1,A*B);
index = 0;


for i=A-1
    for j=4:2:B-2
                 p4 = I(i-1,j);                
p3 = I(i,j-1);   x  = I(i,j);   p7 = I(i,j+1);                   
                 p10 = I(i+1,j);   

        index = index+1;
        xu_x = sort([p3,p4,p7,p10]);
        
        ph_x(index) = xu_x(4);
        pl_x(index) = xu_x(1);
        if ph_x(index) == pl_x(index)
            pl_x(index) = pl_x(index) - 1;
        end
        
        NL(index) = noise_level(p4,p3,p10,p7)*5;
        xpos(index) = i;
        ypos(index) = j;
    end
end

NL = NL(1:index);
xpos = xpos(1:index);
ypos = ypos(1:index);
ph_x = ph_x(1:index);
pl_x = pl_x(1:index);

NL_b=NL;
xpos_b=xpos;ypos_b=ypos;
ph_x_b = ph_x; pl_x_b = pl_x;


% 处理第二列（除去左下角的点）
NL = zeros(1,A*B);
xpos = zeros(1,A*B);
ypos = zeros(1,A*B);
ph_x = zeros(1,A*B);
pl_x = zeros(1,A*B);
index = 0;


for i=3:2:A-2
    for j=2
                 p4 = I(i-1,j);                
p3 = I(i,j-1);   x  = I(i,j);   p7 = I(i,j+1);                   
                 p10 = I(i+1,j);   

        index = index+1;
        xu_x = sort([p3,p4,p7,p10]);
        
        ph_x(index) = xu_x(4);
        pl_x(index) = xu_x(1);
        if ph_x(index) == pl_x(index)
            pl_x(index) = pl_x(index) - 1;
        end
        
        NL(index) = noise_level(p4,p3,p10,p7)*5;
        xpos(index) = i;
        ypos(index) = j;
    end
end

NL = NL(1:index);
xpos = xpos(1:index);
ypos = ypos(1:index);
ph_x = ph_x(1:index);
pl_x = pl_x(1:index);


NL_c=NL;
xpos_c=xpos;ypos_c=ypos;
ph_x_c = ph_x; pl_x_c = pl_x;


% 处理倒数第二列（除去右上角的点）
NL = zeros(1,A*B);
xpos = zeros(1,A*B);
ypos = zeros(1,A*B);
ph_x = zeros(1,A*B);
pl_x = zeros(1,A*B);
index = 0;


for i=4:2:A-2
    for j=B-1
        
                 p4 = I(i-1,j);                
p3 = I(i,j-1);   x  = I(i,j);   p7 = I(i,j+1);                   
                 p10 = I(i+1,j);   
        

        index = index+1;
        xu_x = sort([p3,p4,p7,p10]);
        
        ph_x(index) = xu_x(4);
        pl_x(index) = xu_x(1);
        if ph_x(index) == pl_x(index)
            pl_x(index) = pl_x(index) - 1;
        end

        NL(index) = noise_level(p4,p3,p10,p7)*5;
        xpos(index) = i;
        ypos(index) = j;
    end
end

NL = NL(1:index);
xpos = xpos(1:index);
ypos = ypos(1:index);
ph_x = ph_x(1:index);
pl_x = pl_x(1:index);


NL_d=NL;
xpos_d=xpos;ypos_d=ypos;
ph_x_d = ph_x; pl_x_d = pl_x;

NNLL = [NL_a NL_b NL_c NL_d];
xposxpos = [xpos_a xpos_b xpos_c xpos_d];
yposypos = [ypos_a ypos_b ypos_c ypos_d];
pphh = [ph_x_a ph_x_b ph_x_c ph_x_d];
ppll = [pl_x_a pl_x_b pl_x_c pl_x_d];

end



