clear,clc
% THI.M is for Siyudata
% we compare the reuslts with different demand as input
% demand are combined demand and the percentage is different

N_vec = [10,20,50,100, 200];
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

norm_mean = [];
norm_std = [];
time_mean = [];
time_std = [];
sheduled_instances_res = [];

for i = 1:size(param_sets, 1)
    dsmall = param_sets(i, 1);
    dmid   = param_sets(i, 2);
    dlarge = param_sets(i, 3);

    [res_mean, res_std] = extract_data_foronepercentage_norm(N_vec, dsmall,dmid,dlarge);
    norm_mean = [norm_mean,res_mean];
    norm_std = [norm_std,res_std];

    [res_mean, res_std] = extract_data_foronepercentage_avetime(N_vec, dsmall,dmid,dlarge);
    time_mean = [time_mean,res_mean];
    time_std = [time_std,res_std];
    
    [time_window, res] = extract_data_foronepercentage_sheduled_instances2(200, dsmall,dmid,dlarge);
    sheduled_instances_res = [sheduled_instances_res,res];
    % plot_scheduled_time(N_vec, dsmall,dmid,dlarge)
    % plot_scheduled_instances(N_vec, dsmall,dmid,dlarge)
end

% plot_norm(N_vec,norm_mean,norm_std)
% plot_time(N_vec,time_mean,time_std)
plot_scheduled_instances2(200, time_window, sheduled_instances_res)

function [res_mean, res_std] = extract_data_foronepercentage_norm(N_vec, dsmall,dmid,dlarge)
    data_mean = zeros(length(N_vec),6);
    data_std = zeros(length(N_vec),6);
    count = 1;
    for N = N_vec
        filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\SiyuData\\LPvsQiu_N%ddataper%.2f%.2f%.2f_siyuinput_treefromERp05.txt",N,dsmall,dmid,dlarge);
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
    colors = [ "#C89FBF", "#62ABC7", "#7A7DB1", "#6FB494", "#D9B382","#D08082",];
    x = 1:length(N_vec);
    count = 1;
    for i = 1:size(norm_mean,2)
        if mod(i,2)==1
            errorbar(N_vec, norm_mean(:,i), norm_std(:,i), 's-', 'Color', colors(count), 'LineWidth', 4, 'MarkerSize', 10,'CapSize',10);
        else
            errorbar(N_vec, norm_mean(:,i), norm_std(:,i), 'o--', 'Color', colors(count), 'LineWidth', 4, 'MarkerSize', 10,'CapSize',10);
            count = count+1;
        end
    end
    
    % 图像美化
    ax = gca;  % Get current axis
    ax.FontSize = 24;  % Set font size for tick label
    xlim([0 210])
    % ylim([0.2 0.8])
    % set(gca,"xscale",'log')
    
    xlabel('$N$',Interpreter='latex',FontSize=26);
    ylabel('$|D-S|$','interpreter','latex',FontSize=26)
    % lgd = legend({'LPLW', '$b_n = 2$', '$b_n = 0.25L$', '$b_n = 0.50L$', '$b_n = 0.75L$', '$b_n = L$'}, 'interpreter','latex','Location', 'northeast',FontSize=23.5);
    % lgd = legend({'LPLW, DE', '$b_n = 2$, DE', 'LPLW, DSD', '$b_n = 2$, DSD', '$b_n = 0.75L$', '$b_n = L$'}, 'interpreter','latex','Location', 'northeast',FontSize=23.5);
    % lgd = legend({'LPLW, 1', '$b_n = 2$, 1', 'LPLW, 2', '$b_n = 2$, 2', 'LPLW, 3', '$b_n = 2$, 3', 'LPLW, 4', '$b_n = 2$, 4','LPLW, 5', '$b_n = 2$, 5'}, 'interpreter','latex','Location', 'northeast',FontSize=23.5);

    % lgd.NumColumns = 2;
    % set(legend, 'Position', [0.446, 0.73, 0.2, 0.1]);
    box on
    hold off
    
    picname = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\SiyuData\\normallLPvsQiu_Siyudata.pdf");
    exportgraphics(fig, picname,'BackgroundColor', 'none','Resolution', 600);
end



function [res_mean, res_std] = extract_data_foronepercentage_avetime(N_vec, dsmall,dmid,dlarge)
    data_mean = zeros(length(N_vec),6);
    data_std = zeros(length(N_vec),6);
    count = 1;
    for N = N_vec
        filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\SiyuData\\LPvsQiu_N%ddataper%.2f%.2f%.2f_siyuinput_treefromERp05.txt",N,dsmall,dmid,dlarge);
        results = readmatrix(filename);
        results = results(:,7:12);
        mean_values = mean(results);
        std_values = std(results);
        data_mean(count,:) = mean_values;
        data_std(count,:) = std_values;
        count = count+1;
    end
    res_mean = data_mean(:,1:2);
    res_std = data_std(:,1:2);
end


