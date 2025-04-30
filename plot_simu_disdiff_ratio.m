clear,clc
N_vec = [10,20,50,100];
data_mean = zeros(length(N_vec),6);
data_std = zeros(length(N_vec),6);
count = 1;
% LPvsQiu_N%dhavetime
% LPvsQiu_N%dExactsolutonhavetime
% LPvsQiu_N%dhavetimetest
% LPvsQiu_N%dPerturbationhavetime
% LPvsQiu_N%dPerturbation01havetime

for N = N_vec
    filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\LPvsQiu_N%dhavetime.txt",N);
    results = readmatrix(filename);
    results = results(:,1:6);
    results = results./results(:,1);
    mean_values = mean(results);
    std_values = std(results);
    data_mean(count,:) = mean_values;
    data_std(count,:) = std_values;
    count = count+1;
end

fig = figure; hold on;
colors = ["#D08082", "#C89FBF", "#62ABC7", "#7A7DB1", "#6FB494", "#D9B382"];
x = 1:4;
for i = 1:6
    if i==1
        errorbar(x, data_mean(:,i), data_std(:,i), 's-', 'Color', colors(i), 'LineWidth', 3, 'MarkerSize', 8);
    else
        errorbar(x, data_mean(:,i), data_std(:,i), 'o--', 'Color', colors(i), 'LineWidth', 3, 'MarkerSize', 8);
    end
end

% 图像美化
ax = gca;  % Get current axis
ax.FontSize = 14;  % Set font size for tick label
xlim([0.7 4.5])
% ylim([0.2 0.6])
xticks([1 2 3 4])
xticklabels({'10','20','50','100'})
xlabel('$N$',Interpreter='latex',FontSize=20);
% ylabel('$\frac{\sum_{i}\sum_{j}|d_{ij}-s_{ij}|}{\sum_{i}\sum_{j}d_{ij}}$','interpreter','latex',FontSize=20)
ylabel('$\frac{u \cdot |D-S|\cdot u^T}{u \cdot D \cdot u^T}$','interpreter','latex',FontSize=24)
lgd = legend({'LPLW', '$b_n = 2$', '$b_n = 0.25L$', '$b_n = 0.50L$', '$b_n = 0.75L$', '$b_n = L$'}, 'interpreter','latex','Location', 'northeast',FontSize=18);
lgd.NumColumns = 2;
% set(legend, 'Position', [0.64, 0.66, 0.2, 0.08]);
box on
hold off

picname = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\LPvsQiu_ratio.pdf");
exportgraphics(fig, picname,'BackgroundColor', 'none','Resolution', 300);