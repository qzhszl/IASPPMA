clear,clc

% this.m plot the time simulations
% LPvsQiu_N%dPerturbation1havetime
% LPvsQiu_N%dhavetime
% LPvsQiu_N%dhavetimetest


N_vec = [10,20,50,100,200];
N_vec = [201];
data_shecduled_instace = zeros(length(N_vec),6);
colors = ["#D08082", "#C89FBF", "#62ABC7", "#7A7DB1", "#6FB494", "#D9B382"];
% time_window = [0.001, 0.001937, 0.003753, 0.007272, 0.014092, 0.027308, 0.052912, 0.10247, 0.19837, 0.38404, 0.74346, 1.4384, 2.7826, 5.3849, 10.418, 20.173, 30];
% time_window = logspace(log10(100), log10(60000), 25)
time_window = linspace(0, 120, 30);


for N = N_vec
    count = 1;
    data_shecduled_instace = zeros(length(time_window),6);
%     filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\PerturbatedDemand\\LPvsQiu_N%dPerturbation1havetime.txt",N);
    filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\RandomDemand\\LPvsQiu_N%dhavetimerandom.txt",N);
%     filename = sprintf("D:\\data\\ISPP_givenA\\test\\LPvsQiu_N%dhavetimerandom.txt",N);
    
    result = readmatrix(filename);
    results = result(:,7:12);
    maxtime = max(results)
    mintime = min(results)
    ave_time = mean(results)
    for time_shreshold = time_window
        data_shecduled_instace(count,:) = sum(results<=time_shreshold,1); 
        count = count+1;
    end
    % filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\scheduledinstances_N%d.txt",N);
    % writematrix(data_shecduled_instace,filename)

    fig = figure; hold on;
    
    for i = 1:2
        if i==1
            plot(time_window, data_shecduled_instace(:,i)./size(results,1), 's-', 'Color', colors(i), 'LineWidth', 3.5, 'MarkerSize', 10);
        else
            plot(time_window, data_shecduled_instace(:,i)./size(results,1), 'o--', 'Color', colors(i), 'LineWidth', 3.5, 'MarkerSize', 10);
        end
    end
    
    


    output_matrix = [time_window.', data_shecduled_instace(:,1)./size(results,1),data_shecduled_instace(:,2)./size(results,1)
                 ];   % 如果第7条是重复第一条


%     writematrix(output_matrix, 'D:\\data\\ISPP_givenA\\final_data\\scheduled_instance_maxistf_matrix_random.csv');



    % 图像美化
    ax = gca;  % Get current axis
    ax.FontSize = 30;  % Set font size for tick label
    % xlim([10 60])
    % set(gca,"yscale",'log')
    % set(gca,"xscale",'log')
    ylim([0 1.05])
    % xticks([1 2 3 4])
    % xticklabels({'10','20','50','100'})
    xlabel('$t$(sec)',Interpreter='latex',FontSize=36);
    % ylabel('$\frac{\sum_{i}\sum_{j}|d_{ij}-s_{ij}|}{\sum_{i}\sum_{j}d_{ij}}$','interpreter','latex',FontSize=20)
    ylabel('$n_{s}/n_{a}$','interpreter','latex',FontSize=36)
    % lgd = legend({'LPLW', '$b_n = 2$', '$b_n = 0.25L$', '$b_n = 0.50L$', '$b_n = 0.75L$', '$b_n = L$'}, 'interpreter','latex','Location', 'northeast',FontSize=24);

    % if N == 10
    %     lgd = legend({'LPLW', '$b_n = 2$', '$b_n = 0.25L$', '$b_n = 0.50L$', '$b_n = 0.75L$', '$b_n = L$'}, 'interpreter','latex','Location', 'northeast',FontSize=24);
    %     set(legend, 'Position', [0.54, 0.5, 0.2, 0.08]);
    % end


    % if N == 200
    %     lgd = legend({'LPLW', '$b_n = 2$'}, 'interpreter','latex','Location', 'northeast',FontSize=24);
    %     set(legend, 'Position', [0.65, 0.3, 0.2, 0.08]);
    % end



    % if N> 50
    %     set(legend, 'Position', [0.28, 0.55, 0.2, 0.08]);
    % else
    %     set(legend, 'Position', [0.54, 0.5, 0.2, 0.08]);
    % end

    box on
    hold off
%     set(fig, 'Color', 'none');
    ax = gca;
%     set(ax, 'Color', 'none');
    annotation('textbox', [0.58, 0.35, 0.1, 0.05], 'String', '$N = 200$', ...
    'EdgeColor', 'none', 'FontSize', 32, Interpreter='latex');

    picname = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\PerturbatedDemand\\Scheduledinstancebn2only_N%d_perturbatedtree.pdf",N);
    % print(fig, picname, '-dsvg');
%     exportgraphics(fig, picname,'BackgroundColor', 'none','Resolution', 600);
end
