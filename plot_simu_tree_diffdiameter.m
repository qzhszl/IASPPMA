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
ER_res = [ER_res1;ER_res2;ER_res3];
a = ER_res(:,13);
tabulate(a)
max(ER_res(:,7))

diameter_hop_vec = [2,10,15,20,49];
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


% plot_time(diameter_hop_vec,star_res,chain_res,ER_res)


% plot_norm(data_mean,data_std)

% plot_scheduled_time(data_mean,data_std)

plot_scheduled_instances(diameter_hop_vec,star_res,chain_res,ER_res)
function plot_time(diameter_hop_vec,star_res,chain_res,ER_res)
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
    picname = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\diff_diameter\\timeratio_LPvsQiu_diffdiameter_randomrequirements.pdf");
    exportgraphics(fig, picname,'BackgroundColor', 'none','Resolution', 600);
end


function plot_norm(data_mean,data_std)
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
    ax.FontSize = 20;  % Set font size for tick label
    % xlim([0.7 4.5])
    ylim([0 0.6])
    xticks([0 10 20 30 40 50])
    % xticklabels({'10','20','50','100'})
    xlabel('$\rho$',Interpreter='latex',FontSize=24);
    ylabel('$\frac{u \cdot |D-S|\cdot u^T}{u \cdot D \cdot u^T}$','interpreter','latex',FontSize=30)
    lgd = legend({'LPLW', '$b_n = 2$', '$b_n = 0.25L$', '$b_n = 0.50L$', '$b_n = 0.75L$', '$b_n = L$'}, 'interpreter','latex','Location', 'southeast',FontSize=20);
    % lgd.NumColumns = 2;
    % set(legend);
    box on
    hold off
    
    picname = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\diff_diameter\\norm_LPvsQiu_diffdiameter_randomrequirements.pdf");
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



