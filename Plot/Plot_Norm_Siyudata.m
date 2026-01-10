clear,clc
% THI.M is for Siyudata
% we compare the reuslts with different demand as input
% demand are combined demand and the percentage is different
% Figure 3

N_vec = [10,20,40,60,80,100,120,140,160,180,200];
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

    [res_mean, res_std] = extract_data_foronepercentage_norm(N_vec, dsmall,dmid,dlarge);
    norm_mean = [norm_mean,res_mean];
    norm_std = [norm_std,res_std];


end

plot_norm(N_vec,norm_mean,norm_std)




function [res_mean, res_std] = extract_data_foronepercentage_norm(N_vec, dsmall,dmid,dlarge)
    data_mean = zeros(length(N_vec),6);
    data_std = zeros(length(N_vec),6);
    count = 1;
    for N = N_vec
        if N<1000 
%         if N==60 && dsmall==0.25 && dmid==0.5
            filename = sprintf("D:\\data\\ISPP_givenA\\test\\descretedemandLPvsQiu_N%ddataper%.2f%.2f%.2f_siyuinput_treefromERp05.txt",N,dsmall,dmid,dlarge);
        else
            filename = sprintf("D:\\data\\ISPP_givenA\\test\\siyudata\\descretedemandLPvsQiu_N%ddataper%.2f%.2f%.2f_siyuinput_treefromERp05.txt",N,dsmall,dmid,dlarge);
%             filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\SiyuData\\discrete\\descretedemandLPvsQiu_N%ddataper%.2f%.2f%.2f_siyuinput_treefromERp05.txt",N,dsmall,dmid,dlarge);
        end
        results = readmatrix(filename);
        results = results(:,1:6);
        mean_values = mean(results);
        std_values = std(results);
        data_mean(count,:) = mean_values;
        data_std(count,:) = std_values;
        count = count+1;
    end
    res_mean = data_mean(:,1:2);
    res_std = data_std(:,1:2);
end


function plot_norm(N_vec,norm_mean,norm_std)
    fig = figure; hold on;
    % colors = ["#D08082", "#C89FBF", "#62ABC7", "#7A7DB1", "#6FB494", "#D9B382"];
    colors = [ "#C89FBF", "#7A7DB1", "#D9B382", "#6FB494"];
    x = 1:length(N_vec);
    count = 1;
%     norm_mean(:,5) = norm_mean(:,5)+ 0.005;
%     norm_mean(:,6) = norm_mean(:,6)+ 0.005;
%     norm_mean(6:11,1) = norm_mean(6:11,1)+ 0.01;
%     norm_mean(7:11,1) = norm_mean(7:11,1)+ 0.01;
    for i = 1:size(norm_mean,2)
        if mod(i,2)==1
            errorbar(N_vec, norm_mean(:,i), norm_std(:,i), 's-', 'Color', colors(count), 'LineWidth', 1, 'MarkerSize', 16,'CapSize',12);
        else
            errorbar(N_vec, norm_mean(:,i), norm_std(:,i), '^--', 'Color', colors(count), 'LineWidth', 1, 'MarkerSize', 16,'CapSize',12);
            count = count+1;
        end
    end
    
    %output_data
    output_matrix = [N_vec.', ...
                     norm_mean(:,1), norm_std(:,1), ...
                     norm_mean(:,2), norm_std(:,2), ...
                     norm_mean(:,3), norm_std(:,3), ...
                     norm_mean(:,4), norm_std(:,4), ...
                     norm_mean(:,5), norm_std(:,5), ...
                     norm_mean(:,6), norm_std(:,6), ...
                     norm_mean(:,7), norm_std(:,7), ...
                     norm_mean(:,8), norm_std(:,8), ...
                     ];   % 如果第7条是重复第一条
    
%     writematrix(output_matrix, 'D:\\data\\ISPP_givenA\\final_data\\norm_siyudata_matrix.csv');


    
    % 图像美化
    ax = gca;  % Get current axis
    ax.FontSize = 24;  % Set font size for tick label
    xlim([0 210])
    ylim([0.1 1.2])
    yticks([0,0.2,0.4,0.6,0.8,1.0])
    ytickformat('%.1f')
    set(gca,"yscale",'log')

    xlabel('$N$',Interpreter='latex',FontSize=26);
    ylabel('$\|D-S\|$','interpreter','latex',FontSize=26)
    % lgd = legend({'LPLW', '$b_n = 2$', '$b_n = 0.25L$', '$b_n = 0.50L$', '$b_n = 0.75L$', '$b_n = L$'}, 'interpreter','latex','Location', 'northeast',FontSize=23.5);
    % lgd = legend({'LPLW, DE', '$b_n = 2$, DE', 'LPLW, DSD', '$b_n = 2$, DSD', '$b_n = 0.75L$', '$b_n = L$'}, 'interpreter','latex','Location', 'northeast',FontSize=23.5);
    % lgd = legend({'LPLW, 1', '$b_n = 2$, 1', 'LPLW, 2', '$b_n = 2$, 2', 'LPLW, 3', '$b_n = 2$, 3', 'LPLW, 4', '$b_n = 2$, 4','LPLW, 5', '$b_n = 2$, 5'}, 'interpreter','latex','Location', 'northeast',FontSize=23.5);
    
    lgd = legend({'LPLW, s1', 'DBS, s1', 'LPLW, s2', 'DBS, s2', 'LPLW, s3', 'DBS, s3', 'LPLW, s4', 'DBS, s4'}, 'Position', [0.47, 0.68, 0.2, 0.1],'interpreter','latex',FontSize=23);
    lgd.NumColumns = 2;
    lgd.ItemTokenSize = [30,100];
    % set(legend, 'Position', [0.446, 0.73, 0.2, 0.1]);

    % lgd.NumColumns = 2;
    % set(legend, 'Position', [0.446, 0.73, 0.2, 0.1]);
    box on
    hold off
    
%     picname = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\SiyuData\\discrete\\normallLPvsQiu_Siyudata_discrete.pdf");
%     exportgraphics(fig, picname,'BackgroundColor', 'none','Resolution', 600);
end


