clear all; clc;
addpath(genpath('2x2')); addpath(genpath('3x3')); addpath(genpath('4x4'));

Imgs = {'Lena', 'Baboon', 'Barbara', 'Airplane', 'Lake', 'Peppers', 'Boat', 'Elaine'};

for tt = 1 : 1 : 8
    Iname = Imgs{tt}; 
    istr = ['Proposed_2019_',Iname,'.mat'];
    res2 = load(['2/', istr]); res2 = res2.res;
    res3 = load(['3/', istr]); res3 = res3.res;
    res4 = load(['4/', istr]); res4 = res4.res;
%     res5 = load(['5x5Part/', istr]); res5 = res5.res;

%     lt = max([size(res2,2), size(res3,2), size(res4,2), size(res5,2)]);
    lt = max([size(res2,2), size(res3,2), size(res4,2)]);
    res = zeros(3, lt);

    for i = 1 : 1 : lt
        sz = 1;
        pl = 1;
        psnr = 0;
        if i <= size(res2,2)
            psnr = res2(2,i);
            pl = res2(1,i);
            sz = 2;
        end
        if i <= size(res3,2)
            if res3(2,i) > psnr
                psnr = res3(2,i);
                pl = res3(1,i);
                sz = 3;
            end
        end
        if i <= size(res4,2)
            if res4(2,i) > psnr
                psnr = res4(2,i);
                pl = res4(1,i);
                sz = 4;
            end
        end
        res(:,i) = [pl, psnr, sz];
    end
    save(istr, 'res');
end