clear,clc
% plot the tree with different hopcount of the diameter
% from a star to a line network

N = 50;


data_mean = zeros(5,13);
data_std = zeros(5,13);
data_shecduled_instace = zeros(5,6);

filestar_name = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\diff_diameter\\LPvsQiu_N%dhavetime_randominput_star.txt",N);
star_res = readmatrix(filestar_name);

filechain_name = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\diff_diameter\\LPvsQiu_N%dhavetime_randominput_pathnetwork.txt",N);
chain_res = readmatrix(filechain_name);

file_name = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\diff_diameter\\LPvsQiu_N%dhavetime_randominput_treefromERp09.txt",N);
ER_res1 = readmatrix(file_name);
file_name = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\diff_diameter\\LPvsQiu_N%dhavetime_randominput_treefromERp05.txt",N);
ER_res2 = readmatrix(file_name);
file_name = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\diff_diameter\\LPvsQiu_N%dhavetime_randominput_treefromERp008.txt",N);
ER_res3 = readmatrix(file_name);
% file_name = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\diff_diameter\\LPvsQiu_N%dhavetime_randominput_treefromERp006.txt",N);
% ER_res4 = readmatrix(file_name);
% ER_res = [ER_res1;ER_res2;ER_res3;ER_res4];
ER_res = [ER_res1;ER_res2;ER_res3];
a = ER_res(:,13);
T_TABULATE = tabulate(a)
tabulate(ER_res1(:,13))
tabulate(ER_res2(:,13))
tabulate(ER_res3(:,13))
% tabulate(ER_res4(:,13))
total_count = sum(T_TABULATE(:,2));
max(ER_res(:,7))
max(star_res)
max(chain_res)
max(ER_res)
diameter_hop_vec = [2,10,15,20,49];
% diameter_hop_vec = [2,15,49];
count = 1;
for diameter_hop  = diameter_hop_vec
    if diameter_hop==2
        data_mean(count,:) = mean(star_res);
        data_std(count,:) = std(star_res);
    elseif diameter_hop==49
        data_mean(count,:) = mean(chain_res);
        data_std(count,:) = std(chain_res);
    else
        ER_res_withdia = ER_res(ER_res(:,13) == diameter_hop, :);
        data_mean(count,:) =mean(ER_res_withdia);
        data_std(count,:) = std(ER_res_withdia);
    end
    count = 1+count;
end

% plot_time(N,diameter_hop_vec,star_res,chain_res,ER_res)
% 
plot_norm(N,data_mean,data_std)

% plot_scheduled_time(data_mean,data_std)

% plot_scheduled_instances(diameter_hop_vec,star_res,chain_res,ER_res)


% plot sheduled instance 2
% for diameter_hop = diameter_hop_vec
%     ER_res_withdia = ER_res(ER_res(:,13) == diameter_hop, :);
%     samle_time_com = size(ER_res_withdia,1);
% end
% sample_time = 300
% 
% sheduled_instances_res =[];
% for diameter_hop  = diameter_hop_vec
%     time_window = linspace(2, 100, 25);
%     if diameter_hop==2
%         star_res = star_res(1:sample_time,:);
%         [time_window, res] = extract_data_diffrho_sheduled_instances2(star_res,time_window);
%         sheduled_instances_res = [sheduled_instances_res,res];
%     elseif diameter_hop==49
%         chain_res = chain_res(1:sample_time,:);
%         [time_window, res] = extract_data_diffrho_sheduled_instances2(chain_res,time_window);
%         sheduled_instances_res = [sheduled_instances_res,res];
%     else
%         ER_res_withdia = ER_res(ER_res(:,13) == diameter_hop, :);
%         ER_res_withdia = ER_res_withdia(1:sample_time,:);
%         [time_window, res] = extract_data_diffrho_sheduled_instances2(ER_res_withdia,time_window);
%         sheduled_instances_res = [sheduled_instances_res,res];
%     end
% end
% plot_scheduled_instances2(N, time_window, sheduled_instances_res)


