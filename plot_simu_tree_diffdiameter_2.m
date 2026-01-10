clear,clc
% plot the tree with different hopcount of the diameter
% from a star to a line network
% Compared to the first version, this one load data with specific length directly

clear,clc
% Nvec = [10,20,50,100];
N=50;
input_diameter_vec = [2,5,10,15,20,25,30,35,40,45,49];
% input_diameter_vec = [2,9];

data_mean = zeros(length(input_diameter_vec),14);
data_std = zeros(length(input_diameter_vec),14);
data_shecduled_instace = zeros(length(input_diameter_vec),6);
count=1;

for diameter = input_diameter_vec
    filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\diff_diameter\\LPvsQiu_N%dhavetime_randominput_tree%diameter%d.txt",N,diameter);
    filename = sprintf("D:\\data\\ISPP_givenA\\test\\difftopology\\LPvsQiu_N%dhavetime_randominput_tree%diameter%d.txt",N,diameter)
    result_eachparameter = readmatrix(filename);
    time_values = mean(result_eachparameter);
    data_mean(count,:) = time_values;
    data_std(count,:) = std(result_eachparameter);
    count = count+1;
end



% plot_time(N,input_diameter_vec)
% 
% plot_norm(N,data_mean,data_std)

plot_max_finish_time(N,input_diameter_vec)

% plot_scheduled_instances(N)


function plot_time(N,diameter_hop_vec)
    data_mean = zeros(length(diameter_hop_vec),7);
    data_std = zeros(length(diameter_hop_vec),7);
    count = 1;    
    for diameter_hop  = diameter_hop_vec
        filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\diff_diameter\\LPvsQiu_N%dhavetime_randominput_tree%diameter%d.txt",N,diameter_hop);
        filename = sprintf("D:\\data\\ISPP_givenA\\test\\difftopology\\LPvsQiu_N%dhavetime_randominput_tree%diameter%d.txt",N,diameter_hop)

        results = readmatrix(filename);
        results = results(:,8:14);
        results = results./results(:,1);
        mean_values = mean(results);
        std_values = std(results);
        data_mean(count,:) = mean_values;
        data_std(count,:) = std_values;
        count = count+1;
    end
    fig = figure; hold on;
    colors = ["#0d6e6e", '#7a1017', '#9a3c43', '#ba676f', '#d99297', '#e9a9ae', '#ffb2b7', '#7A7DB1'];
    
    x = diameter_hop_vec;
    for i = 1:7
        if i==1
            errorbar(x, data_mean(:,i), data_std(:,i), 's-', 'Color', colors(i), 'LineWidth', 4, 'MarkerSize', 10);
        else
            errorbar(x, data_mean(:,i), data_std(:,i), 'o--', 'Color', colors(i), 'LineWidth', 4, 'MarkerSize', 10);
        end
    end
    
    output_matrix = [x.', ...
                 data_mean(:,1), data_std(:,1), ...
                 data_mean(:,2), data_std(:,2), ...
                 data_mean(:,3), data_std(:,3), ...
                 data_mean(:,4), data_std(:,4), ...
                 data_mean(:,5), data_std(:,5), ...
                 data_mean(:,6), data_std(:,6), ...
                 data_mean(:,7), data_std(:,7), ...
                 ];   % 如果第7条是重复第一条

    writematrix(output_matrix, 'D:\\data\\ISPP_givenA\\final_data\\time_ratio_matrix_diffdiameter.csv');



    
    % 图像美化
    ax = gca;  % Get current axis
    ax.FontSize = 20;  % Set font size for tick label
    xlim([0 52])
    set(gca,"yscale",'log')
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
%     picname = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\diff_diameter\\timeratio_LPvsQiu_diffdiameter_randomrequirements_N%d.pdf",N);
%     exportgraphics(fig, picname,'BackgroundColor', 'none','Resolution', 600);
end


function plot_norm(N,data_mean,data_std)
    fig = figure; hold on;
    colors = ["#0d6e6e", '#7a1017', '#9a3c43', '#ba676f', '#d99297', '#e9a9ae', '#ffb2b7', '#7A7DB1'];
    x = [2,5,10,15,20,25,30,35,40,45,49];
    for i = 1:7
        if i==1
            errorbar(x, data_mean(:,i), data_std(:,i), 's-', 'Color', colors(i), 'LineWidth', 4, 'MarkerSize', 10,'CapSize',10);
        else
            errorbar(x, data_mean(:,i), data_std(:,i), 'o--', 'Color', colors(i), 'LineWidth', 4, 'MarkerSize', 10,'CapSize',10);
        end
    end
    output_matrix = [x.', ...
                 data_mean(:,1), data_std(:,1), ...
                 data_mean(:,1), data_std(:,1), ...
                 data_mean(:,3), data_std(:,3), ...
                 data_mean(:,4), data_std(:,4), ...
                 data_mean(:,5), data_std(:,5), ...
                 data_mean(:,6), data_std(:,6), ...
                 data_mean(:,7), data_std(:,7), ...
                 ];   % 如果第7条是重复第一条

    writematrix(output_matrix, 'D:\\data\\ISPP_givenA\\final_data\\norm_matrix_diffdiameter.csv');


    
    % 图像美化
    ax = gca;  % Get current axis
    ax.FontSize = 24;  % Set font size for tick label
    % xlim([0.7 4.5])
    ylim([0 0.6])
    xticks([0 10 20 30 40 50])
    % xticklabels({'10','20','50','100'})
    xlabel('$\rho$',Interpreter='latex',FontSize=26);
    ylabel('$\|D-S\|$','interpreter','latex',FontSize=26)
    lgd = legend({'LPLW', 'HUNG','$b_n = 2$', '$b_n = 0.25L$', '$b_n = 0.50L$', '$b_n = 0.75L$', '$b_n = L$'}, 'interpreter','latex','Location', 'southeast',FontSize=20);
    % lgd.NumColumns = 2;
    % set(legend);
    box on
    hold off
    
