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

Imgs = {'Lena', 'Baboon', 'Airplane', 'Barbara', 'Lake', 'Peppers', 'Boat', 'Elaine'};
Tmax = 2048;
%%
for tt = 1:1:1
    Iname = Imgs{tt};
    istr = ['Proposed_2019_',Iname,'.mat']
    res12 = load(['3/' istr]); res12 = res12.res;
    Io = double(imread([Iname,'.bmp']));
    
    [AuxLM, I] = LocationMap(Io);
    [A, B] = size(I);
    %%
    EdgInfo = 18+18+8+16+AuxLM; % Lclm CN kend T LM
    a = 3; b = 3;
    R = zeros(4,1000);
    cnt = 0;
    for Payload = 5000+EdgInfo:1000:100000+EdgInfo
        tic
        %         Payload
        %%
        H1 = cell(1,Tmax);
        H2 = cell(1,Tmax);
        for i = 1 : Tmax
            H1{i} = zeros(1,256);
            H2{i} = zeros(1,256);
        end
        
        EC1 = zeros(A-2,B-2);
        EC2 = zeros(A-2,B-2);
        ED1 = zeros(A-2,B-2);
        ED2 = zeros(A-2,B-2);
        NL = zeros(A-2,B-2);
        for i = 1:(A-2)
            for j = 1:(B-2)
                %                 [i,j]
                for ii = 1:2
                    for jj = -1:3
                        if ii == 2 || jj == 2 || jj == 3
                            if 1*(j-1)+jj > 0 && ~((ii == 2 && jj == 3) || (ii == 2 && jj == -1))
                                %                                 [1*(i-1)+ii,1*(j-1)+jj, 1*(i-1)+ii+1,1*(j-1)+jj]
                                NL(i,j) = NL(i,j) + abs(I(1*(i-1)+ii,1*(j-1)+jj) - I(1*(i-1)+ii+1,1*(j-1)+jj));
                            end
                        end
                    end
                end
                for ii = 1:3
                    for jj = -1:2
                        if ii == 2 || ii == 3 || jj == 2
                            if 1*(j-1)+jj > 0 && ~((ii == 3 && jj == 2) || (ii == 3 && jj == -1))
                                %                                 [1*(i-1)+ii,1*(j-1)+jj, 1*(i-1)+ii,1*(j-1)+jj+1]
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
                if j >= 3
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
                            dmin = Y(1) - I(i,j); % >= 0
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
            end
        end
        
        C1 = zeros(1,Tmax); C1(1) = H1{1}(1);
        C2 = zeros(1,Tmax); C2(1) = H2{1}(1);
        D1 = zeros(1,Tmax); D1(1) = 0.5*H1{1}(1) + sum(H1{1}(2:end));
        D2 = zeros(1,Tmax); D2(1) = 0.5*H2{1}(1) + sum(H2{1}(2:end));
        
        for i = 2 : 1 : Tmax
            H1{i} = H1{i} + H1{i-1};
            H2{i} = H2{i} + H2{i-1};
            C1(i) = H1{i}(1);
            C2(i) = H2{i}(1);
            D1(i) = 0.5*H1{i}(1) + sum(H1{i}(2:end));
            D2(i) = 0.5*H2{i}(1) + sum(H2{i}(2:end));
        end
        
        Ratio = 100000;
        nls = unique(NL(:));
        t1 = 0;
        for i = 1 : numel(nls)
            T1 = nls(i) + 1;
            ec = C2(T1);
            if ec > Payload
                ed = D2(T1);
                ratio = ed/ec;
                if Ratio > ratio
                    Ratio = ratio;
                    EC = ec;
                    ED = ed;
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
        for i = 1:(A-2)
            if flag == 1
                break;
            end
            for j = 1:(B-2)
                if NL(i,j) < t1
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
        cnt = cnt + 1;
        R(:,cnt) = [Payload-EdgInfo, PSNR, EdgInfo, t1];
        [Payload PSNR toc]
    end
    res = R(:,1:cnt);
    
    h=figure('Name', Iname, 'pos', [10, 10, 500, 300]);
    plot(res(1, :), res(2, :), ['-o','m'], ...
        'MarkerFaceColor', 'm', ...
        'MarkerSize', 3.5, ...
        'DisplayName', 'Only 2', ...
        'LineWidth', 1.7);

    hold on;
    plot(res12(1, :), res12(2, :), ['-o', 'b'], ...
        'MarkerFaceColor', 'b', ...
        'MarkerSize', 3.5, ...
        'DisplayName', 'MHM 12', ...
        'LineWidth', 1.7);    
    xs = min(res12(1, :));
    EC = max(res12(1, :));
    xe = max(res12(1, :));
    cc = sum(res12(1, :)<=EC);
    ys = min(res12(2, :));
    ye = max(res12(2, :));
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
end
