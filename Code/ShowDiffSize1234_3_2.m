clear all; clc;
addpath(genpath('Origin Images')); addpath(genpath('result')); addpath(genpath('tools'));

mask1 = [false, true;
    true, true];
mask2 = [false, false, true;
    true, true, true];
mask3 = [false, true, true;
    true, true, true;
    true, true, false];
mask4 = [false, false, true, true;
    true, true, true, true;
    true, true, true, false];
mask5 = [false, false, false, true, true;
    true, true, true, true, true;
    false, true, true, true, false];
mask6 = [false, true, true, true;
    true, true, true, true;
    true, true, true, false;
    true, true, false, false];
mask7 = [false, false, true, true, true;
    true, true, true, true, true;
    true, true, true, true, false;
    true, true, true, false, false];
mask8 = [false, false, false, true, true, true;
    true, true, true, true, true, true;
    true, true, true, true, true, false;
    false, true, true, true, false, false];
mask9 = [false, false, false, false, true, true, true;
    true, true, true, true, true, true, true;
    false, true, true, true, true, true, false;
    false, false, true, true, true, false, false];
mask10 = [false, true, true, true;
    true, true, true, true;
    true, true, true, true;
    true, true, true, true];
mask11 = [false, false, true, true, true;
    true, true, true, true, true;
    true, true, true, true, true;
    true, true, true, true, true];
mask12 = [false, false, false, true, true, true;
    true, true, true, true, true, true;
    true, true, true, true, true, true;
    true, true, true, true, true, true];
mask13 = [false, false, false, false, true, true, true;
    true, true, true, true, true, true, true;
    true, true, true, true, true, true, true;
    true, true, true, true, true, true, true];


