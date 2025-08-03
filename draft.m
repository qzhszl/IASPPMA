clear,clc
% plot the tree with different hopcount of the diameter
% from a star to a line network

param_sets = [0.5, 0.25, 0.25;
              0.25,0.5,0.25;
              0.25,0.25,0.5;
              0.34, 0.33, 0.33;
              ];

% param_sets = [
%               0.5,0.25,0.25;
%               0.34, 0.33, 0.33;
%               ];
N_vec = [200]
% 0.194756700355456	0.119769859336237	0.119769859336237	0.156598135553406
%                   0.1448                                  0.1432

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
end

plot_norm(N_vec,norm_mean,norm_std)

B = norm_mean(:, 2:2:end) - norm_mean(:, 1:2:end)


function [res_mean, res_std] = extract_data_foronepercentage_norm(N_vec, dsmall,dmid,dlarge)
    data_mean = zeros(length(N_vec),6);
    data_std = zeros(length(N_vec),6);
    count = 1;
    for N = N_vec
        % filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\SiyuData\\test\\descretedemandLPvsQiu_N%ddataper%.2f%.2f%.2f_siyuinput_treefromERp05.txt",N,dsmall,dmid,dlarge);
        % filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\SiyuData\\test\\LPvsQiu_N%ddataper%.2f%.2f%.2f_siyuinput_treefromERp05.txt",N,dsmall,dmid,dlarge);
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
    colors = [ "#C89FBF", "#7A7DB1", "#D9B382", "#6FB494"];
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
    
end