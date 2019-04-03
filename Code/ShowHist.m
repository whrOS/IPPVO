clc;clear;
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
tt = 1;
Iname = Imgs{tt};
istr = ['ShowHist',Iname,'.mat'];
fprintf('%s\n', istr);
Io = double(imread([Iname,'.bmp']));

[AuxLM, I] = LocationMap(Io);
[A, B] = size(I);
Tmax = 3000;

%% IPPVO Hist
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
        [Y, ~] = sort(X);
        if Y(end) ~= Y(1)
            % dmax
            if I(i,j) >= Y(end)
                dmax = I(i,j) - Y(end); % >= 0
                H1{T+1}(dmax+1) = H1{T+1}(dmax+1) + 1;
            end
            % dmin
            if I(i,j) <= Y(1)
                dmin = Y(1) - I(i,j); % >= 0
                H1{T+1}(dmin+1) = H1{T+1}(dmin+1) + 1;
            end
        else % Y(end) == Y(1)
            if Y(end) == 254
                if I(i,j) == 254
                    dmin = I(i,j) - Y(end);
                    H1{T+1}(dmin+1) = H1{T+1}(dmin+1) + 1;
                end
            else
                if I(i,j) <= Y(end)
                    dmin = Y(1) - I(i,j); % >= 0
                    H1{T+1}(dmin+1) = H1{T+1}(dmin+1) + 1;
                else % I(i,j) > Y(end)
                    dmax = I(i,j) - Y(1) - 1; % >= 0
                    H1{T+1}(dmax+1) = H1{T+1}(dmax+1) + 1;
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
        [Y, ~] = sort(X);
        if Y(end) ~= Y(1)
            % dmax
            if I(i,j) >= Y(end)
                dmax = I(i,j) - Y(end); % >= 0
                H2{T+1}(dmax+1) = H2{T+1}(dmax+1) + 1;
            end
            % dmin
            if I(i,j) <= Y(1)
                dmin = Y(1) - I(i,j); % >= 0
                H2{T+1}(dmin+1) = H2{T+1}(dmin+1) + 1;
            end
        else % Y(end) == Y(1)
            if Y(end) == 254
                if I(i,j) == 254
                    dmin = I(i,j) - Y(end);
                    H2{T+1}(dmin+1) = H2{T+1}(dmin+1) + 1;
                end
            else
                if I(i,j) <= Y(end)
                    dmin = Y(1) - I(i,j); % >= 0
                    H2{T+1}(dmin+1) = H2{T+1}(dmin+1) + 1;
                else % I(i,j) > Y(end)
                    dmax = I(i,j) - Y(1) - 1; % >= 0
                    H2{T+1}(dmax+1) = H2{T+1}(dmax+1) + 1;
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
        [Y, ~] = sort(X);
        if Y(end) ~= Y(1)
            % dmax
            if I(i,j) >= Y(end)
                dmax = I(i,j) - Y(end); % >= 0
                H3{T+1}(dmax+1) = H3{T+1}(dmax+1) + 1;
            end
            % dmin
            if I(i,j) <= Y(1)
                dmin = Y(1) - I(i,j); % >= 0
                H3{T+1}(dmin+1) = H3{T+1}(dmin+1) + 1;
            end
        else % Y(end) == Y(1)
            if Y(end) == 254
                if I(i,j) == 254
                    dmin = I(i,j) - Y(end);
                    H3{T+1}(dmin+1) = H3{T+1}(dmin+1) + 1;
                end
            else
                if I(i,j) <= Y(end)
                    dmin = Y(1) - I(i,j); % >= 0
                    H3{T+1}(dmin+1) = H3{T+1}(dmin+1) + 1;
                else % I(i,j) > Y(end)
                    dmax = I(i,j) - Y(1) - 1; % >= 0
                    H3{T+1}(dmax+1) = H3{T+1}(dmax+1) + 1;
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
            end
            % dmin
            if I(i,j) <= Y(1)
                dmin = Y(1) - I(i,j); % >= 0
                H4{T+1}(dmin+1) = H4{T+1}(dmin+1) + 1;
            end
        else % Y(end) == Y(1)
            if Y(end) == 254
                if I(i,j) == 254
                    dmin = I(i,j) - Y(end);
                    H4{T+1}(dmin+1) = H4{T+1}(dmin+1) + 1;
                end
            else
                if I(i,j) <= Y(end)
                    dmin = Y(1) - I(i,j); % >= 0
                    H4{T+1}(dmin+1) = H4{T+1}(dmin+1) + 1;
                else % I(i,j) > Y(end)
                    dmax = I(i,j) - Y(1) - 1; % >= 0
                    H4{T+1}(dmax+1) = H4{T+1}(dmax+1) + 1;
                end
            end
        end
        
    end