Imgs = {'Lena', 'Baboon', 'Airplane', 'Barbara', 'Lake', 'Peppers', 'Boat', 'Elaine'};
%%
for tt = 1:1:8
    Iname = Imgs{tt};
    istr = ['Proposed_2019_',Iname,'.mat']
    res = load(['5/' istr]); res = res.res;
    Io = double(imread([Iname,'.bmp']));
    
    [AuxLM, I] = LocationMap(Io);
    [A, B] = size(I);
    
    %%
    EdgInfo = 18+18+8+24+AuxLM; % Lclm CN kend T
    a = 4; b = 4;
    R1 = zeros(4,1000);
    R2 = zeros(4,1000);
    R3 = zeros(4,1000);
    R4 = zeros(4,1000);
    cnt1 = 0;
    cnt2 = 0;
    cnt3 = 0;
    cnt4 = 0;
    for Payload = 5000+EdgInfo:1000:16000+EdgInfo
        tic
        Tmax = 3000;
        %         Payload
        %%
        H1 = cell(1,Tmax);
        H2 = cell(1,Tmax);
        H3 = cell(1,Tmax);
        H4 = cell(1,Tmax);
        for i = 1 : Tmax
            H1{i} = zeros(1,256);
            H2{i} = zeros(1,256);
            H3{i} = zeros(1,256);
            H4{i} = zeros(1,256);
        end
        
        EC1 = zeros(A-3,B-3);
        ED1 = zeros(A-3,B-3);
        EC2 = zeros(A-3,B-3);
        ED2 = zeros(A-3,B-3);
        EC3 = zeros(A-3,B-3);
        ED3 = zeros(A-3,B-3);
        EC4 = zeros(A-3,B-3);
        ED4 = zeros(A-3,B-3);
        NL = zeros(A-3,B-3);
        for i = 1:(A-3)
            for j = 1:(B-3)
                %                 [i,j]
                for ii = 1:3
                    for jj = -2:4
                        if ii == 2 || ii == 3 || jj == 2 ||  jj == 3 || jj == 4
                            if 1*(j-1)+jj > 0
                                NL(i,j) = NL(i,j) + abs(I(1*(i-1)+ii,1*(j-1)+jj) - I(1*(i-1)+ii+1,1*(j-1)+jj));
                            end
                        end
                    end
                end
                for ii = 1:4
                    for jj = -2:3
                        if ii == 2 || ii == 3 || ii == 4 || jj == 2 ||  jj == 3
                            if 1*(j-1)+jj > 0
                                NL(i,j) = NL(i,j) + abs(I(1*(i-1)+ii,1*(j-1)+jj) - I(1*(i-1)+ii,1*(j-1)+jj+1));
                            end
                        end
                    end
                end
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
                else % Y(end) == Y(1)
                    if Y(end) == 254
                        if I(i,j) == 254
                            dmin = I(i,j) - Y(end);
                            H1{T+1}(dmin+1) = H1{T+1}(dmin+1) + 1;
                            if dmin == 0
                                EC1(i,j) = EC1(i,j) + 1;
                                ED1(i,j) = ED1(i,j) + 0.5;
                            else
                                ED1(i,j) = ED1(i,j) + 1;
                            end
                        end
                    else
                        if I(i,j) <= Y(end)
                            dmin = Y(1) - I(i,j); % >= 0
                            H1{T+1}(dmin+1) = H1{T+1}(dmin+1) + 1;
                            if dmin == 0
                                EC1(i,j) = EC1(i,j) + 1;
                                ED1(i,j) = ED1(i,j) + 0.5;
                            else
                                ED1(i,j) = ED1(i,j) + 1;
                            end
                        else % I(i,j) > Y(end)
                            dmax = I(i,j) - Y(1) - 1; % >= 0
                            H1{T+1}(dmax+1) = H1{T+1}(dmax+1) + 1;
                            if dmax == 0
                                EC1(i,j) = EC1(i,j) + 1;
                                ED1(i,j) = ED1(i,j) + 0.5;
                            else
                                ED1(i,j) = ED1(i,j) + 1;
                            end
                        end
                    end
                end
                
                % 3x3 block
                if j == 1
                    X = I(i:i+2,j:j+2);
                    X = X(mask3);
                end
                if j == 2
                    X = I(i:i+2,j-1:j+2);
                    X = X(mask4);
                end
                if j >=3
                    X = I(i:i+2,j-2:j+2);
                    X = X(mask5);
                end
                [Y, In] = sort(X);
                if Y(end) ~= Y(1)
                    % dmax
                    if I(i,j) >= Y(end)
                        dmax = I(i,j) - Y(end); % >= 0
                        H2{T+1}(dmax+1) = H2{T+1}(dmax+1) + 1;
                        if dmax == 0
                            EC2(i,j) = EC2(i,j) + 1;
                            ED2(i,j) = ED2(i,j) + 0.5;
                        else
                            ED2(i,j) = ED2(i,j) + 1;
                        end
                    end
                    % dmin
                    if I(i,j) <= Y(1)
                        dmin = Y(1) - I(i,j); % >= 0
                        H2{T+1}(dmin+1) = H2{T+1}(dmin+1) + 1;
                        if dmin == 0
                            EC2(i,j) = EC2(i,j) + 1;
                            ED2(i,j) = ED2(i,j) + 0.5;
                        else
                            ED2(i,j) = ED2(i,j) + 1;
                        end
                    end
                else % Y(end) == Y(1)
                    if Y(end) == 254
                        if I(i,j) == 254
                            dmin = I(i,j) - Y(end);
                            H2{T+1}(dmin+1) = H2{T+1}(dmin+1) + 1;
                            if dmin == 0
                                EC2(i,j) = EC2(i,j) + 1;
                                ED2(i,j) = ED2(i,j) + 0.5;
                            else
                                ED2(i,j) = ED2(i,j) + 1;
                            end
                        end
                    else
                        if I(i,j) <= Y(end)
                            dmin = Y(1) - I(i,j); % >= 0
                            H2{T+1}(dmin+1) = H2{T+1}(dmin+1) + 1;
                            if dmin == 0
                                EC2(i,j) = EC2(i,j) + 1;
                                ED2(i,j) = ED2(i,j) + 0.5;
                            else
                                ED2(i,j) = ED2(i,j) + 1;
                            end
                        else % I(i,j) > Y(end)
                            dmax = I(i,j) - Y(1) - 1; % >= 0
                            H2{T+1}(dmax+1) = H2{T+1}(dmax+1) + 1;
                            if dmax == 0
                                EC2(i,j) = EC2(i,j) + 1;
                                ED2(i,j) = ED2(i,j) + 0.5;
                            else
                                ED2(i,j) = ED2(i,j) + 1;
                            end
                        end
                    end
                end
                
                % 4x4 block
                if j == 1
                    X = I(i:i+3,j:j+3);
                    X = X(mask6);
                end
                if j == 2
                    X = I(i:i+3,j-1:j+3);
                    X = X(mask7);
                end
                if j ==3
                    X = I(i:i+3,j-2:j+3);
                    X = X(mask8);
                end
                if j >=4
                    X = I(i:i+3,j-3:j+3);
                    X = X(mask9);
                end
                [Y, In] = sort(X);
                if Y(end) ~= Y(1)
                    % dmax
                    if I(i,j) >= Y(end)
                        dmax = I(i,j) - Y(end); % >= 0
                        H3{T+1}(dmax+1) = H3{T+1}(dmax+1) + 1;
                        if dmax == 0
                            EC3(i,j) = EC3(i,j) + 1;
                            ED3(i,j) = ED3(i,j) + 0.5;
                        else
                            ED3(i,j) = ED3(i,j) + 1;
                        end
                    end
                    % dmin
                    if I(i,j) <= Y(1)
                        dmin = Y(1) - I(i,j); % >= 0
                        H3{T+1}(dmin+1) = H3{T+1}(dmin+1) + 1;
                        if dmin == 0
                            EC3(i,j) = EC3(i,j) + 1;
                            ED3(i,j) = ED3(i,j) + 0.5;
                        else
                            ED3(i,j) = ED3(i,j) + 1;
                        end
                    end
                else % Y(end) == Y(1)
                    if Y(end) == 254
                        if I(i,j) == 254
                            dmin = I(i,j) - Y(end);
                            H3{T+1}(dmin+1) = H3{T+1}(dmin+1) + 1;
                            if dmin == 0
                                EC3(i,j) = EC3(i,j) + 1;
                                ED3(i,j) = ED3(i,j) + 0.5;
                            else
                                ED3(i,j) = ED3(i,j) + 1;
                            end
                        end
                    else
                        if I(i,j) <= Y(end)
                            dmin = Y(1) - I(i,j); % >= 0
                            H3{T+1}(dmin+1) = H3{T+1}(dmin+1) + 1;
                            if dmin == 0
                                EC3(i,j) = EC3(i,j) + 1;
                                ED3(i,j) = ED3(i,j) + 0.5;
                            else
                                ED3(i,j) = ED3(i,j) + 1;
                            end
                        else % I(i,j) > Y(end)
                            dmax = I(i,j) - Y(1) - 1; % >= 0
                            H3{T+1}(dmax+1) = H3{T+1}(dmax+1) + 1;
                            if dmax == 0
                                EC3(i,j) = EC3(i,j) + 1;
                                ED3(i,j) = ED3(i,j) + 0.5;
                            else
                                ED3(i,j) = ED3(i,j) + 1;
                            end
                        end
                    end
                end
                
                % 5x5 block
                if j == 1
                    X = I(i:i+3,j:j+3);
                    X = X(mask10);
                end
                if j == 2
                    X = I(i:i+3,j-1:j+3);
                    X = X(mask11);
                end
                if j ==3
                    X = I(i:i+3,j-2:j+3);
                    X = X(mask12);
                end
                if j >=4
                    X = I(i:i+3,j-3:j+3);
                    X = X(mask13);
                end
                [Y, In] = sort(X);
                if Y(end) ~= Y(1)
                    % dmax
                    if I(i,j) >= Y(end)
                        dmax = I(i,j) - Y(end); % >= 0
                        H4{T+1}(dmax+1) = H4{T+1}(dmax+1) + 1;
                        if dmax == 0
                            EC4(i,j) = EC4(i,j) + 1;
                            ED4(i,j) = ED4(i,j) + 0.5;
                        else
                            ED4(i,j) = ED4(i,j) + 1;
                        end
                    end
                    % dmin
                    if I(i,j) <= Y(1)
                        dmin = Y(1) - I(i,j); % >= 0
                        H4{T+1}(dmin+1) = H4{T+1}(dmin+1) + 1;
                        if dmin == 0
                            EC4(i,j) = EC4(i,j) + 1;
                            ED4(i,j) = ED4(i,j) + 0.5;
                        else
                            ED4(i,j) = ED4(i,j) + 1;
                        end
                    end
                else % Y(end) == Y(1)
                    if Y(end) == 254
                        if I(i,j) == 254
                            dmin = I(i,j) - Y(end);
                            H4{T+1}(dmin+1) = H4{T+1}(dmin+1) + 1;
                            if dmin == 0
                                EC4(i,j) = EC4(i,j) + 1;
                                ED4(i,j) = ED4(i,j) + 0.5;
                            else
                                ED4(i,j) = ED4(i,j) + 1;
                            end
                        end
                    else
                        if I(i,j) <= Y(end)
                            dmin = Y(1) - I(i,j); % >= 0
                            H4{T+1}(dmin+1) = H4{T+1}(dmin+1) + 1;
                            if dmin == 0
                                EC4(i,j) = EC4(i,j) + 1;
                                ED4(i,j) = ED4(i,j) + 0.5;
                            else
                                ED4(i,j) = ED4(i,j) + 1;
                            end
                        else % I(i,j) > Y(end)
                            dmax = I(i,j) - Y(1) - 1; % >= 0
                            H4{T+1}(dmax+1) = H4{T+1}(dmax+1) + 1;
                            if dmax == 0
                                EC4(i,j) = EC4(i,j) + 1;
                                ED4(i,j) = ED4(i,j) + 0.5;
                            else
                                ED4(i,j) = ED4(i,j) + 1;
                            end
                        end
                    end
                end
                
            end
        end
        
        
        C1 = zeros(1,Tmax); C1(1) = H1{1}(1);
        C2 = zeros(1,Tmax); C2(1) = H2{1}(1);
        C3 = zeros(1,Tmax); C3(1) = H3{1}(1);
        C4 = zeros(1,Tmax); C4(1) = H4{1}(1);
        D1 = zeros(1,Tmax); D1(1) = 0.5*H1{1}(1) + sum(H1{1}(2:end));
        D2 = zeros(1,Tmax); D2(1) = 0.5*H2{1}(1) + sum(H2{1}(2:end));
        D3 = zeros(1,Tmax); D3(1) = 0.5*H3{1}(1) + sum(H3{1}(2:end));
        D4 = zeros(1,Tmax); D4(1) = 0.5*H4{1}(1) + sum(H4{1}(2:end));
        
        for i = 2 : 1 : Tmax
            H1{i} = H1{i} + H1{i-1};
            H2{i} = H2{i} + H2{i-1};
            H3{i} = H3{i} + H3{i-1};
            H4{i} = H4{i} + H4{i-1};
            C1(i) = H1{i}(1);
            C2(i) = H2{i}(1);
            C3(i) = H3{i}(1);
            C4(i) = H4{i}(1);
            D1(i) = 0.5*H1{i}(1) + sum(H1{i}(2:end));
            D2(i) = 0.5*H2{i}(1) + sum(H2{i}(2:end));
            D3(i) = 0.5*H3{i}(1) + sum(H3{i}(2:end));
            D4(i) = 0.5*H4{i}(1) + sum(H4{i}(2:end));
        end
        
        Ratio = 100000;
        nls = unique(NL(:));
        t1 = 0;
        for i = 1 : numel(nls)
            T1 = nls(i) + 1;
            ec = C1(T1);
            if ec > Payload
                ed = D1(T1);
                ratio = ed/ec;
                if Ratio > ratio
                    Ratio = ratio;
                    %                     EC = ec;
                    ED = ed;
                    t1 = T1;
                end
                break;
            end
        end
        
        if t1 == 0
            fprintf('Max Payload : %d\n', Payload-1000);
            break;
        else
            ec = 0;
            ed = 0;
            flag = 0;
            for i = 1:(A-3)
                if flag == 1
                    break;
                end
                for j = 1:(B-3)
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
            cnt1 = cnt1 + 1;
            R1(:,cnt1) = [Payload-EdgInfo, PSNR, EdgInfo, t1];
        end
        
        
        Ratio = 100000;
        nls = unique(NL(:));
        t2 = 0;
        for i = 1 : numel(nls)
            T2 = nls(i) + 1;
            ec = C2(T2);
            if ec > Payload
                ed = D2(T2);
                ratio = ed/ec;
                if Ratio > ratio
                    Ratio = ratio;
                    %                     EC = ec;
                    ED = ed;
                    t2 = T2;
                end
                break;
            end
        end
        
        if t2 == 0
            fprintf('Max Payload : %d\n', Payload-1000);
        else
            ec = 0;
            ed = 0;
            flag = 0;
            for i = 1:(A-3)
                if flag == 1
                    break;
                end
                for j = 1:(B-3)
                    if NL(i,j) < t2
                        ec = ec + EC2(i,j);
                        ed = ed + ED2(i,j);
                    end
                    if ec >= Payload
                        kend = [i,j];
                        flag = 1;
                        break;
                    end
                end
            end
            
            PSNR = 10*log10(A*B*255^2 / ed);
            cnt2 = cnt2 + 1;
            R2(:,cnt2) = [Payload-EdgInfo, PSNR, EdgInfo, t2];
        end
        
        
        Ratio = 100000;
        nls = unique(NL(:));
        t3 = 0;
        for i = 1 : numel(nls)
            T3 = nls(i) + 1;
            ec = C3(T3);
            if ec > Payload
                ed = D3(T3);
                ratio = ed/ec;
                if Ratio > ratio
                    Ratio = ratio;
                    %                     EC = ec;
                    ED = ed;
                    t3 = T3;
                end
                break;
            end
        end
        
        if t3 == 0
            fprintf('Max Payload : %d\n', Payload-1000);
        else
            ec = 0;
            ed = 0;
            flag = 0;
            for i = 1:(A-3)
                if flag == 1
                    break;
                end
                for j = 1:(B-3)
                    if NL(i,j) < t3
                        ec = ec + EC3(i,j);
                        ed = ed + ED3(i,j);
                    end
                    if ec >= Payload
                        kend = [i,j];
                        flag = 1;
                        break;
                    end
                end
            end
            
            PSNR = 10*log10(A*B*255^2 / ed);
            cnt3 = cnt3 + 1;
            R3(:,cnt3) = [Payload-EdgInfo, PSNR, EdgInfo, t3];
        end
        
        
        Ratio = 100000;
        nls = unique(NL(:));
        t4 = 0;
        for i = 1 : numel(nls)
            T4 = nls(i) + 1;
            ec = C4(T4);
            if ec > Payload
                ed = D4(T4);
                ratio = ed/ec;
                if Ratio > ratio
                    Ratio = ratio;
                    %                     EC = ec;
                    ED = ed;
                    t4 = T4;
                end
                break;
            end
        end
        
        if t4 == 0
            fprintf('Max Payload : %d\n', Payload-1000);
        else
            ec = 0;
            ed = 0;
            flag = 0;
            for i = 1:(A-3)
                if flag == 1
                    break;
                end
                for j = 1:(B-3)
                    if NL(i,j) < t4
                        ec = ec + EC4(i,j);
                        ed = ed + ED4(i,j);
                    end
                    if ec >= Payload
                        kend = [i,j];
                        flag = 1;
                        break;
                    end
                end
            end
            
            PSNR = 10*log10(A*B*255^2 / ed);
            cnt4 = cnt4 + 1;
            R4(:,cnt4) = [Payload-EdgInfo, PSNR, EdgInfo, t4];
        end
        
        
        
        [Payload toc]
    end
    
    res1 = R1(:,1:cnt1);
    res2 = R2(:,1:cnt2);
    res3 = R3(:,1:cnt3);
    res4 = R4(:,1:cnt4);
    
    h=figure('Name', Iname, 'pos', [10, 10, 500, 300]);
    plot(res1(1, :), res1(2, :), ['-o','b'], ...
        'MarkerFaceColor', 'b', ...
        'MarkerSize', 3.5, ...
        'DisplayName', '1', ...
        'LineWidth', 1.7);
    
    hold on;
    plot(res2(1, :), res2(2, :), ['-o', 'r'], ...
        'MarkerFaceColor', 'r', ...
        'MarkerSize', 3.5, ...
        'DisplayName', '2', ...
        'LineWidth', 1.7);
    hold on;
    plot(res3(1, :), res3(2, :), ['-o', 'g'], ...
        'MarkerFaceColor', 'g', ...
        'MarkerSize', 3.5, ...
        'DisplayName', '3', ...
        'LineWidth', 1.7);
    hold on;
    plot(res4(1, :), res4(2, :), ['-o', 'c'], ...
        'MarkerFaceColor', 'c', ...
        'MarkerSize', 3.5, ...
        'DisplayName', '4', ...
        'LineWidth', 1.7);
    hold on;
    plot(res(1, :), res(2, :), ['-o', 'k'], ...
        'MarkerFaceColor', 'k', ...
        'MarkerSize', 3.5, ...
        'DisplayName', 'MHM', ...
        'LineWidth', 1.7);
    
    xs = min([res(1, :) res1(1, :) res2(1, :) res3(1, :) res4(1, :)]);
    xe = max([res(1, :) res1(1, :) res2(1, :) res3(1, :) res4(1, :)]);
    ys = min([res(2, :) res1(2, :) res2(2, :) res3(2, :) res4(2, :)]);
    ye = max([res(2, :) res1(2, :) res2(2, :) res3(2, :) res4(2, :)]);
    lg = legend('show');
    set(lg, 'FontSize', 14);
    xlabel('Embedding capacity (bits)');
    ylabel('PSNR (dB)');
    axis([5000, xe+1000, ys-2, ye]);
    grid on;
    set(gca, 'GridLineStyle' ,':');
    set(gca, 'GridAlpha', 1);
    set(gca, 'box', 'on');
    set(gcf,'unit','normalized','position',[0.1,0.1,0.4,0.48]);
    axis normal;
    set(gca,'FontSize',14);
    title(Iname);
%     saveas(h,['DiffSize1234' Iname, '.jpg'],'jpg');
    saveas(h,['DiffSize1234' Iname, '.pdf'],'pdf');
end
