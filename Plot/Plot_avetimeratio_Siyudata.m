clear,clc
% THI.M is for Siyudata
% we compare the reuslts with different demand as input
% demand are combined demand and the percentage is different
% Figure 3

N_vec = [10,21,41,61,80,100,120,140,160,180,200];
% N_vec = [10,11,20,21,40,41,60,61,80,81,100,101,120,140,160,180,200];
% N_vec = [200]
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


    [res_mean, res_std] = extract_data_foronepercentage_avetimeratio(N_vec, dsmall,dmid,dlarge);
    
%     [res_mean, res_std] = extract_data_foronepercentage_avetime(N_vec, dsmall,dmid,dlarge);
    time_mean = [time_mean,res_mean];
    time_std = [time_std,res_std];

end



plot_time_ratio(N_vec, time_mean, time_std)




function [res_mean, res_std] = extract_data_foronepercentage_avetimeratio(N_vec, dsmall,dmid,dlarge)
    data_mean = zeros(length(N_vec),1);
    data_std = zeros(length(N_vec),1);
    count = 1;
    for N = N_vec
%         if N<1
        if ismember(N, [9,10,11,12,19,20,21,39,40,41,59,60,79,80,81,99,100,101])
% %         if N==60 && dsmall==0.25 && dmid==0.5
            filename = sprintf("D:\\data\\ISPP_givenA\\test\\descretedemandLPvsQiu_N%ddataper%.2f%.2f%.2f_siyuinput_treefromERp05.txt",N,dsmall,dmid,dlarge);
        else
            filename = sprintf("D:\\data\\ISPP_givenA\\test\\siyudata\\descretedemandLPvsQiu_N%ddataper%.2f%.2f%.2f_siyuinput_treefromERp05.txt",N,dsmall,dmid,dlarge);
%             filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\SiyuData\\discrete\\descretedemandLPvsQiu_N%ddataper%.2f%.2f%.2f_siyuinput_treefromERp05.txt",N,dsmall,dmid,dlarge);
        end
        
        results = readmatrix(filename);
        results = results(:,7:12);
        results = results(:,2)./results(:,1);
        mean_values = mean(results);
        std_values = std(results);
        data_mean(count) = mean_values;
        data_std(count) = std_values;
        count = count+1;
    end
    res_mean = data_mean;
    res_std = data_std;
end



function plot_time_ratio(N_vec, time_mean, time_std)
    fig = figure; hold on;
    colors = [ "#C89FBF", "#7A7DB1", "#D9B382", "#6FB494",];
    count = 1;
%     time_mean(3:5,2) = time_mean(3:5,2)-0.1;
%     time_mean(4:5,2) = time_mean(4:5,2)-0.1;
%     time_mean(7,:) = time_mean(7,:)-0.1;
%     time_mean(8,:) = time_mean(8,:)-0.02;
%     time_mean(9,:) = time_mean(9,:)-0.05;
%     

    for i = 1:size(time_mean,2)      
        errorbar(N_vec, time_mean(:,i), time_std(:,i), 'o--', 'Color', colors(count), 'LineWidth', 4, 'MarkerSize', 12,'CapSize',10);
        count = count+1;
    end
    N_vec = [10,20,40,60,80,100,120,140,160,180,200];
    output_matrix = [N_vec.', ...
                     time_mean(:,1), time_std(:,1), ...
                     time_mean(:,2), time_std(:,2), ...
                     time_mean(:,3), time_std(:,3), ...
                     time_mean(:,4), time_std(:,4), ...
                     ];   % 如果第7条是重复第一条
    
    writematrix(output_matrix, 'D:\\data\\ISPP_givenA\\final_data\\time_ratio_siyudata_matrix.csv');




    % 图像美化
    ax = gca;  % Get current axis
    ax.FontSize = 24;  % Set font size for tick label
    xlim([0 210])
    % xlim([0.7 4.5])
    ylim([0.3 1])
    ytickformat('%.1f')
    set(gca,"yscale",'log')
    % ylim([0 0.4])
    % xticks([1 2 3 4])
    % yticks([0.01 1 100])
    % xticklabels({'10','20','50','100'})
    xlabel('$N$',Interpreter='latex',FontSize=26);
    % ylabel('$\frac{\sum_{i}\sum_{j}|d_{ij}-s_{ij}|}{\sum_{i}\sum_{j}d_{ij}}$','interpreter','latex',FontSize=20)
    ylabel('$t/t_{LPLW}$','interpreter','latex',FontSize=26)
    % lgd = legend({'LPLW, DE', '$b_n = 2$, DE', 'LPLW, DSD', '$b_n = 2$, DSD', '$b_n = 0.75L$', '$b_n = L$'}, 'interpreter','latex','Location', 'northwest',FontSize=23.5);
    lgd = legend({'s1', 's2', 's3', 's4'}, 'Position', [0.65, 0.65, 0.2, 0.1],'interpreter','latex',FontSize=24);
    % lgd.NumColumns = 2;
    % set(legend, 'Position', [0.446, 0.73, 0.2, 0.1]);
    box on
    hold off
    
    picname = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\SiyuData\\discrete\\timeratioallLPvsQiu_Siyudata_discrete.pdf");
%     exportgraphics(fig, picname,'BackgroundColor', 'none','Resolution', 600);
end


