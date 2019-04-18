%%
% Extended PPVO - Original PPVO
% NL : max(C) - min(C) (C针对各自的Context Pixels)
% 像素个数，都是8个

clc;clear;
addpath(genpath('Origin Images')); addpath(genpath('result')); addpath(genpath('tools'));

mask1 = [false, true, true;
    true, true,  false;
    true, false, false];
mask2 = [false, false, true, true;
    true, true, true,  false;
    true, true, false, false];
mask3 = [false, false, false, true, true;
         true,  true, true, true,  false;
         false, true, true, false, false];


Imgs = {'Lena', 'Baboon', 'Airplane', 'Barbara', 'Lake', 'Peppers', 'Boat', 'Elaine'};

%%
tt = 2;
Iname = Imgs{tt};
istr = ['ShowHist_',Iname,'.mat'];
fprintf('%s\n', istr);
Io = double(imread([Iname,'.bmp']));

[AuxLM, I] = LocationMap(Io);
[A, B] = size(I);
Tmax = 3000;

%% IPPVO Hist
H1 = cell(1,Tmax);
Hmax = cell(1,Tmax);
for i = 1 : Tmax
    H1{i} = zeros(1,512);
    Hmax{i} = zeros(1,512);
end

NL = zeros(A-2,B-2);
for i = 1:(A-2)
    for j = 1:(B-2)
        % 2x2 block
        if j == 1
            X = I(i:i+2,j:j+2);
            X = X(mask1);
        end
        
        if j == 2
            X = I(i:i+2,j-1:j+2);
            X = X(mask2);
        end
        
        if j >= 3
            X = I(i:i+2,j-2:j+2);
            X = X(mask3);
        end
        NL(i,j) = max(X) - min(X);
        T = NL(i,j);
        [Y, ~] = sort(X);
        if Y(end) ~= Y(1)
            % dmax
            if I(i,j) >= Y(end)
                dmax = I(i,j) - Y(end); % >= 0
                H1{T+1}(dmax+256) = H1{T+1}(dmax+256) + 1;
                Hmax{T+1}(dmax+1) = Hmax{T+1}(dmax+1) + 1;
            end
            % dmin
            if I(i,j) <= Y(1)
%                 dmin = Y(1) - I(i,j); % >= 0
                dmin = I(i,j) - Y(1); % >= 0
                H1{T+1}(dmin+256) = H1{T+1}(dmin+256) + 1;
            end
        else % Y(end) == Y(1)
            if Y(end) == 254
                if I(i,j) == 254
                    dmin = I(i,j) - Y(end);
                    H1{T+1}(dmin+256) = H1{T+1}(dmin+256) + 1;
                end
            else
                if I(i,j) <= Y(end)
                    dmin = I(i,j) - Y(1); % >= 0
                    H1{T+1}(dmin+256) = H1{T+1}(dmin+256) + 1;
                else % I(i,j) > Y(end)
                    dmax = I(i,j) - Y(1); % >= 0
%                     dmax = I(i,j) - Y(1) - 1; % >= 0
                    H1{T+1}(dmax+256) = H1{T+1}(dmax+256) + 1;
                end
            end
        end
    end
end

%% PPVO Hist
h1 = cell(1,Tmax);
hmax = cell(1,Tmax);
for i = 1 : Tmax
    h1{i} = zeros(1,512);
    hmax{i} = zeros(1,512);
end

NL2 = zeros(A-2,B-2);
for i = 1:(A-2)
    for j = 1:(B-2)       
        % 2x2 block
        X = I(i:i+2,j:j+2);
        X = X(2:end);
        NL2(i,j) = max(X) - min(X);
        T = NL2(i,j);
        [Y, ~] = sort(X);
        if Y(end) ~= Y(1)
            % dmax
            if I(i,j) >= Y(end)
                dmax = I(i,j) - Y(end); % >= 0
                h1{T+1}(dmax+256) = h1{T+1}(dmax+256) + 1;
                hmax{T+1}(dmax+1) = hmax{T+1}(dmax+1) + 1;
            end
            % dmin
            if I(i,j) <= Y(1)
%                 dmin = Y(1) - I(i,j); % >= 0
                dmin = I(i,j) - Y(1); % >= 0
                h1{T+1}(dmin+256) = h1{T+1}(dmin+256) + 1;
            end
        else % Y(end) == Y(1)
            if Y(end) == 254
                if I(i,j) == 254
                    dmin = I(i,j) - Y(end);
                    h1{T+1}(dmin+256) = h1{T+1}(dmin+256) + 1;
                end
            else
                if I(i,j) <= Y(end)
%                     dmin = Y(1) - I(i,j); % >= 0
                    dmin = I(i,j) - Y(1); % >= 0
                    h1{T+1}(dmin+256) = h1{T+1}(dmin+256) + 1;
                end
            end
        end
    end
end

%%
C1 = zeros(1,Tmax); C1(1) = H1{1}(1);
D1 = zeros(1,Tmax); D1(1) = sum(H1{1}(1:end)) - 0.5*H1{1}(256);
c1 = zeros(1,Tmax); c1(1) = h1{1}(1);
d1 = zeros(1,Tmax); d1(1) = sum(h1{1}(1:end)) - 0.5*h1{1}(256);
Cmax = zeros(1,Tmax); Cmax(1) = H1{1}(1);
Dmax = zeros(1,Tmax); Dmax(1) = sum(Hmax{1}(1:end)) - 0.5*Hmax{1}(256);
cmax = zeros(1,Tmax); cmax(1) = hmax{1}(1);
dmax = zeros(1,Tmax); dmax(1) = sum(hmax{1}(1:end)) - 0.5*hmax{1}(256);
for i = 2 : 1 : Tmax
    H1{i} = H1{i} + H1{i-1};
    C1(i) = H1{i}(1);