function plot_time(N,diameter_hop_vec,star_res,chain_res,ER_res)
    data_mean = zeros(length(diameter_hop_vec),6);
    data_std = zeros(length(diameter_hop_vec),6);
    count = 1    
    for diameter_hop  = diameter_hop_vec
        if diameter_hop==2
            results = star_res(:,7:12);
        elseif diameter_hop==49
            results = chain_res(:,7:12);
        else
            ER_res_withdia = ER_res(ER_res(:,13) == diameter_hop, :);
            results = ER_res_withdia(:,7:12);
        end
        results = results./results(:,1);
        mean_values = mean(results);
        std_values = std(results);
        data_mean(count,:) = mean_values;
        data_std(count,:) = std_values;
        count = count+1;
    end
    fig = figure; hold on;
    colors = ["#D08082", "#C89FBF", "#62ABC7", "#7A7DB1", "#6FB494", "#D9B382"];
    
    x = diameter_hop_vec;
    for i = 1:6
        if i==1
            errorbar(x, data_mean(:,i), data_std(:,i), 's-', 'Color', colors(i), 'LineWidth', 4, 'MarkerSize', 10);
        else
            errorbar(x, data_mean(:,i), data_std(:,i), 'o--', 'Color', colors(i), 'LineWidth', 4, 'MarkerSize', 10);
        end
    end
    
    % 图像美化
    ax = gca;  % Get current axis
    ax.FontSize = 20;  % Set font size for tick label
    xlim([0 52])
    % % set(gca,"yscale",'log')
    % ylim([0 8])
    % yticks([0,1,2,3,4,5,6,7])
    xticks([0 10 20 30 40 50])
    % xticklabels({'10','20','50','100'})
    xlabel('$\rho$',Interpreter='latex',FontSize=30);
    % ylabel('$\frac{\sum_{i}\sum_{j}|d_{ij}-s_{ij}|}{\sum_{i}\sum_{j}d_{ij}}$','interpreter','latex',FontSize=20)
    ylabel('$t/t_{LPLW}$','interpreter','latex',FontSize=30)
    % lgd = legend({'LPLW', '$b_n = 2$', '$b_n = 0.25L$', '$b_n = 0.50L$', '$b_n = 0.75L$', '$b_n = L$'}, 'interpreter','latex','Location', 'northwest',FontSize=24);
    % lgd.NumColumns = 1;
    box on
    hold off
    picname = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\diff_diameter\\timeratio_LPvsQiu_diffdiameter_randomrequirements_N%d.pdf",N);
    exportgraphics(fig, picname,'BackgroundColor', 'none','Resolution', 600);
end


function plot_norm(N, data_mean,data_std)
    fig = figure; hold on;
    colors = ["#D08082", "#C89FBF", "#62ABC7", "#7A7DB1", "#6FB494", "#D9B382"];
    x = [2,10,15,20,49];
    for i = 1:6
        if i==1
            errorbar(x, data_mean(:,i), data_std(:,i), 's-', 'Color', colors(i), 'LineWidth', 4, 'MarkerSize', 10,'CapSize',10);
        else
            errorbar(x, data_mean(:,i), data_std(:,i), 'o--', 'Color', colors(i), 'LineWidth', 4, 'MarkerSize', 10,'CapSize',10);
        end
    end
    
    % 图像美化
    ax = gca;  % Get current axis
    ax.FontSize = 24;  % Set font size for tick label
    % xlim([0.7 4.5])
    ylim([0 0.6])
    xticks([0 10 20 30 40 50])
    % xticklabels({'10','20','50','100'})
    xlabel('$\rho$',Interpreter='latex',FontSize=26);
    ylabel('$\|D-S\|$','interpreter','latex',FontSize=26)
    lgd = legend({'LPLW', '$b_n = 2$', '$b_n = 0.25L$', '$b_n = 0.50L$', '$b_n = 0.75L$', '$b_n = L$'}, 'interpreter','latex','Location', 'southeast',FontSize=20);
    % lgd.NumColumns = 2;
    % set(legend);
    box on
    hold off
    
    picname = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\diff_diameter\\norm_LPvsQiu_diffdiameter_randomrequirements_N%d.pdf",N);
    exportgraphics(fig, picname,'BackgroundColor', 'none','Resolution', 600);
end


function plot_scheduled_time(data_mean,data_std)
    fig = figure; hold on;
    colors = ["#D08082", "#C89FBF", "#62ABC7", "#7A7DB1", "#6FB494", "#D9B382"];
    x = [2,10,15,20,49];
    for i = 7:8
        if i==7
            errorbar(x, data_mean(:,i), data_std(:,i), 's-', 'Color', colors(1), 'LineWidth', 4, 'MarkerSize', 10,'CapSize',10);
        else
            errorbar(x, data_mean(:,i), data_std(:,i), 'o--', 'Color', colors(2), 'LineWidth', 4, 'MarkerSize', 10,'CapSize',10);
        end
    end
    
    % 图像美化
    ax = gca;  % Get current axis
    ax.FontSize = 20;  % Set font size for tick label
    xlim([0 52])
    % ylim([0 0.6])
    xticks([0 10 20 30 40 50])
    % xticklabels({'10','20','50','100'})
    xlabel('$\rho$',Interpreter='latex',FontSize=30);
    ylabel('$t_f$(sec)','interpreter','latex',FontSize=30)
    lgd = legend({'LPLW', '$b_n = 2$'}, 'interpreter','latex','Location', 'northeast',FontSize=20);
    % lgd.NumColumns = 2;
    % set(legend);
    box on
    hold off
    
    picname = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\diff_diameter\\time_LPvsQiu_diffdiameter_randomrequirements.pdf");
    exportgraphics(fig, picname,'BackgroundColor', 'none','Resolution', 600);
