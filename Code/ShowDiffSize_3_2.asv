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
    a = 4; b = 4;
    cnt1 = 0;
    cnt2 = 0;
    cnt3 = 0;
    cnt4 = 0;
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
    
    R1 = zeros(size(C1));
    R2 = zeros(size(C1));
    R3 = zeros(size(C1));
    R4 = zeros(size(C1));
    for i = 2 : Tmax
        R1(i) = D1(i) ./ C1(i);
        R2(i) = D2(i) ./ C2(i);
        R3(i) = D3(i) ./ C3(i);
        R4(i) = D4(i) ./ C4(i);
    end
    
    TT = 1: 1: Tmax;
    R1(isnan(R1)) = 0.001;
    R2(isnan(R2)) = 0.001;
    R3(isnan(R3)) = 0.001;
    R4(isnan(R4)) = 0.001;
    
    res1 = [C1(C1>5000); R1(C1>5000); TT(C1>5000)];
    res2 = [C2(C2>5000); R2(C2>5000); TT(C2>5000)];
    res3 = [C3(C3>5000); R3(C3>5000); TT(C3>5000)];
    res4 = [C4(C4>5000); R4(C4>5000); TT(C4>5000)];
    
    cnt = 1;
    for i = cnt : size(res1,2)
        if res1(1, i) - res1(1, cnt) >= 500
            cnt = cnt + 1;
            res1(:, cnt) = res1(:, i);
        end
    end
    res1 = res1(:, 1:cnt);
    
    
    cnt = 1;
    for i = cnt : size(res2,2)
        if res2(1, i) - res2(1, cnt) >= 500
            cnt = cnt + 1;
            res2(:, cnt) = res2(:, i);
        end
    end
    res2 = res2(:, 1:cnt);
    
    cnt = 1;
    for i = cnt : size(res3,2)
        if res3(1, i) - res3(1, cnt) >= 500
            cnt = cnt + 1;
            res3(:, cnt) = res3(:, i);
        end
    end
    res3 = res3(:, 1:cnt);
    
    cnt = 1;
    for i = cnt : size(res4,2)
        if res4(1, i) - res4(1, cnt) >= 500
            cnt = cnt + 1;
            res4(:, cnt) = res4(:, i);
        end
    end
    res4 = res4(:, 1:cnt);
    
    %%
    cnt = 0;
    R12 = zeros(4,numel(5000 : 500 : max(res1(1,:))));
    for Payload = 5000 : 500 : max(res1(1,:))
        Ratio = 100000;
        nls = unique(NL(:));
        t1 = 0; t2 = 0;
        for i = 1 : numel(nls)
            T1 = nls(i) + 1;
            ec1 = C1(T1);
            if ec1 > Payload
                break;
            end
            for j = i+1 : numel(nls)
                T2 = nls(j) + 1;
                ec2 = C2(T2)-C2(T1);
                if ec1 + ec2 > Payload
                    ed1 = D1(T1);
                    ed2 = D2(T2)-D2(T1);
                    ec = ec1 + ec2;
                    ed = ed1 + ed2;
                    ratio = ed/ec;
                    if Ratio > ratio
                        Ratio = ratio;
                        EC = ec;
                        ED = ed;
                        t1 = T1;
                        t2 = T2;
                    end
                    break;
                end
            end
        end
        cnt = cnt + 1;
        R12(:, cnt) = [EC, Ratio, t1, t2];
    end
    res12 = R12;
    
    cnt = 0;
    R21 = zeros(4,numel(5000 : 500 : max(res1(1,:))));
    for Payload = 5000 : 500 :  max(res1(1,:))
        Ratio = 100000;
        nls = unique(NL(:));
        t1 = 0; t2 = 0;
        for i = 1 : numel(nls)
            T1 = nls(i) + 1;
            ec2 = C2(T1);
            if ec2 > Payload
                break;
            end
            for j = i+1 : numel(nls)
                T2 = nls(j) + 1;
                ec1 = C1(T2)-C1(T1);
                if ec1 + ec2 > Payload
                    ed1 = D2(T1);
                    ed2 = D1(T2)-D1(T1);
                    ec = ec1 + ec2;
                    ed = ed1 + ed2;
                    ratio = ed/ec;
                    if Ratio > ratio
                        Ratio = ratio;
                        EC = ec;
                        ED = ed;
                        t1 = T1;
                        t2 = T2;
                    end
                    break;
                end
            end
        end
        cnt = cnt + 1;
        R21(:, cnt) = [EC, Ratio, t1, t2];
    end
    res21 = R21;
    %%
    MarkerSize = 3.5;
    LineWidth  = 1.7;
    LinsStyle  = ':o';
    
    h=figure('Name', Iname, 'pos', [10, 10, 500, 300]);
    plot(res3(1, :), res3(2, :), [LinsStyle, 'g'], ...
        'MarkerFaceColor', 'g', ...
        'MarkerSize', MarkerSize, ...
        'DisplayName', '\fontname{Times New Roman}{\itC}_{3}', ...
        'LineWidth', LineWidth);
    hold on;
    plot(res4(1, :), res4(2, :), [LinsStyle, 'c'], ...
        'MarkerFaceColor', 'c', ...
        'MarkerSize', MarkerSize, ...
        'DisplayName', '\fontname{Times New Roman}{\itC}_{4}', ...
        'LineWidth', LineWidth);
    hold on;
    plot(res1(1, :), res1(2, :), [LinsStyle,'b'], ...
        'MarkerFaceColor', 'b', ...
        'MarkerSize', MarkerSize, ...
        'DisplayName', '\fontname{Times New Roman}{\itC}_{1}', ...
        'LineWidth', LineWidth);
    
    hold on;
    plot(res2(1, :), res2(2, :), [LinsStyle, 'r'], ...
        'MarkerFaceColor', 'r', ...
        'MarkerSize', MarkerSize, ...
        'DisplayName', '\fontname{Times New Roman}{\itC}_{2}', ...
        'LineWidth', LineWidth);
    hold on;
    plot(res12(1, :), res12(2, :), [LinsStyle, 'm'], ...
        'MarkerFaceColor', 'm', ...
        'MarkerSize', MarkerSize, ...
        'DisplayName', '\fontname{Times New Roman}{\itC}_{12}', ...
        'LineWidth', LineWidth);
