clear,clc
% Siyudata
% Plot te data for what, for removing the shortest path
N_vec = [10,20,50,100];
N_vec = [200]
% dsmall = 0.7;
% dmid = 0.2;
% dlarge = 0.1;
% 
dsmall = 0.34;
dmid = 0.33;
dlarge = 0.33;

% dsmall = 0.5;
% dmid = 0.25;
% dlarge = 0.25;

plot_norm(N_vec, dsmall,dmid,dlarge)
plot_scheduled_time(N_vec, dsmall,dmid,dlarge)
% plot_scheduled_instances(N_vec, dsmall,dmid,dlarge)
%  0.4306    0.5437    0.5259    0.5043    0.4938    0.4307
% 0.4006    0.4919    0.4784    0.4586    0.4401    0.4009
% 0.3394    0.4397    0.4216    0.3997    0.3746    0.3403
% 0.2745    0.3969    0.3724    0.3416    0.3030    0.2762
% 0.2227    0.3659    0.3355    0.2955    0.2491    0.2287


function plot_norm(N_vec, dsmall,dmid,dlarge)
    data_mean = zeros(length(N_vec),6);
    data_std = zeros(length(N_vec),6);
    count = 1;

    for N = N_vec
        filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\SiyuData\\test\\Testfixdemand_N%ddataper%.2f%.2f%.2f_siyuinput_treefromERp05.txt",N,dsmall,dmid,dlarge);
        % filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\SiyuData\\test\\TestNotdistance_N%ddataper%.2f%.2f%.2f_siyuinput_treefromERp05.txt",N,dsmall,dmid,dlarge);
        % filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\SiyuData\\test\\Testsmalldemand_N%ddataper%.2f%.2f%.2f_siyuinput_treefromERp05.txt",N,dsmall,dmid,dlarge);
        filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\SiyuData\\discrete\\descretedemandLPvsQiu_N%ddataper%.2f%.2f%.2f_siyuinput_treefromERp05.txt",N,dsmall,dmid,dlarge);

        results = readmatrix(filename);
        results = results(:,1:6);
        mean_values = mean(results);
        std_values = std(results);
        data_mean(count,:) = mean_values;
        data_std(count,:) = std_values;
        count = count+1;
    end
    
    fig = figure; hold on;
    colors = ["#D08082", "#C89FBF", "#62ABC7", "#7A7DB1", "#6FB494", "#D9B382"];
    x = 1:length(N_vec);
    for i = 1:6
        if i==1
            errorbar(x, data_mean(:,i), data_std(:,i), 's-', 'Color', colors(i), 'LineWidth', 4, 'MarkerSize', 10,'CapSize',10);
        else
            errorbar(x, data_mean(:,i), data_std(:,i), 'o--', 'Color', colors(i), 'LineWidth', 4, 'MarkerSize', 10,'CapSize',10);
        end
    end
    data_mean
    % 图像美化
    ax = gca;  % Get current axis
    ax.FontSize = 20;  % Set font size for tick label
    xlim([0.7 4.5])
    % ylim([0 0.03])
    xticks([1 2 3 4])
    xticklabels({'10','20','50','100'})
    xlabel('$N$',Interpreter='latex',FontSize=24);
    ylabel('$\frac{u \cdot |D-S|\cdot u^T}{u \cdot D \cdot u^T}$','interpreter','latex',FontSize=30)
    % lgd = legend({'LPLW', '$b_n = 2$', '$b_n = 0.25L$', '$b_n = 0.50L$', '$b_n = 0.75L$', '$b_n = L$'}, 'interpreter','latex','Location', 'northeast',FontSize=23.5);
    % lgd.NumColumns = 2;
    % set(legend, 'Position', [0.446, 0.73, 0.2, 0.1]);
    box on
    hold off
    
%     picname = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\SiyuData\\normLPvsQiu_Siyudata_per%.2f%.2f%.2f.pdf",dsmall,dmid,dlarge);
%     exportgraphics(fig, picname,'BackgroundColor', 'none','Resolution', 600);
end