end

%% PPVO Hist
h1 = cell(1,Tmax);
h2 = cell(1,Tmax);
h3 = cell(1,Tmax);
h4 = cell(1,Tmax);
h = cell(1,Tmax);
for i = 1 : Tmax
    h1{i} = zeros(1,256);
    h2{i} = zeros(1,256);
    h3{i} = zeros(1,256);
    h4{i} = zeros(1,256);
    h{i} = zeros(1,512);
end

NL = zeros(A-3,B-3);
for i = 1:(A-3)
    for j = 1:(B-3)
        %                 [i,j]
        for ii = 1:3
            for jj = 1:4
                if ii == 2 || ii == 3 || jj == 2 ||  jj == 3 || jj == 4
                    if 1*(j-1)+jj > 0
                        NL(i,j) = NL(i,j) + abs(I(1*(i-1)+ii,1*(j-1)+jj) - I(1*(i-1)+ii+1,1*(j-1)+jj));
                    end
                end
            end
        end
        for ii = 1:4
            for jj = 1:3
                if ii == 2 || ii == 3 || ii == 4 || jj == 2 ||  jj == 3
                    if 1*(j-1)+jj > 0
                        NL(i,j) = NL(i,j) + abs(I(1*(i-1)+ii,1*(j-1)+jj) - I(1*(i-1)+ii,1*(j-1)+jj+1));
                    end
                end
            end
        end
        T = NL(i,j);
        
        % 2x2 block
        X = I(i:i+1,j:j+1);
        X = X(2:end);
        [Y, ~] = sort(X);
        if Y(end) ~= Y(1)
            % dmax
            if I(i,j) >= Y(end)
                dmax = I(i,j) - Y(end); % >= 0
                h1{T+1}(dmax+1) = h1{T+1}(dmax+1) + 1;
            end
            % dmin
            if I(i,j) <= Y(1)
                dmin = Y(1) - I(i,j); % >= 0
                h1{T+1}(dmin+1) = h1{T+1}(dmin+1) + 1;
            end
        else % Y(end) == Y(1)
            if Y(end) == 254
                if I(i,j) == 254
                    dmin = I(i,j) - Y(end);
                    h1{T+1}(dmin+1) = h1{T+1}(dmin+1) + 1;
                end
            else
                if I(i,j) <= Y(end)
                    dmin = Y(1) - I(i,j); % >= 0
                    h1{T+1}(dmin+1) = h1{T+1}(dmin+1) + 1;
                else % I(i,j) > Y(end)
                    dmax = I(i,j) - Y(1) - 1; % >= 0
                    h1{T+1}(dmax+1) = h1{T+1}(dmax+1) + 1;
                end
            end
        end
        
        % 3x3 block
        X = I(i:i+2,j:j+2);
        X = X(2:end);
        [Y, ~] = sort(X);
        if Y(end) ~= Y(1)
            % dmax
            if I(i,j) >= Y(end)
                dmax = I(i,j) - Y(end); % >= 0
                h2{T+1}(dmax+1) = h2{T+1}(dmax+1) + 1;
            end
            % dmin
            if I(i,j) <= Y(1)
                dmin = Y(1) - I(i,j); % >= 0
                h2{T+1}(dmin+1) = h2{T+1}(dmin+1) + 1;
            end
        else % Y(end) == Y(1)
            if Y(end) == 254
                if I(i,j) == 254
                    dmin = I(i,j) - Y(end);
                    h2{T+1}(dmin+1) = h2{T+1}(dmin+1) + 1;
                end
            else
                if I(i,j) <= Y(end)
                    dmin = Y(1) - I(i,j); % >= 0
                    h2{T+1}(dmin+1) = h2{T+1}(dmin+1) + 1;
                else % I(i,j) > Y(end)
                    dmax = I(i,j) - Y(1) - 1; % >= 0
                    h2{T+1}(dmax+1) = h2{T+1}(dmax+1) + 1;
                end
            end
        end
        
        % 4x4 block
        X = I(i:i+3,j:j+3);
        X = X(2:end);
        [Y, ~] = sort(X);
        if Y(end) ~= Y(1)
            % dmax
            if I(i,j) >= Y(end)
                dmax = I(i,j) - Y(end); % >= 0
                h3{T+1}(dmax+1) = h3{T+1}(dmax+1) + 1;
            end
            % dmin
            if I(i,j) <= Y(1)
                dmin = Y(1) - I(i,j); % >= 0
                h3{T+1}(dmin+1) = h3{T+1}(dmin+1) + 1;
            end
        else % Y(end) == Y(1)
            if Y(end) == 254
                if I(i,j) == 254
                    dmin = I(i,j) - Y(end);
                    h3{T+1}(dmin+1) = h3{T+1}(dmin+1) + 1;
                end
            else
                if I(i,j) <= Y(end)
                    dmin = Y(1) - I(i,j); % >= 0
                    h3{T+1}(dmin+1) = h3{T+1}(dmin+1) + 1;
                else % I(i,j) > Y(end)
                    dmax = I(i,j) - Y(1) - 1; % >= 0
                    h3{T+1}(dmax+1) = h3{T+1}(dmax+1) + 1;
                end
            end
        end
        
        % 5x5 block
        X = I(i:i+3,j:j+3);
        X = X(2:end);
        [Y, In] = sort(X);
        if Y(end) ~= Y(1)
            % dmax
            if I(i,j) >= Y(end)
                dmax = I(i,j) - Y(end); % >= 0
                h4{T+1}(dmax+1) = h4{T+1}(dmax+1) + 1;
                h{T+1}(dmax+256) = h{T+1}(dmax+256) + 1;
            end
            % dmin
            if I(i,j) <= Y(1)
                dmin = Y(1) - I(i,j); % >= 0
                h4{T+1}(dmin+1) = h4{T+1}(dmin+1) + 1;
                dmin = I(i,j) - Y(1); % >= 0
                h{T+1}(dmin+256) = h{T+1}(dmin+256) + 1;
            end
        else % Y(end) == Y(1)
            if Y(end) == 254
                if I(i,j) == 254
                    dmin = I(i,j) - Y(end);
                    h4{T+1}(dmin+1) = h4{T+1}(dmin+1) + 1;
                    h{T+1}(dmin+256) = h{T+1}(dmin+256) + 1;
                end
            else
                if I(i,j) <= Y(end)
                    dmin = Y(1) - I(i,j); % >= 0
                    h4{T+1}(dmin+1) = h4{T+1}(dmin+1) + 1;
                    dmax = I(i,j) - Y(1);
                    h{T+1}(dmin+256) = h{T+1}(dmin+256) + 1;
                else % I(i,j) > Y(end)
                    dmax = I(i,j) - Y(1) - 1; % >= 0
                    h4{T+1}(dmax+1) = h4{T+1}(dmax+1) + 1;
                    dmax = I(i,j) - Y(1);
                    h{T+1}(dmin+256) = h{T+1}(dmin+256) + 1;
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
c1 = zeros(1,Tmax); c1(1) = h1{1}(1);
c2 = zeros(1,Tmax); c2(1) = h2{1}(1);
c3 = zeros(1,Tmax); c3(1) = h3{1}(1);
c4 = zeros(1,Tmax); c4(1) = h4{1}(1);
d1 = zeros(1,Tmax); d1(1) = 0.5*h1{1}(1) + sum(h1{1}(2:end));
d2 = zeros(1,Tmax); d2(1) = 0.5*h2{1}(1) + sum(h2{1}(2:end));
d3 = zeros(1,Tmax); d3(1) = 0.5*h3{1}(1) + sum(h3{1}(2:end));
d4 = zeros(1,Tmax); d4(1) = 0.5*h4{1}(1) + sum(h4{1}(2:end));
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
    
    h1{i} = h1{i} + h1{i-1};
    h2{i} = h2{i} + h2{i-1};
    h3{i} = h3{i} + h3{i-1};
    h4{i} = h4{i} + h4{i-1};
    c1(i) = h1{i}(1);
    c2(i) = h2{i}(1);
    c3(i) = h3{i}(1);
    c4(i) = h4{i}(1);
    d1(i) = 0.5*h1{i}(1) + sum(h1{i}(2:end));
    d2(i) = 0.5*h2{i}(1) + sum(h2{i}(2:end));
    d3(i) = 0.5*h3{i}(1) + sum(h3{i}(2:end));
    d4(i) = 0.5*h4{i}(1) + sum(h4{i}(2:end));
    
    h{i} = h{i} + h{i-1};
