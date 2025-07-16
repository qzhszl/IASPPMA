clear,clc

% this.m plot the time simulations
% LPvsQiu_N%dPerturbation1havetime
% LPvsQiu_N%dhavetime
% LPvsQiu_N%dhavetimetest


N_vec = [10,20,50,100];
N_vec = [100];
data_shecduled_instace = zeros(length(N_vec),6);
colors = ["#D08082", "#C89FBF", "#62ABC7", "#7A7DB1", "#6FB494", "#D9B382"];
% time_window = [0.001, 0.001937, 0.003753, 0.007272, 0.014092, 0.027308, 0.052912, 0.10247, 0.19837, 0.38404, 0.74346, 1.4384, 2.7826, 5.3849, 10.418, 20.173, 30];
time_window = logspace(log10(0.35), log10(30), 18)
% time_window = [0.1000    0.1430    0.2044    0.2922    0.4176    0.5967    0.8529    1.2197    1.7432    2.4914    3.5585    5.0817    7.2570   10.3595   30.0000];

% time_window = [0.001, 2, 4, 6, 9, 11, 13, 15, 17, 19, 21, 24, 26, 28, 30]



for N = N_vec
    count = 1;
    data_shecduled_instace = zeros(length(time_window),6);
    for time_shreshold = time_window
        filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\LPvsQiu_N%dhavetime.txt",N);
        result = readmatrix(filename);
        results = result(:,7:12);
        data_shecduled_instace(count,:) = sum(results<=time_shreshold,1); 
        count = count+1;
    end
    % filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\scheduledinstances_N%d.txt",N);
    % writematrix(data_shecduled_instace,filename)

    fig = figure; hold on;
    
    for i = 1:2
        if i==1
            plot(time_window, data_shecduled_instace(:,i)./1000, 's-', 'Color', colors(i), 'LineWidth', 3.5, 'MarkerSize', 10);
        else
            plot(time_window, data_shecduled_instace(:,i)./1000, 'o--', 'Color', colors(i), 'LineWidth', 3.5, 'MarkerSize', 10);
        end
    end

    % 图像美化
    ax = gca;  % Get current axis
    ax.FontSize = 20;  % Set font size for tick label
    xlim([0.3 50])
    set(gca,"xscale",'log')
    ylim([-0.05 1.05])
    % xticks([1 2 3 4])
    % xticklabels({'10','20','50','100'})
    xlabel('$t$',Interpreter='latex',FontSize=30);
    % ylabel('$\frac{\sum_{i}\sum_{j}|d_{ij}-s_{ij}|}{\sum_{i}\sum_{j}d_{ij}}$','interpreter','latex',FontSize=20)
    ylabel('$n_{SI}/n_{simu}$','interpreter','latex',FontSize=30)
    % lgd = legend({'LPLW', '$b_n = 2$', '$b_n = 0.25L$', '$b_n = 0.50L$', '$b_n = 0.75L$', '$b_n = L$'}, 'interpreter','latex','Location', 'northeast',FontSize=24);

    % if N == 10
    %     lgd = legend({'LPLW', '$b_n = 2$', '$b_n = 0.25L$', '$b_n = 0.50L$', '$b_n = 0.75L$', '$b_n = L$'}, 'interpreter','latex','Location', 'northeast',FontSize=24);
    %     set(legend, 'Position', [0.54, 0.5, 0.2, 0.08]);
    % end


    if N == 100
        lgd = legend({'LPLW', '$b_n = 2$'}, 'interpreter','latex','Location', 'northeast',FontSize=24);
        set(legend, 'Position', [0.6, 0.5, 0.2, 0.08]);
    end



    % if N> 50
    %     set(legend, 'Position', [0.28, 0.55, 0.2, 0.08]);
    % else
    %     set(legend, 'Position', [0.54, 0.5, 0.2, 0.08]);
    % end

    box on
    hold off
    
    picname = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\NotExactsolutionLPvsQiuScheduledcasebn2only_N%d.pdf",N);
    exportgraphics(fig, picname,'BackgroundColor', 'none','Resolution', 600);
end