%     D1(i) = 0.5*H1{i}(1) + sum(H1{i}(2:end));
    D1(i) = sum(H1{i}(1:end)) - 0.5*H1{i}(256);
    
    h1{i} = h1{i} + h1{i-1};
    c1(i) = h1{i}(1);
%     d1(i) = 0.5*h1{i}(1) + sum(h1{i}(2:end));
    d1(i) = sum(h1{i}(1:end)) - 0.5*h1{i}(256);
    
    Hmax{i} = Hmax{i} + Hmax{i-1};
    Cmax(i) = Hmax{i}(1);
%     D1(i) = 0.5*H1{i}(1) + sum(H1{i}(2:end));
    Dmax(i) = sum(Hmax{i}(1:end)) - 0.5*Hmax{i}(256);
    
    hmax{i} = hmax{i} + hmax{i-1};
    cmax(i) = hmax{i}(1);
%     d1(i) = 0.5*h1{i}(1) + sum(h1{i}(2:end));
    dmax(i) = sum(hmax{i}(1:end)) - 0.5*hmax{i}(256);
end


%% Context Pixels of Distance Equal to 1
% i = 1;
% EC = 10000;
% Idx = find(C1(:) >= EC, 1 );
% idx = find(c1(:) >= EC, 1 );
% if isempty(Idx) || isempty(idx)
%     fprintf("Image %s's Capacity less than %d with size of %d\n", Iname, EC, i);
% else
%     Histi = H1{Idx};
%     histi = h1{idx};
% 
%     f = figure('Name',Iname);
%     bar([Histi',histi']);
%     axis([0 10 0 (max([Histi,histi]))+1000]);
%     legend(['Extended PPVO: NL< ' num2str(Idx)],['PPVO: NL< ' num2str(idx)]);
%     xlabel('bin');
%     ylabel('Freq');
%     title([Iname ' EC = ' num2str(EC) 'bits;']);
% end
% 
% % EC = 20000
% EC = 20000;
% Idx = find(C1(:) >= EC, 1 );
% idx = find(c1(:) >= EC, 1 );
% if isempty(Idx) || isempty(idx)
%     fprintf("Image %s's Capacity less than %d with size of %d\n", Iname, EC, i);
% else
%     Histi = H1{Idx};
%     histi = h1{idx};
% 
%     f = figure('Name',Iname);
%     bar([Histi',histi']);
%     axis([0 10 0 (max([Histi,histi]))+1000]);
%     legend(['Extended PPVO: NL< ' num2str(Idx)],['PPVO: NL< ' num2str(idx)]);
%     xlabel('bin');
%     ylabel('Freq');
%     title([Iname ' EC = ' num2str(EC) 'bits;']);
% end
    
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
%     axis([0 10.5 0 maxR+(maxR*0.1)]);
    axis([-10.5+256 10.5+256 0 maxR+(maxR*0.1)]);
%     set(gca,'xticklabel',{' ','0','1','2','3','4','5','6','7','8','9','10'});
    set(gca,'xticklabel',-10:1:10);
    legend(['Extended PPVO'],['PPVO']);
    xlabel('\fontname{Times New Roman}\fontsize{15}\itp');
%     ylabel('Freq');
%     title([Iname  'Context Pixel Dist: ' num2str(i)]);
    title(Iname);
end

% 总的ED/EC
Ratio = (D1(end)-C1(end)*0.5) / (D1(end)+C1(end)*0.5);
ratio = (d1(end)-c1(end)*0.5) / (d1(end)+c1(end)*0.5);
[Ratio ratio]


%%
%% 归一化直方图
i=1;
Idx = numel(Cmax);
idx = numel(cmax);
if isempty(Idx) || isempty(idx)
    fprintf("Image %s's Capacity less than %d with size of %d\n", Iname, EC, i);
else
    Histi = Hmax{Idx};
    histi = hmax{idx};
    
    Histi = Histi./sum(Histi);
    histi = histi./sum(histi);
    
    maxR = max([Histi,histi]);

    f = figure('Name',Iname);
    bar([Histi',histi']);
%     axis([0 10.5 0 maxR+(maxR*0.1)]);
    axis([0  20.5 0 maxR+(maxR*0.1)]);
%     set(gca,'xticklabel',{' ','0','1','2','3','4','5','6','7','8','9','10'});
    set(gca,'xticklabel',0:1:20);
    legend(['Proposed'],['PPVO']);
    xlabel('\fontname{Times New Roman}\fontsize{15}\ite');
    ylabel('\fontname{Times New Roman}\fontsize{15}\itP');
    title(Iname);
end

R  = sum(Histi(2:end))/sum(Histi(1:end))
r  = sum(histi(2:end))/sum(histi(1:end))

% 总的ED/EC
Ratio = (D1(end)-C1(end)*0.5) / (D1(end)+C1(end)*0.5);
ratio = (d1(end)-c1(end)*0.5) / (d1(end)+c1(end)*0.5);
[Ratio ratio]