%     hold on;
%     plot(res21(1, :), res21(2, :), [LinsStyle, 'g'], ...
%         'MarkerFaceColor', 'g', ...
%         'MarkerSize', MarkerSize, ...
%         'DisplayName', '\fontname{Times New Roman}{\itC}_{21}', ...
%         'LineWidth', LineWidth);
    
    xs = min([res1(1, :) res2(1, :) res3(1, :) res4(1, :) res12(1, :)]);
    xe = max([res1(1, :) res2(1, :) res3(1, :) res4(1, :) res12(1, :)]);
    ys = min([res1(2, :) res2(2, :) res3(2, :) res4(2, :) res12(2, :)]);
    ye = max([res1(2, :) res2(2, :) res3(2, :) res4(2, :) res12(2, :)]);
    lg = legend('show');
    set(lg, 'FontSize', 14);
    xlabel('Embedding capacity (bits)');
    ylabel('Eval');
    axis([5000, xe+1000, ys, ye]);
    grid on;
    set(gca, 'GridLineStyle' ,':');
    set(gca, 'GridAlpha', 1);
    set(gca, 'box', 'on');
    set(gcf,'unit','normalized','position',[0.1,0.1,0.4,0.48]);
    axis normal;
    set(gca,'FontSize',14);
    title(Iname);
    %%
    res1 = [C1(C1>5000); R1(C1>5000); TT(C1>5000)];
    res2 = [C2(C2>5000); R2(C2>5000); TT(C2>5000)];
    res3 = [C3(C3>5000); R3(C3>5000); TT(C3>5000)];
    res4 = [C4(C4>5000); R4(C4>5000); TT(C4>5000)];
    MarkerSize = 3.5;
    LineWidth  = 1.7;
    LinsStyle  = ':o';
    
    h=figure('Name', Iname, 'pos', [10, 10, 500, 300]);
    plot(res1(3, :), res1(1, :), [LinsStyle,'b'], ...
        'MarkerFaceColor', 'b', ...
        'MarkerSize', MarkerSize, ...
        'DisplayName', '{\itC}_{1}', ...
        'LineWidth', LineWidth);
    
    hold on;
    plot(res2(3, :), res2(1, :), [LinsStyle, 'r'], ...
        'MarkerFaceColor', 'r', ...
        'MarkerSize', MarkerSize, ...
        'DisplayName', '{\itC}_{2}', ...
        'LineWidth', LineWidth);
    
    xs = min([res1(3, :) res2(3, :) res3(3, :) res4(3, :) res12(3, :)]);
    xe = 1000;
    ys = min([res1(1, :) res2(1, :) res3(1, :) res4(1, :) res12(1, :)]);
    ye = max([res1(1, :) res2(1, :) res3(1, :) res4(1, :) res12(1, :)]);
    lg = legend('show');
    set(lg, 'FontSize', 14);
    xlabel('Threshold');
    ylabel('Capacity');
    axis([xs, xe, ys, ye]);
    grid on;
    set(gca, 'GridLineStyle' ,':');
    set(gca, 'GridAlpha', 1);
    set(gca, 'box', 'on');
    set(gcf,'unit','normalized','position',[0.1,0.1,0.4,0.48]);
    axis normal;
    set(gca,'FontSize',14);
    title(Iname);
    %%
%     res1 = [C1(C1>5000); R1(C1>5000); TT(C1>5000)];
    MarkerSize = 3.7;
    LineWidth  = 1.1;
    LinsStyle  = '-o';
    
    h=figure('Name', Iname, 'pos', [10, 10, 500, 300]);
    plot(res12(3, :), res12(4, :), [LinsStyle,'k'], ...
        'MarkerFaceColor', 'k', ...
        'MarkerSize', MarkerSize, ...
        'DisplayName', '{\itC}_{12}', ...
        'LineWidth', LineWidth);
    
    xs = min([res12(3, :)]);
    xe = max([res12(3, :)]);
    ys = min([res12(4, :)]);
    ye = max([res12(4, :)]);
    lg = legend('show');
    set(lg, 'FontSize', 14);
    xlabel('\fontname{Times New Roman}Threshold {\itT}_{1}');
    ylabel('\fontname{Times New Roman}Threshold {\itT}_{2}');
    axis([xs-20, xe+50, ys-100, ye+100]);
    grid on;
    set(gca, 'GridLineStyle' ,':');
    set(gca, 'GridAlpha', 1);
    set(gca, 'box', 'on');
    set(gcf,'unit','normalized','position',[0.1,0.1,0.4,0.48]);
    axis normal;
    set(gca,'FontSize',14);
    title(Iname);
end
