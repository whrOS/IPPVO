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
    plot(res2(1, :), res2(2, :), ['-o','k'], ...
        'MarkerFaceColor', 'k', ...
        'MarkerSize', 3.5, ...
        'DisplayName', '1', ...
        'LineWidth', 1.7);

    hold on;
    plot(res3(1, :), res3(2, :), ['-o', 'r'], ...
        'MarkerFaceColor', 'r', ...
        'MarkerSize', 3.5, ...
        'DisplayName', '2', ...
        'LineWidth', 1.7);

    hold on;
    plot(res4(1, :), res4(2, :), ['-o', 'g'], ...
        'MarkerFaceColor', 'g', ...
        'MarkerSize', 3.5, ...
        'DisplayName', '3', ...
        'LineWidth', 1.7);

    hold on;
    plot(res5(1, :), res5(2, :), ['-o', 'b'], ...
        'MarkerFaceColor', 'b', ...
        'MarkerSize', 3.5, ...
        'DisplayName', '4', ...
        'LineWidth', 1.7);

    xs = min(res2(1, :));
    EC = max(res2(1, :));
    xe = max(res2(1, :));
    cc = sum(res2(1, :)<=EC);
    ys = min(res2(2, :));
    ye = max(res5(2, :));
    lg = legend('show');
    set(lg, 'FontSize', 14);
    xlabel('Embedding capacity (bits)');
    ylabel('PSNR (dB)');
    axis([5000, xe, ys, ye]);
    grid on;
    set(gca, 'GridLineStyle' ,':');
    set(gca, 'GridAlpha', 1);
    set(gca, 'box', 'on');
    set(gcf,'unit','normalized','position',[0.1,0.1,0.4,0.48]);
    axis normal;
    set(gca,'FontSize',14);
    title(Iname);
    
    saveas(h,['DiffSize/', Iname, '.pdf'],'pdf');
end
