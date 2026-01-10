clear,clc
% THI.M is for Siyudata
% we compare the reuslts with different demand as input
% demand are combined demand and the percentage is different
% Figure 3

% N_vec = [10,20,40,60,80,100,120,140,160,180,200];
N_vec = [50]
% param_sets = [0.34, 0.33, 0.33;
%               0.5, 0.25, 0.25;
%               0.25,0.5,0.25;
%               0.25,0.25,0.5;
%               ];

param_sets = [0.5, 0.25, 0.25;
              0.25,0.5,0.25;
              0.25,0.25,0.5;
              0.34, 0.33, 0.33;
              ];

% param_sets = [
%               0.25,0.5,0.25;
%               ];

norm_mean = [];
norm_std = [];
time_mean = [];
time_std = [];
maxtime_mean = [];
maxtime_std = [];
sheduled_instances_res = [];
N_scheduled=50;

for i = 1:size(param_sets, 1)
    dsmall = param_sets(i, 1);
    dmid   = param_sets(i, 2);
    dlarge = param_sets(i, 3);

    [time_window, res] = extract_data_foronepercentage_sheduled_instances2(N_scheduled, dsmall,dmid,dlarge);
    sheduled_instances_res = [sheduled_instances_res,res];
    % plot_scheduled_time(N_vec, dsmall,dmid,dlarge)
    % plot_scheduled_instances(N_vec, dsmall,dmid,dlarge)
end


plot_scheduled_instances2(N_scheduled, time_window, sheduled_instances_res)
% B = norm_mean(:, 2:2:end) - norm_mean(:, 1:2:end)


function [time_window, res] = extract_data_foronepercentage_sheduled_instances2(N, dsmall,dmid,dlarge)      
    time_window = linspace(1, 200, 20);
%     time_window = logspace(0, 8, 12);
    count = 1;
    data_shecduled_instace = zeros(length(time_window),6);
%     filename = sprintf("D:\\data\\ISPP_givenA\\test\\descretedemandLPvsQiu_N%ddataper%.2f%.2f%.2f_siyuinput_treefromERp05.txt",N,dsmall,dmid,dlarge);
    filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\SiyuData\\discrete\\descretedemandLPvsQiu_N%ddataper%.2f%.2f%.2f_siyuinput_treefromERp05.txt",N,dsmall,dmid,dlarge);
    result = readmatrix(filename);
    results = result(:,7:12);
    cumulative_time = cumsum(results, 1);
    max(cumulative_time)  
    for time_shreshold = time_window      
        data_shecduled_instace(count,:) = sum(cumulative_time<=time_shreshold,1); 
        count = count+1;
    end
    res = data_shecduled_instace(:,1:2);
    
end


function plot_scheduled_instances2(N, time_window, sheduled_instances_res)
    fig = figure; hold on;
    colors = [ "#C89FBF", "#7A7DB1", "#D9B382", "#6FB494"];
    count = 1;
    for i = 1:size(sheduled_instances_res,2)
        if mod(i,2)==1
            plot(time_window, sheduled_instances_res(:,i)/1000, 's-', 'Color', colors(count), 'LineWidth', 3.5, 'MarkerSize', 12);
        else
            plot(time_window, sheduled_instances_res(:,i)/1000, '^--', 'Color', colors(count), 'LineWidth', 3.5, 'MarkerSize', 12);
            count = count+1;
        end
    end

    output_matrix = [time_window.', ...
                     sheduled_instances_res(:,1)/1000,  ...
                     sheduled_instances_res(:,2)/1000,  ...
                     sheduled_instances_res(:,3)/1000,  ...
                     sheduled_instances_res(:,4)/1000,  ...
                     sheduled_instances_res(:,5)/1000,  ...
                     sheduled_instances_res(:,6)/1000,  ...
                     sheduled_instances_res(:,7)/1000,  ...
                     sheduled_instances_res(:,8)/1000,  ...
                     ];   % 如果第7条是重复第一条
    
%     writematrix(output_matrix, 'D:\\data\\ISPP_givenA\\final_data\\scheduled_instances_siyudata_matrix.csv');




    % 图像美化
    ax = gca;  % Get current axis
    ax.FontSize = 24;  % Set font size for tick label
    % xlim([0.001 100])
%     set(gca,"xscale",'log')
    ylim([0 1.05])
    ytickformat('%.1f')
    % xticks([1 2 3 4])
    % xticklabels({'10','20','50','100'})
    xlabel('$t$(sec)',Interpreter='latex',FontSize=26);
    % ylabel('$\frac{\sum_{i}\sum_{j}|d_{ij}-s_{ij}|}{\sum_{i}\sum_{j}d_{ij}}$','interpreter','latex',FontSize=20)
    ylabel('$n_{s}/n_{a}$','interpreter','latex',FontSize=26)
    lgd = legend({'1', '1', '2', '2', '3', '3'}, 'interpreter','latex','Location', 'northeast',FontSize=24);

    % if N == 10
    %     lgd = legend({'LPLW', '$b_n = 2$', '$b_n = 0.25L$', '$b_n = 0.50L$', '$b_n = 0.75L$', '$b_n = L$'}, 'interpreter','latex','Location', 'northeast',FontSize=24);
    %     set(legend, 'Position', [0.54, 0.5, 0.2, 0.08]);
    % end


    % if N == 20
    %     lgd = legend({'LPLW', '$b_n = 2$'}, 'interpreter','latex','Location', 'northeast',FontSize=24);
    %     set(legend, 'Position', [0.54, 0.5, 0.2, 0.08]);
    % end


    % if N> 50
    %     set(legend, 'Position', [0.28, 0.55, 0.2, 0.08]);
    % else
    %     set(legend, 'Position', [0.54, 0.5, 0.2, 0.08]);
    % end

    box on
    hold off
    
    picname = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\SiyuData\\discrete\\sheduled_instance_all_LPvsQiu_Siyudata_Nnode%d_discrete.pdf",N);
%     exportgraphics(fig, picname,'BackgroundColor', 'none','Resolution', 600);

end


