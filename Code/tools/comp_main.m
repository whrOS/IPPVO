function comp_main(name, mtds, EC)
    h=figure('Name', name, 'pos', [10, 10, 500, 300]);
    title(name);
    hold on;
    [xs, xe, ys, ye] = deal(2^30, 0, 2^30, 0);
    for i = 1 : length(mtds)
        m = mtds{i};
%         r = importdata(['./pairwise_IPVO/', m{1}, '_', m{2}, '_', name, '.mat']);
        r = importdata(['./result/', m{1}, '_', m{2}, '_', name, '.mat']);
        if size(r,1) >= 3
            r(:, r(3, :) == 0) = [];
        end
        l = [m{3}, m{4}];
        c = m{4};
        MarkSize = 3.5;
        if strcmp(m{1},'Proposed')
            plot(r(1, :), r(2, :), l, ...
                'MarkerFaceColor', c, ...
                'MarkerSize', MarkSize, ...
                'DisplayName', m{1}, ....
                'LineWidth', 1.7);
            ymax = max(r(2, 1:sum(r(1, :)<=EC)));
            ymin = floor(min(r(2, 1:sum(r(1, :)<=EC))));
        elseif strcmp(m{1},'PVO') 
                m{1} = 'Li{\it et al}.';
                plot(r(1, :), r(2, :), l, ...
                    'MarkerFaceColor', c, ...
                    'MarkerSize', MarkSize, ...
                    'DisplayName', m{1}, ....
                    'LineWidth', 1.3);
        elseif strcmp(m{1},'IPVO')
                m{1} = 'Peng{\it et al}.';
                plot(r(1, :), r(2, :), l, ...
                    'MarkerFaceColor', c, ...
                    'MarkerSize', MarkSize, ...
                    'DisplayName', m{1}, ....
                    'LineWidth', 1.3);
        elseif strcmp(m{1},'PVOK')
                m{1} = 'Ou{\it et al}.';
                plot(r(1, :), r(2, :), l, ...
                    'MarkerFaceColor', c, ...
                    'MarkerSize', MarkSize, ...
                    'DisplayName', m{1}, ....
                    'LineWidth', 1.3);
        elseif strcmp(m{1},'PPVO')
                m{1} = 'Qu{\it et al}.';
                plot(r(1, :), r(2, :), l, ...
                    'MarkerFaceColor', c, ...
                    'MarkerSize', MarkSize, ...
                    'DisplayName', m{1}, ....
                    'LineWidth', 1.3);
        end
        
        xs = min([xs, min(r(1, :))]);
%         xe = max([xe, max(r(1, :))]);
        xe = EC;
        cc = sum(r(1, :)<=EC);
        ys = min([ys, min(r(2, 1:cc))]);
        ye = max([ye, max(r(2, 1:cc))]);
    end
    
    set(gca,'ytick',ymin:1:ymax)
    lg = legend('show');
    set(lg, 'FontSize', 14);
    xlabel('Embedding capacity (bits)');
    ylabel('PSNR (dB)');
    axis([xs, xe, ymin, ymax]);
    grid on;
    set(gca, 'GridLineStyle' ,':');
    set(gca, 'GridAlpha', 1);
    set(gca, 'box', 'on');
%     set (gca,'position',[0.1,0.1,0.9,0.9] );
    set(gcf,'unit','normalized','position',[0.1,0.1,0.25,0.3]);
    axis normal;
    set(gca,'FontSize',14);
%     saveas(h,[name '.png'],'png');
%     saveas(h,[name '.fig'],'fig');
    saveas(h,[name '.eps'],'psc2');
%     set(gcf, 'PaperPosition', [0 0 26 26]);
    set(gcf, 'PaperSize', [16.5 12.5]);
    saveas(h,[name '.pdf'],'pdf');
    hold off;
end