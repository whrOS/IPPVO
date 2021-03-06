clc;
clear all;

Imgs = {'Lena', 'Baboon', 'Barbara', 'Airplane', 'Lake', 'Peppers', 'Boat', 'Elaine'};

for tt = 1 : 8

    Iname = Imgs{tt};
    res2 = load(['2/Proposed_2019_', Iname, '.mat']); res2 = res2.res;
    res3 = load(['3/Proposed_2019_', Iname, '.mat']); res3 = res3.res;
    res4 = load(['4/Proposed_2019_', Iname, '.mat']); res4 = res4.res;
    res5 = load(['5/Proposed_2019_', Iname, '.mat']); res5 = res5.res;

    h=figure('Name', Iname, 'pos', [10, 10, 500, 300]);
    plot(res2(1, :), res2(2, :), ['-o','b'], ...
        'MarkerFaceColor', 'b', ...
        'MarkerSize', 3.5, ...
        'DisplayName', '\fontname{Times New Roman}{\itC}_{1}', ...
        'LineWidth', 1.7);

    hold on;
    plot(res3(1, :), res3(2, :), ['-o', 'g'], ...
        'MarkerFaceColor', 'g', ...
        'MarkerSize', 3.5, ...
        'DisplayName', '\fontname{Times New Roman}{\itC}_{12}', ...
        'LineWidth', 1.7);

    hold on;
    plot(res4(1, :), res4(2, :), ['-o', 'r'], ...
        'MarkerFaceColor', 'r', ...
        'MarkerSize', 3.5, ...
        'DisplayName', '\fontname{Times New Roman}{\itC}_{123}', ...
        'LineWidth', 1.7);

    hold on;
    plot(res5(1, :), res5(2, :), ['-o', 'k'], ...
        'MarkerFaceColor', 'k', ...
        'MarkerSize', 3.5, ...
        'DisplayName', '\fontname{Times New Roman}{\itC}_{1234}', ...
        'LineWidth', 1.7);

    xs = min([res2(1, :) res3(1, :) res4(1, :) res5(1, :)]);
    xe = max([res2(1, :) res3(1, :) res4(1, :) res5(1, :)]);
    ys = min([res2(2, :) res3(2, :) res4(2, :) res5(2, :)]);
    ye = max([res2(2, :) res3(2, :) res4(2, :) res5(2, :)]);
%     set(gca,'ytick',ys:1:ye)
    lg = legend('show');
    set(lg, 'FontSize', 14);
    xlabel('Embedding capacity (bits)');
    ylabel('PSNR (dB)');
    axis([5000, xe+1000, ys-0.5, ye]);
    grid on;
    set(gca, 'GridLineStyle' ,':');
    set(gca, 'GridAlpha', 1);
    set(gca, 'box', 'on');
    set(gcf,'unit','normalized','position',[0.1,0.1,0.3,0.35]);
%     set(gcf,'unit','normalized','position',[0.1,0.1,0.4,0.48]);
    axis normal;
    set(gca,'FontSize',14);
    title(Iname);
    
% %     saveas(h,[name '.eps'],'psc2');
%     set(gcf, 'PaperSize', [16.5 12.5]);
%     saveas(h,[name '.pdf'],'pdf');
    
    saveas(h,['DiffSize/', Iname, '.pdf'],'pdf');
end
