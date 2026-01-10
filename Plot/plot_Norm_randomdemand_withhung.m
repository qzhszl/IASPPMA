clear,clc
%LPvsQiu_N%dPerturbation1havetime
% Perturbation1 means the perturbation is randomly from [0,1]


N_vec = [10,20,40,60,80,100,120,140,160,180,200];
% N_vec = [200]
data_mean = zeros(length(N_vec),6);
data_std = zeros(length(N_vec),6);
count = 1;


figure
hold on
for N = N_vec
    % final plot figure: change N>10000: else for test
    if N>90
        filename = sprintf("D:\\data\\ISPP_givenA\\test\\LPvsQiu_N%dhavetimerandom.txt",N);
    else
        filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\RandomDemand\\LPvsQiu_N%dhavetimerandom.txt",N);
    end
    results = readmatrix(filename);
    if size(results,2)==14  
        results = results(:,[1,3:7]);
    else
        results = results(:,1:6);
    end
    check_results = results(:,3:5);
    
    
    if N>100 
        histogram(results(:,1), ...
            'Normalization','probability', ...
            'DisplayStyle','stairs', ...
            'LineWidth',1.5)
    end
    

    mean_values = mean(results);
    std_values = std(results)
    data_mean(count,:) = mean_values;
    data_std(count,:) = std_values;
    count = count+1;
end
hold off
legend

% for N = [100,120,140,160,180,200,201]
%     N
%     filename = sprintf("D:\\data\\ISPP_givenA\\test\\LPvsQiu_N%dhavetimerandom.txt",N);
%     results_test = readmatrix(filename);
%     results_test = results_test(:,1:6);
%     mean_values = mean(results_test)
%     std_values = std(results_test)
% end





output_matrix = [N_vec.', ...
                 data_mean(:,1), data_std(:,1), ...
                 data_mean(:,1), data_std(:,1), ...
                 data_mean(:,2), data_std(:,2), ...
                 data_mean(:,3), data_std(:,3), ...
                 data_mean(:,4), data_std(:,4), ...
                 data_mean(:,5), data_std(:,5), ...
                 data_mean(:,6), data_std(:,6), ...
                 ];   % 如果第7条是重复第一条

% writematrix(output_matrix, 'D:\\data\\ISPP_givenA\\final_data\\norm_matrix_random_demand.csv');



fig = figure; hold on;
colors = ["#D08082", "#C89FBF", "#62ABC7", "#7A7DB1", "#6FB494", "#D9B382"];
for i = 1:6
    if i==1
        errorbar(N_vec, data_mean(:,i), data_std(:,i), 's-', 'Color', colors(i), 'LineWidth', 4, 'MarkerSize', 15,'CapSize',12);
    else
        errorbar(N_vec, data_mean(:,i), data_std(:,i), 'o--', 'Color', colors(i), 'LineWidth', 4, 'MarkerSize', 10,'CapSize',10);
    end
end

% 图像美化
ax = gca;  % Get current axis
ax.FontSize = 20;  % Set font size for tick label
xlim([0 210])
% ylim([0.005 0.04])
% xticks([1 2 3 4 5])
% xticklabels({'10','20','50','100','200'})
xlabel('$N$',Interpreter='latex',FontSize=24);
ylabel('$\|D-S\|$','interpreter','latex',FontSize=24)
% lgd = legend({'LPLW', '$b_n = 2$', '$b_n = 0.25L$', '$b_n = 0.50L$', '$b_n = 0.75L$', '$b_n = L$'}, 'interpreter','latex','Location', 'northeast',FontSize=23.5);
% lgd.NumColumns = 2;
% set(legend, 'Position', [0.446, 0.73, 0.2, 0.1]);
box on
hold off

% set(fig, 'Color', 'none');

% Save as SVG

picname = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\RandomDemand\\Norm_randomdemand.pdf");
% exportgraphics(fig, picname,'ContentType', 'vector','BackgroundColor', 'none','Resolution', 600);
% print(fig, picname, '-dsvg');