function plot_time(N_vec, time_mean, time_std)
    fig = figure; hold on;
    colors = [ "#C89FBF", "#62ABC7", "#7A7DB1", "#6FB494", "#D9B382","#D08082",];
    x = 1:length(N_vec);
    count = 1;
    for i = 1:size(time_mean,2)
        if mod(i,2)==1
            errorbar(N_vec, time_mean(:,i), time_std(:,i), 's-', 'Color', colors(count), 'LineWidth', 4, 'MarkerSize', 10,'CapSize',10);
        else
            errorbar(N_vec, time_mean(:,i), time_std(:,i), 'o--', 'Color', colors(count), 'LineWidth', 4, 'MarkerSize', 10,'CapSize',10);
            count = count+1;
        end
    end
    
    % 图像美化
    ax = gca;  % Get current axis
    ax.FontSize = 24;  % Set font size for tick label
    xlim([0 210])
    % xlim([0.7 4.5])
    % ylim([0 1000])
    
    % set(gca,"yscale",'log')
    % ylim([0 0.4])
    % xticks([1 2 3 4])
    % yticks([0.01 1 100])
    % xticklabels({'10','20','50','100'})
    xlabel('$N$',Interpreter='latex',FontSize=26);
    % ylabel('$\frac{\sum_{i}\sum_{j}|d_{ij}-s_{ij}|}{\sum_{i}\sum_{j}d_{ij}}$','interpreter','latex',FontSize=20)
    ylabel('$t$(sec)','interpreter','latex',FontSize=26)
    % lgd = legend({'LPLW, DE', '$b_n = 2$, DE', 'LPLW, DSD', '$b_n = 2$, DSD', '$b_n = 0.75L$', '$b_n = L$'}, 'interpreter','latex','Location', 'northwest',FontSize=23.5);
    lgd = legend({'LPLW, s1', 'DBS, s1', 'LPLW, s2', 'DBS, s2', 'LPLW, s3', 'DBS, s3', 'LPLW, s4', 'DBS, s4'}, 'Position', [0.23, 0.54, 0.2, 0.1],'interpreter','latex',FontSize=21);
    % lgd.NumColumns = 2;
    % set(legend, 'Position', [0.446, 0.73, 0.2, 0.1]);
    box on
    hold off
    
    picname = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\SiyuData\\timeallLPvsQiu_Siyudata.pdf");
    exportgraphics(fig, picname,'BackgroundColor', 'none','Resolution', 600);
end

function [time_window, res] = extract_data_foronepercentage_sheduled_instances(N, dsmall,dmid,dlarge)      
    time_window = logspace(log10(0.5), log10(10), 18);
    count = 1;
    data_shecduled_instace = zeros(length(time_window),6);
    for time_shreshold = time_window
        filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\SiyuData\\LPvsQiu_N%ddataper%.2f%.2f%.2f_siyuinput_treefromERp05.txt",N,dsmall,dmid,dlarge);
        result = readmatrix(filename);
        results = result(:,7:12);
        data_shecduled_instace(count,:) = sum(results<=time_shreshold,1)/1000; 
        count = count+1;
    end
    res = data_shecduled_instace(:,1:2);
end


function plot_scheduled_instances(N, time_window, sheduled_instances_res)
    fig = figure; hold on;
    colors = [ "#C89FBF", "#62ABC7", "#7A7DB1", "#6FB494", "#D9B382","#D08082",];
    count = 1;
    for i = 1:size(sheduled_instances_res,2)
        if mod(i,2)==1
            plot(time_window, sheduled_instances_res(:,i), 's-', 'Color', colors(count), 'LineWidth', 3.5, 'MarkerSize', 10);
        else
            plot(time_window, sheduled_instances_res(:,i), 'o--', 'Color', colors(count), 'LineWidth', 3.5, 'MarkerSize', 10);
            count = count+1;
        end
    end

    % 图像美化
    ax = gca;  % Get current axis
    ax.FontSize = 20;  % Set font size for tick label
    % xlim([0.001 100])
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
    
    picname = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\SiyuData\\sheduled_instance_all_LPvsQiu_Siyudata_Nnode%dper.pdf",N);
    exportgraphics(fig, picname,'BackgroundColor', 'none','Resolution', 600);

end


function [time_window, res] = extract_data_foronepercentage_sheduled_instances2(N, dsmall,dmid,dlarge)      
    time_window = linspace(100, 60000, 25);
    count = 1;
    data_shecduled_instace = zeros(length(time_window),6);
    filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\SiyuData\\LPvsQiu_N%ddataper%.2f%.2f%.2f_siyuinput_treefromERp05.txt",N,dsmall,dmid,dlarge);
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
    colors = [ "#C89FBF", "#62ABC7", "#7A7DB1", "#6FB494", "#D9B382","#D08082",];
    count = 1;
    for i = 1:size(sheduled_instances_res,2)
        if mod(i,2)==1
            plot(time_window, sheduled_instances_res(:,i)/1000, 's-', 'Color', colors(count), 'LineWidth', 3.5, 'MarkerSize', 10);
        else
            plot(time_window, sheduled_instances_res(:,i)/1000, 'o--', 'Color', colors(count), 'LineWidth', 3.5, 'MarkerSize', 10);
            count = count+1;
        end
    end

    % 图像美化
    ax = gca;  % Get current axis
    ax.FontSize = 24;  % Set font size for tick label
    % xlim([0.001 100])
    % set(gca,"xscale",'log')
    ylim([0 1.05])
    % xticks([1 2 3 4])
    % xticklabels({'10','20','50','100'})
    xlabel('$t$',Interpreter='latex',FontSize=26);
    % ylabel('$\frac{\sum_{i}\sum_{j}|d_{ij}-s_{ij}|}{\sum_{i}\sum_{j}d_{ij}}$','interpreter','latex',FontSize=20)
    ylabel('$n_{s}/n_{a}$','interpreter','latex',FontSize=26)
    % lgd = legend({'LPLW', '$b_n = 2$', '$b_n = 0.25L$', '$b_n = 0.50L$', '$b_n = 0.75L$', '$b_n = L$'}, 'interpreter','latex','Location', 'northeast',FontSize=24);

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
    
    picname = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\SiyuData\\sheduled_instance_all_LPvsQiu_Siyudata_Nnode%dper2.pdf",N);
    exportgraphics(fig, picname,'BackgroundColor', 'none','Resolution', 600);

end


