function [ I_new,EC,T ] = embed_high_2( I,ph,pl, heng, shu, NL, capacity, T1 )

I_new = I;
geshu = size(ph,2);
data=randperm(512^2);
bit2 = mod(data,2);

EC = 0;
index_bit = 0;
for T = T1:max(NL)   
%     T
    if EC >= capacity
        break;
    end
    I_new = I;
    for k = 1:geshu
        if EC >= capacity
            break;
        end
        cur_NL = NL(k);
        if cur_NL <= T
            cur_heng = heng(k);
            cur_shu = shu(k);
            cur_p = I(cur_heng,cur_shu);
            cur_ph = ph(k);
            e_ph = cur_p - cur_ph;
            if e_ph == 0
                index_bit = index_bit + 1;
                cur_bit = bit2(index_bit);
                I_new(cur_heng,cur_shu) = cur_p + cur_bit;
            else if e_ph > 0
                    I_new(cur_heng,cur_shu) = cur_p + 1;
                end
            end
            
            cur_pp = I_new(cur_heng,cur_shu);
            cur_pl = pl(k);
            e_pl = cur_pp - cur_pl;
            if e_pl == 0
                index_bit = index_bit + 1;
                cur_bit = bit2(index_bit);
                I_new(cur_heng,cur_shu) = cur_pp - cur_bit;
            else if e_pl < 0
                    I_new(cur_heng,cur_shu) = cur_pp - 1;
                end
            end
        end
        EC = index_bit;
    end
    index_bit = 0;
%     dis = sum(sum(abs(I-I_new)));
end

if T == T1
    disp('error!')
end

end


        
        
        
        
        
        

        
        
        
        
        
