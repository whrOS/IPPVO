clc; clear all; addpath(genpath('Origin Images'));

mask1 = [false, true; true, true];
mask2 = [false, false, true; true, true, true];

Imgs = {'Lena', 'Baboon', 'Barbara', 'Airplane', 'Lake', 'Peppers', 'Boat', 'Elaine'};
%%
tt = 4;

Iname = Imgs{tt};
istr = ['2/Proposed_2019_',Iname,'.mat']
Io = double(imread([Iname,'.bmp']));
[AuxLM, I] = LocationMap(Io);
[A, B] = size(I);
%%
cnt1 = 0;
cnt2 = 0;
%%
for i = 1:(A)-1
    for j = 1:(B)-1
        % 2x2 block
        X = I(i:i+1,j:j+1);
        X = X(mask1);
        [Y, In] = sort(X);
        if Y(end) ~= Y(1)
            if I(i,j) < Y(end) && I(i,j) > Y(1)
                cnt1 = cnt1 + 1;
            end
        end
        
    end
end

for i = 1:(A)-1
    for j = 1:(B)-1
        % 2x2 block
        if j == 1
            X = I(i:i+1,j:j+1);
            X = X(mask1);
        else
            X = I(i:i+1,j-1:j+1);
            X = X(mask2);
        end
        [Y, In] = sort(X);
        if Y(end) ~= Y(1)
            if I(i,j) < Y(end) && I(i,j) > Y(1)
                cnt2 = cnt2 + 1;
            end
        end
        
    end
end