%     picname = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\diff_diameter\\norm_LPvsQiu_diffdiameter_randomrequirements_N%d.pdf",N);
%     exportgraphics(fig, picname,'BackgroundColor', 'none','Resolution', 600);
end



function plot_max_finish_time(N,diameter_hop_vec)
    data_mean = zeros(length(diameter_hop_vec),2);
    data_std = zeros(length(diameter_hop_vec),7);
    count = 1;    
    for diameter_hop  = diameter_hop_vec
%         filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\diff_diameter\\LPvsQiu_N%dhavetime_randominput_tree%diameter%d.txt",N,diameter_hop);
        filename = sprintf("D:\\data\\ISPP_givenA\\test\\difftopology\\LPvsQiu_N%dhavetime_randominput_tree%diameter%d.txt",N,diameter_hop);

        results = readmatrix(filename);
        results = results(:,[8,10]);
        
        mean_values = max(results);
%         std_values = std(results);
        data_mean(count,:) = mean_values;
%         data_std(count,:) = std_values;
        count = count+1;
    end
    fig = figure; hold on;
    colors = ["#0d6e6e", '#7a1017', '#9a3c43', '#ba676f', '#d99297', '#e9a9ae', '#ffb2b7', '#7A7DB1'];
%     data_mean(6,:)= data_mean(6,:)+0.1
%     data_mean(7,:)= data_mean(7,:)-0.1
%     data_mean(10,:)= data_mean(10,:)-0.2
%     data_mean(10,2)= data_mean(10,2)-0.02

    N=50;
    diameter_hop=35
    filename = sprintf("D:\\data\\ISPP_givenA\\test\\LPvsQiu_N%dhavetime_randominput_tree%diameter%d.txt",N,diameter_hop);
    results_test = readmatrix(filename);
    results_test = results_test(:,[8,10]);
    MAXTEST = max(results_test)
    MAXTEST(2)/MAXTEST(1)
%     data_mean(10,2)


    x = diameter_hop_vec;
    for i = 1:2
        if i==1
            plot(x, data_mean(:,i)./data_mean(:,1),  's-', 'Color', colors(i), 'LineWidth', 4, 'MarkerSize', 10);
        else
            plot(x, data_mean(:,i)./data_mean(:,1),  'o--', 'Color', colors(i), 'LineWidth', 4, 'MarkerSize', 10);
        end
    end
    
    output_matrix = [x.', ...
                 data_mean(:,1), ...
                 data_mean(:,2), ...
                 ];   % 如果第7条是重复第一条

    writematrix(output_matrix, 'D:\\data\\ISPP_givenA\\final_data\\max_finish_time_matrix_diffdiameter.csv');

    
    % 图像美化
    ax = gca;  % Get current axis
    ax.FontSize = 20;  % Set font size for tick label
    xlim([0 52])
    set(gca,"yscale",'log')
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
%     picname = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\diff_diameter\\timeratio_LPvsQiu_diffdiameter_randomrequirements_N%d.pdf",N);
%     exportgraphics(fig, picname,'BackgroundColor', 'none','Resolution', 600);
end



function plot_scheduled_instances(N)
    % time_window = [0.001, 0.001937, 0.003753, 0.007272, 0.014092, 0.027308, 0.052912, 0.10247, 0.19837, 0.38404,0.74346,1.4384,];
    % time_window = [0.014092, 0.027308, 0.052912, 0.10247, 0.19837, 0.38404,0.74346,1.4384,];
    diameter_hop_vec = [2,25,49];
    time_window = logspace(log10(0.05), log10(0.6), 50);
    diameter_count =1;
    data_shecduled_instace = zeros(length(time_window),6);

    for diameter_hop  = diameter_hop_vec
        count = 1;
        Lplw_sheduled_instance=  zeros(length(time_window),1);
        dbs_sheduled_instance = zeros(length(time_window),1);
        
        for time_shreshold = time_window
            filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\diff_diameter\\LPvsQiu_N%dhavetime_randominput_tree%diameter%d.txt",N,diameter_hop);
            results_0 = readmatrix(filename);
            results = results_0(:,8);
%             a = sum(results<=time_shreshold,1)/1000
            Lplw_sheduled_instance(count) = sum(results<=time_shreshold,1)/1000; 
            results = results_0(:,10);
            dbs_sheduled_instance(count) = sum(results<=time_shreshold,1)/1000; 
            

            count = count+1;
        end
        data_shecduled_instace(:,2*diameter_count-1) = Lplw_sheduled_instance;
        data_shecduled_instace(:,2*diameter_count) = dbs_sheduled_instance;
        diameter_count = diameter_count+1;

    end

    
    output_matrix = [time_window.', data_shecduled_instace
                 ];

    writematrix(output_matrix, 'D:\\data\\ISPP_givenA\\final_data\\scheduled_instance_matrix_diffdiameter.csv');





    fig = figure; hold on;
    colors = ["#D08082", "#C89FBF", "#62ABC7", "#7A7DB1", "#6FB494", "#D9B382"];
    for i = 1:6
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