end
%%
bar(h{end})
set(gca,'xticklabel',{'-11','-10','-9','-8','-7','-6','-5','-4','-3','-2','-1','0','1','2','3','4','5','6','7','8','9','10'});

%% 2.2图示
i=4;
Idx = numel(C1);
idx = numel(c1);
if isempty(Idx) || isempty(idx)
    fprintf("Image %s's Capacity less than %d with size of %d\n", Iname, EC, i);
else
    histi = h4{idx};
    
    maxR = max([histi]);

    f = figure('Name',Iname);
    bar([histi']);
    axis([0 10.5 0 maxR+1000]);
    set(gca,'xticklabel',{' ','0','1','2','3','4','5','6','7','8','9','10'});
    xlabel('{\itp}', 'FontSize', 16);
    ylabel('Occurrence', 'FontSize', 16);
    
%     set(gca,'fontsize',16);
%     title([Iname  'Context Pixel Dist: ' num2str(i)]);
end

%% Context Pixels of Distance Equal to 1
i = 1;
% EC = 10000
EC = 10000;
Idx = find(C1(:) >= EC, 1 );
idx = find(c1(:) >= EC, 1 );
if isempty(Idx) || isempty(idx)
    fprintf("Image %s's Capacity less than %d with size of %d\n", Iname, EC, i);
else
    Histi = H1{Idx};
    histi = h1{idx};

    f = figure('Name',Iname);
    bar([Histi',histi']);
    axis([0 10 0 EC+1000]);
    legend(['Extended PPVO: NL< ' num2str(Idx)],['PPVO: NL< ' num2str(idx)]);
    xlabel('bin');
    ylabel('Freq');
    title([Iname ' EC = ' num2str(EC) 'bits; ' 'Context Pixel Dist: ' num2str(i)]);
end

% EC = 20000
EC = 20000;
Idx = find(C1(:) >= EC, 1 );
idx = find(c1(:) >= EC, 1 );
if isempty(Idx) || isempty(idx)
    fprintf("Image %s's Capacity less than %d with size of %d\n", Iname, EC, i);
else
    Histi = H1{Idx};
    histi = h1{idx};

    f = figure('Name',Iname);
    bar([Histi',histi']);
    axis([0 10 0 EC+1000]);
    legend(['Extended PPVO: NL< ' num2str(Idx)],['PPVO: NL< ' num2str(idx)]);
    xlabel('bin');
    ylabel('Freq');
    title([Iname ' EC = ' num2str(EC) 'bits; ' 'Context Pixel Dist: ' num2str(i)]);
end
    
%% Context Pixels of Distance Equal to 2
i = 2;
% EC = 10000
EC = 10000;
Idx = find(C2(:) >= EC, 1 );
idx = find(c2(:) >= EC, 1 );
if isempty(Idx) || isempty(idx)
    fprintf("Image %s's Capacity less than %d with size of %d\n", Iname, EC, i);
else
    Histi = H2{Idx};
    histi = h2{idx};

    f = figure('Name',Iname);
    bar([Histi',histi']);
    axis([0 10 0 EC+1000]);
    legend(['Extended PPVO: NL< ' num2str(Idx)],['PPVO: NL< ' num2str(idx)]);
    xlabel('bin');
    ylabel('Freq');
    title([Iname ' EC = ' num2str(EC) 'bits; ' 'Context Pixel Dist: ' num2str(i)]);
end

% EC = 20000
EC = 20000;
Idx = find(C2(:) >= EC, 1 );
idx = find(c2(:) >= EC, 1 );
if isempty(Idx) || isempty(idx)
    fprintf("Image %s's Capacity less than %d with size of %d\n", Iname, EC, i);
else
    Histi = H2{Idx};
    histi = h2{idx};

    f = figure('Name',Iname);
    bar([Histi',histi']);
    axis([0 10 0 EC+1000]);
    legend(['Extended PPVO: NL< ' num2str(Idx)],['PPVO: NL< ' num2str(idx)]);
    xlabel('bin');
    ylabel('Freq');
    title([Iname ' EC = ' num2str(EC) 'bits; ' 'Context Pixel Dist: ' num2str(i)]);
end

%% Context Pixels of Distance Equal to 3
i = 3;
% EC = 10000
EC = 10000;
Idx = find(C3(:) >= EC, 1 );
idx = find(c3(:) >= EC, 1 );
if isempty(Idx) || isempty(idx)
    fprintf("Image %s's Capacity less than %d with size of %d\n", Iname, EC, i);
else
    Histi = H3{Idx};
    histi = h3{idx};

    f = figure('Name',Iname);
    bar([Histi',histi']);
    axis([0 10 0 EC+1000]);
    legend(['Extended PPVO: NL< ' num2str(Idx)],['PPVO: NL< ' num2str(idx)]);
    xlabel('bin');
    ylabel('Freq');
    title([Iname ' EC = ' num2str(EC) 'bits; ' 'Context Pixel Dist: ' num2str(i)]);
end

% EC = 20000
EC = 20000;
Idx = find(C3(:) >= EC, 1 );
idx = find(c3(:) >= EC, 1 );
if isempty(Idx) || isempty(idx)
    fprintf("Image %s's Capacity less than %d with size of %d\n", Iname, EC, i);
else
    Histi = H3{Idx};
    histi = h3{idx};

    f = figure('Name',Iname);
    bar([Histi',histi']);
    axis([0 10 0 EC+1000]);
    legend(['Extended PPVO: NL< ' num2str(Idx)],['PPVO: NL< ' num2str(idx)]);
    xlabel('bin');
    ylabel('Freq');
    title([Iname ' EC = ' num2str(EC) 'bits; ' 'Context Pixel Dist: ' num2str(i)]);
end

%% Context Pixels of Distance Equal to 4
i = 4;
% EC = 10000
EC = 10000;
Idx = find(C4(:) >= EC, 1 );
idx = find(c4(:) >= EC, 1 );
if isempty(Idx) || isempty(idx)
    fprintf("Image %s's Capacity less than %d with size of %d\n", Iname, EC, i);
else
    Histi = H4{Idx};
    histi = h4{idx};

    f = figure('Name',Iname);
    bar([Histi',histi']);
    axis([0 10 0 EC+1000]);
    legend(['Extended PPVO: NL< ' num2str(Idx)],['PPVO: NL< ' num2str(idx)]);
    xlabel('bin');
    ylabel('Freq');
    title([Iname ' EC = ' num2str(EC) 'bits; ' 'Context Pixel Dist: ' num2str(i)]);
end

% EC = 20000
EC = 20000;
Idx = find(C4(:) >= EC, 1 );
idx = find(c4(:) >= EC, 1 );
if isempty(Idx) || isempty(idx)
    fprintf("Image %s's Capacity less than %d with size of %d\n", Iname, EC, i);
else
    Histi = H4{Idx};
    histi = h4{idx};

    f = figure('Name',Iname);
    bar([Histi',histi']);
    axis([0 10 0 EC+1000]);
    legend(['Extended PPVO: NL< ' num2str(Idx)],['PPVO: NL< ' num2str(idx)]);
    xlabel('bin');
    ylabel('Freq');
    title([Iname ' EC = ' num2str(EC) 'bits; ' 'Context Pixel Dist: ' num2str(i)]);
end


%% 归一化直方图
i=1;
Idx = numel(C1);
idx = numel(c1);
if isempty(Idx) || isempty(idx)
    fprintf("Image %s's Capacity less than %d with size of %d\n", Iname, EC, i);
else
    Histi = H1{Idx};
    histi = h1{idx};
    
    Histi = Histi./sum(Histi);
    histi = histi./sum(histi);
    
    maxR = max([Histi,histi]);

    f = figure('Name',Iname);
    bar([Histi',histi']);
    axis([0 10.5 0 maxR+0.1]);
    legend(['Extended PPVO'],['PPVO']);
    xlabel('bin');
    ylabel('Freq');
    title([Iname  'Context Pixel Dist: ' num2str(i)]);
end