function plot_scheduled_time(N_vec, dsmall,dmid,dlarge)
    data_mean = zeros(length(N_vec),6);
    data_std = zeros(length(N_vec),6);
    count = 1;
    for N = N_vec
        filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\SiyuData\\test\\Testfixdemand_N%ddataper%.2f%.2f%.2f_siyuinput_treefromERp05.txt",N,dsmall,dmid,dlarge);
        filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\SiyuData\\test\\TestNotdistance_N%ddataper%.2f%.2f%.2f_siyuinput_treefromERp05.txt",N,dsmall,dmid,dlarge);
        filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\SiyuData\\test\\Testsmalldemand_N%ddataper%.2f%.2f%.2f_siyuinput_treefromERp05.txt",N,dsmall,dmid,dlarge);
        filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\SiyuData\\discrete\\descretedemandLPvsQiu_N%ddataper%.2f%.2f%.2f_siyuinput_treefromERp05.txt",N,dsmall,dmid,dlarge);
        results = readmatrix(filename);
        results = results(:,7:12);
        mean_values = mean(results);
        std_values = std(results);
        data_mean(count,:) = mean_values;
        data_std(count,:) = std_values;
        count = count+1;
    end
    
    fig = figure; hold on;
    colors = ["#D08082", "#C89FBF", "#62ABC7", "#7A7DB1", "#6FB494", "#D9B382"];
    data_mean
    x = 1:4;
    for i = 1:2
        if i==1
            errorbar(x, data_mean(:,i), data_std(:,i), 's-', 'Color', colors(i), 'LineWidth', 4, 'MarkerSize', 12);
        else
            errorbar(x, data_mean(:,i), data_std(:,i), 'o--', 'Color', colors(i), 'LineWidth', 4, 'MarkerSize', 12);
        end
    end
    
    % 图像美化
    ax = gca;  % Get current axis
    ax.FontSize = 20;  % Set font size for tick label
    xlim([0.7 4.5])
    % ylim([0 1000])
    
    % set(gca,"yscale",'log')
    % ylim([0 0.4])
    xticks([1 2 3 4])
    % yticks([0.01 1 100])
    xticklabels({'10','20','50','100'})
    xlabel('$N$',Interpreter='latex',FontSize=24);
    % ylabel('$\frac{\sum_{i}\sum_{j}|d_{ij}-s_{ij}|}{\sum_{i}\sum_{j}d_{ij}}$','interpreter','latex',FontSize=20)
    ylabel('$t_f$(sec)','interpreter','latex',FontSize=24)
    % lgd = legend({'LPLW', '$b_n = 2$', '$b_n = 0.25L$', '$b_n = 0.50L$', '$b_n = 0.75L$', '$b_n = L$'}, 'interpreter','latex','Location', 'northwest',FontSize=23.5);
    % lgd.NumColumns = 2;
    % set(legend, 'Position', [0.446, 0.73, 0.2, 0.1]);
    box on
    hold off
    
%     picname = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\SiyuData\\timeLPvsQiu_Siyudata_per%.2f%.2f%.2f.pdf",dsmall,dmid,dlarge);
%     exportgraphics(fig, picname,'BackgroundColor', 'none','Resolution', 300);
end


function plot_scheduled_instances(N_vec, dsmall,dmid,dlarge)
    data_shecduled_instace = zeros(length(N_vec),6);
    colors = ["#D08082", "#C89FBF", "#62ABC7", "#7A7DB1", "#6FB494", "#D9B382"];
    time_window = [0.001, 0.001937, 0.003753, 0.007272, 0.014092, 0.027308, 0.052912, 0.10247, 0.19837, 0.38404, 0.74346, 1.4384, 2.7826, 5.3849, 10.418, 20.173, 30];
    % time_window = [0.001, 2, 4, 6, 9, 11, 13, 15, 17, 19, 21, 24, 26, 28, 30]
    
    for N = N_vec
        count = 1;
        data_shecduled_instace = zeros(length(time_window),6);
        for time_shreshold = time_window
            filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\SiyuData\\LPvsQiu_N%ddataper%.2f%.2f%.2f_siyuinput_treefromERp05.txt",N,dsmall,dmid,dlarge);
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
        xlim([0.001 100])
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
    
    
        if N == 20
            lgd = legend({'LPLW', '$b_n = 2$'}, 'interpreter','latex','Location', 'northeast',FontSize=24);
            set(legend, 'Position', [0.54, 0.5, 0.2, 0.08]);
        end
    
    
        % if N> 50
        %     set(legend, 'Position', [0.28, 0.55, 0.2, 0.08]);
        % else
        %     set(legend, 'Position', [0.54, 0.5, 0.2, 0.08]);
        % end
    
        box on
        hold off
        
        picname = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\SiyuData\\sheduled_instance_LPvsQiu_Siyudata_Nnode%dper%.2f%.2f%.2f.pdf",N,dsmall,dmid,dlarge);
        exportgraphics(fig, picname,'BackgroundColor', 'none','Resolution', 600);
    end
end




