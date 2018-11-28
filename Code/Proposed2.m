clear all; clc;
addpath(genpath('Origin Images')); addpath(genpath('result')); addpath(genpath('tools'));

mask1 = [false, true; true, true];
mask2 = [false, false, true; true, true, true];

Imgs = {'Lena', 'Baboon', 'Barbara', 'Airplane', 'Lake', 'Peppers', 'Boat', 'Elaine'};
%%
for tt = 1:1:8
    Iname = Imgs{tt};
    istr = ['2/Proposed_2019_',Iname,'.mat']
    Io = double(imread([Iname,'.bmp']));
    
    [AuxLM, I] = LocationMap(Io);
    [A, B] = size(I);
    %%
    EdgInfo = 18+18+8+8+AuxLM; % Lclm CN kend T LM
    a = 2; b = 2;
    R = zeros(4,1000);
    cnt = 0;
    for Payload = 5000+EdgInfo : 1000 : 100000+EdgInfo
        tic
        %         Payload
        %%
        H1 = cell(1,2048);
        for i = 1 : 2048
            H1{i} = zeros(1,256);
        end
        
        EC1 = zeros(A-1,B-1);
        ED1 = zeros(A-1,B-1);
        NL = zeros(A-1,B-1);
        for i = 1:(A)-1
            for j = 1:(B)-1
%                 [i, j]
                for ii = 1:1
                    for jj = 0:2
                        if jj == 2
%                             [1*(i-1)+ii,1*(j-1)+jj, 1*(i-1)+ii+1,1*(j-1)+jj]
                            NL(i,j) = NL(i,j) + abs(I(1*(i-1)+ii,1*(j-1)+jj) - I(1*(i-1)+ii+1,1*(j-1)+jj));
                        end
                    end
                end
                for ii = 1:2
                    for jj = 0:1
                        if ii == 2 %&& (jj == 1 || jj == 0)
                            if 1*(j-1)+jj > 0
%                                 [1*(i-1)+ii,1*(j-1)+jj, 1*(i-1)+ii,1*(j-1)+jj+1]
                                NL(i,j) = NL(i,j) + abs(I(1*(i-1)+ii,1*(j-1)+jj) - I(1*(i-1)+ii,1*(j-1)+jj+1));
                            end
                        end
                    end
                end
%                 if j == 1
%                     flag
%                     NL(i,j) = floor(NL(i,j) * 3/2);
%                 end
                T = NL(i,j);
                
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
                    % dmax
                    if I(i,j) >= Y(end)
                        dmax = I(i,j) - Y(end); % >= 0
                        H1{T+1}(dmax+1) = H1{T+1}(dmax+1) + 1;
                        if dmax == 0
                            EC1(i,j) = EC1(i,j) + 1;
                            ED1(i,j) = ED1(i,j) + 0.5;
                        else
                            ED1(i,j) = ED1(i,j) + 1;
                        end
                    end
                    % dmin
                    if I(i,j) <= Y(1)
                        dmin = Y(1) - I(i,j); % >= 0
                        H1{T+1}(dmin+1) = H1{T+1}(dmin+1) + 1;
                        if dmin == 0
                            EC1(i,j) = EC1(i,j) + 1;
                            ED1(i,j) = ED1(i,j) + 0.5;
                        else
                            ED1(i,j) = ED1(i,j) + 1;
                        end
                    end
                else % In(end) == In(1)
                    if I(i,j) <= Y(end)
                        dmin = Y(1) - I(i,j); % >= 0
                        H1{T+1}(dmin+1) = H1{T+1}(dmin+1) + 1;
                        if dmin == 0
                            EC1(i,j) = EC1(i,j) + 1;
                            ED1(i,j) = ED1(i,j) + 0.5;
                        else
                            ED1(i,j) = ED1(i,j) + 1;
                        end
                    end
                end
                
            end
        end
        
        Ratio = 100000;
        nls = unique(NL(:));
        t1 = 0;
        for i = 1 : numel(nls)
            T1 = nls(i) + 1;
            h1 = zeros(1,256);
            for k = 1 : T1
                h1 = h1 + H1{k};
            end
            ec1 = h1(1);
            
            if ec1 > Payload
                ed1 = 0.5*h1(1) + sum(h1(2:end));
                ratio = ed1/ec1;
                if Ratio > ratio
                    Ratio = ratio;
                    EC = ec1;
                    ED = ed1;
                    t1 = T1;
                end
                break;
            end
        end
        
        if t1 == 0
            fprintf('Max Payload : %d\n', Payload-1000);
            break;
        end
        
        ec = 0;
        ed = 0;
        flag = 0;
        for i = 1:A-1
            if flag == 1
                break;
            end
            for j = 1:B-1
                if NL(i,j) < t1
                    ec = ec + EC1(i,j);
                    ed = ed + ED1(i,j);
                end
                if ec >= Payload
                    kend = [i,j];
                    flag = 1;
                    break;
                end
            end
        end

        PSNR = 10*log10(A*B*255^2 / ed);
        cnt = cnt + 1;
        R(:,cnt) = [Payload-EdgInfo, PSNR, EdgInfo, t1];
        [Payload PSNR toc]
    end
    res = R(:,1:cnt);
    save(istr, 'res');
end