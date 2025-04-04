clear,clc

% this.m plot the time simulations

N_vec = [10,20,50,100];
data_shecduled_instace = zeros(length(N_vec),6);

time_window = [0.001, 0.001937, 0.003753, 0.007272, 0.014092, 0.027308, 0.052912, 0.10247, 0.19837, 0.38404, 0.74346, 1.4384, 2.7826, 5.3849, 10.418, 20.173, 39.029, 75.519, 146.09, 282.93];
time_window = [0.5,1,2,100,1000]

for N = N_vec
    count = 1;
    data_shecduled_instace = zeros(length(time_window),6);
    for time_shreshold = time_window
    %     filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\small1LPvsQiu_N%dhavetime.txt",N);
    %     results = readmatrix(filename);
    %     results = results(:,7:12);
    
        results = [0.2,0.5,10,100,50,7;
            2,1.5,102,11,51,70;];
        
        data_shecduled_instace(count,:) = sum(results<=time_shreshold,1); 
        count = count+1;
    end
    filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\small1scheduledinstances_N%d.txt",N);
    writematrix(data_shecduled_instace,filename)

    fig = figure; hold on;
    colors = lines(6); % 获取 6 种不同的颜色
    
    for i = 1:6
        plot(time_window, data_shecduled_instace(:,i), 'o-', 'Color', colors(i,:), 'LineWidth', 3, 'MarkerSize', 8);
    end
    
    % 图像美化
    ax = gca;  % Get current axis
    ax.FontSize = 14;  % Set font size for tick label
    xlim([0.7 4.5])
%     set(gca,"yscale",'log')
    % ylim([0 0.4])
    xticks([1 2 3 4])
    xticklabels({'10','20','50','100'})
    xlabel('$N$',Interpreter='latex',FontSize=20);
    % ylabel('$\frac{\sum_{i}\sum_{j}|d_{ij}-s_{ij}|}{\sum_{i}\sum_{j}d_{ij}}$','interpreter','latex',FontSize=20)
    ylabel('$E[T]$','interpreter','latex',FontSize=24)
    legend({'LP', 'bn = $2$', 'bn = $0.25L$', 'bn = $0.50L$', 'bn = $0.75L$', 'bn = $L$'}, 'interpreter','latex','Location', 'northeast',FontSize=18);
    set(legend, 'Position', [0.24, 0.66, 0.2, 0.08]);
    box on
    hold off
    
    picname = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\small1NotExactsolutionLPvsQiuTime_N%d.pdf",N);
    exportgraphics(fig, picname,'BackgroundColor', 'none','Resolution', 300);
end