end


function plot_scheduled_instances(diameter_hop_vec,star_res,chain_res,ER_res)
    % time_window = [0.001, 0.001937, 0.003753, 0.007272, 0.014092, 0.027308, 0.052912, 0.10247, 0.19837, 0.38404,0.74346,1.4384,];
    % time_window = [0.014092, 0.027308, 0.052912, 0.10247, 0.19837, 0.38404,0.74346,1.4384,];
    time_window = logspace(log10(0.05), log10(1.5), 15)
    
    for diameter_hop  = diameter_hop_vec
        count = 1;
        data_shecduled_instace = zeros(length(time_window),6);
        for time_shreshold = time_window
            if diameter_hop==2
                results = star_res(:,7:12);
                data_shecduled_instace(count,:) = sum(results<=time_shreshold,1)/1000; 
            elseif diameter_hop==49
                results = chain_res(:,7:12);
                data_shecduled_instace(count,:) = sum(results<=time_shreshold,1)/1000; 
            else
                ER_res_withdia = ER_res(ER_res(:,13) == diameter_hop, :);
                results = ER_res_withdia(:,7:12);
                data_shecduled_instace(count,:) = sum(results<=time_shreshold,1)/size(results,1);  
            end
            count = count+1;
        end
    
        fig = figure; hold on;
        colors = ["#D08082", "#C89FBF", "#62ABC7", "#7A7DB1", "#6FB494", "#D9B382"];
        for i = 1:2
            if i==1
                plot(time_window, data_shecduled_instace(:,i), 's-', 'Color', colors(i), 'LineWidth', 3.5, 'MarkerSize', 10);
            else
                plot(time_window, data_shecduled_instace(:,i), 'o--', 'Color', colors(i), 'LineWidth', 3.5, 'MarkerSize', 10);
            end
        end
        
        % 图像美化
        ax = gca;  % Get current axis
        ax.FontSize = 20;  % Set font size for tick label
        xlim([0.03 2])
        set(gca,"xscale",'log')
        ylim([-0.05 1.05])
        % xticklabels({'10','20','50','100'})
        xlabel('$t$',Interpreter='latex',FontSize=24);
        ylabel('$n_{SI}/n_{simu}$','interpreter','latex',FontSize=30)
        % lgd = legend({'LPLW', '$b_n = 2$'}, 'interpreter','latex','Location', 'southeast',FontSize=20);
        % lgd.NumColumns = 2;
        % set(legend);
        box on
        hold off
        picname = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\diff_diameter\\sheduled_instance%d_LPvsQiu_diffdiameter_randomrequirements.pdf",diameter_hop);
        exportgraphics(fig, picname,'BackgroundColor', 'none','Resolution', 600);
    end
end


function [time_window, res] = extract_data_diffrho_sheduled_instances2(resultdata,time_window)      
    count = 1;
    data_shecduled_instace = zeros(length(time_window),6);
    result = resultdata;
    results = result(:,7:12);
    cumulative_time = cumsum(results, 1);
    max(cumulative_time) 
    for time_shreshold = time_window      
        data_shecduled_instace(count,:) = sum(cumulative_time<=time_shreshold,1)/size(resultdata,1); 
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
            plot(time_window, sheduled_instances_res(:,i), 's-', 'Color', colors(count), 'LineWidth', 3.5, 'MarkerSize', 10);
        else
            plot(time_window, sheduled_instances_res(:,i), 'o--', 'Color', colors(count), 'LineWidth', 3.5, 'MarkerSize', 10);
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
    % 2,10,15,20,49
    % lgd = legend({'LPLW, $\rho = 2$', 'DBS, $\rho = 2$', 'LPLW, $\rho = 10$', 'DBS, $\rho = 10$','LPLW, $\rho = 15$', 'DBS, $\rho = 15$', 'LPLW, $\rho = 20$', 'DBS, $\rho = 20$','LPLW, $\rho = 49$', 'DBS, $\rho = 49$'}, 'Position', [0.6, 0.45, 0.2, 0.1],'interpreter','latex',FontSize=20);
    lgd = legend({'LPLW, $\rho = 2$', 'DBS, $\rho = 2$','LPLW, $\rho = 15$', 'DBS, $\rho = 15$', 'LPLW, $\rho = 49$', 'DBS, $\rho = 49$'}, 'Position', [0.6, 0.42, 0.2, 0.1],'interpreter','latex',FontSize=20);

    box on
    hold off
    
    picname = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\diff_diameter\\sheduled_instance_all_LPvsQiu_diffrho_n%d.pdf",N);
    exportgraphics(fig, picname,'BackgroundColor', 'none','Resolution', 600);

end






