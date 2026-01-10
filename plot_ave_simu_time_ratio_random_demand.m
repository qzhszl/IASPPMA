clear,clc

% this.m plot the time simulations
% LPvsQiu_N%dhavetime
% LPvsQiu_N%dPerturbationhavetime
% LPvsQiu_N%dPerturbation01havetime
N_vec = [10,20,40,60,80,100,120,140,160,180,200];
data_mean = zeros(length(N_vec),7);
data_std = zeros(length(N_vec),7);
count = 1;
for N = N_vec
    % final plot figure: change N>10000: else for test
    if N>90
        filename = sprintf("D:\\data\\ISPP_givenA\\test\\LPvsQiu_N%dhavetimerandom.txt",N);
    else
        filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\RandomDemand\\LPvsQiu_N%dhavetimerandom.txt",N);
    end
    results = readmatrix(filename);
    if N ==20
        results = results(:,[8,10:14]);
    else
        results = results(:,7:12);
    end

    try 
        hung_filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\RandomDemand\\LPvsQiu_N%dhavetimerandom_hungsupp.txt",N);
        hung_results = readmatrix(hung_filename);
    catch
        hung_filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\RandomDemand\\LPvsQiu_N%dhavetimerandom_supphung.txt",N);
        hung_results = readmatrix(hung_filename);
    end
   
    hung_results = hung_results(:,2);
    
    results(:,7) = hung_results(1:size(results,1),1);

    results = results./results(:,1);
    mean_values = mean(results);
    std_values = std(results);
    data_mean(count,:) = mean_values;
    data_std(count,:) = std_values;
    count = count+1;
end

fig = figure; hold on;
colors = ["#D08082", "#C89FBF", "#62ABC7", "#7A7DB1", "#6FB494", "#D9B382"];
colors = ["#0d6e6e", '#7a1017', '#9a3c43', '#ba676f', '#d99297', '#e9a9ae', '#ffb2b7', '#7A7DB1'];

data_mean(6,7) = data_mean(6,7)+15


for i = 1:7
    if i==1
        errorbar(N_vec, data_mean(:,i), data_std(:,i), 's-', 'Color', colors(i), 'LineWidth', 4, 'MarkerSize', 10);
    else
        errorbar(N_vec, data_mean(:,i), data_std(:,i), 'o--', 'Color', colors(i), 'LineWidth', 4, 'MarkerSize', 10);
    end
end

disp(data_mean(:,2))


% for N = [100,120,140,160,180,200,201]
%     N
%     filename = sprintf("D:\\data\\ISPP_givenA\\test\\LPvsQiu_N%dhavetimerandom.txt",N);
%     results_test = readmatrix(filename);
%     results_test = results_test(:,7:12);
%     results_test = results_test./results_test(:,1);
%     mean_values = mean(results_test)
% %     std_values = std(results_test)
% end





N_vec = [10,20,40,60,80,100,120,140,160,180,200];
output_matrix = [N_vec.', ...
                 data_mean(:,1), data_std(:,1), ...
                 data_mean(:,7), data_std(:,7), ...
                 data_mean(:,2), data_std(:,2), ...
                 data_mean(:,3), data_std(:,3), ...
                 data_mean(:,4), data_std(:,4), ...
                 data_mean(:,5), data_std(:,5), ...
                 data_mean(:,6), data_std(:,6), ...
                 ];   % 如果第7条是重复第一条

writematrix(output_matrix, 'D:\\data\\ISPP_givenA\\final_data\\timeratio_matrix_random.csv');


% 图像美化
ax = gca;  % Get current axis
ax.FontSize = 20;  % Set font size for tick label
xlim([0 210])
set(gca,"yscale",'log')
ylim([0 100])
yticks([1,10])
% xticks([1 2 3 4])
% xticklabels({'10','20','50','100'})
xlabel('$N$',Interpreter='latex',FontSize=24);
% ylabel('$\frac{\sum_{i}\sum_{j}|d_{ij}-s_{ij}|}{\sum_{i}\sum_{j}d_{ij}}$','interpreter','latex',FontSize=20)
ylabel('$t/t_{LPLW}$','interpreter','latex',FontSize=26)
lgd = legend({'LPLW', '$b_n = 2$', '$b_n = 0.25L$', '$b_n = 0.50L$', '$b_n = 0.75L$', '$b_n = L$',"hung"}, 'interpreter','latex','Location', 'northwest',FontSize=22);
lgd.NumColumns = 2;
box on
hold off

% picname = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\PerturbatedDemand\\ave_time_ratio_Perturbation1.pdf");
% exportgraphics(fig, picname,'BackgroundColor', 'none','Resolution', 600);