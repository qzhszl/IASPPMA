clear,clc

% this.m plot the time simulations

N_vec = [10,20,50,100];
data_mean = zeros(length(N_vec),6);
data_std = zeros(length(N_vec),6);
count = 1;
for N = N_vec
    filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\small1LPvsQiu_N%dhavetime.txt",N);
    results = readmatrix(filename);
    results = results(:,7:12);
    mean_values = mean(results);
    std_values = std(results);
    data_mean(count,:) = mean_values;
    data_std(count,:) = std_values;
    count = count+1;
end

fig = figure; hold on;
colors = lines(6); % 获取 6 种不同的颜色

x = 1:4;
for i = 1:6
    errorbar(x, data_mean(:,i), data_std(:,i), 'o-', 'Color', colors(i,:), 'LineWidth', 3, 'MarkerSize', 8);
end

% 图像美化
ax = gca;  % Get current axis
ax.FontSize = 14;  % Set font size for tick label
xlim([0.7 4.5])
set(gca,"yscale",'log')
% ylim([0 0.4])
xticks([1 2 3 4])
xticklabels({'10','20','50','100'})
xlabel('$N$',Interpreter='latex',FontSize=20);
% ylabel('$\frac{\sum_{i}\sum_{j}|d_{ij}-s_{ij}|}{\sum_{i}\sum_{j}d_{ij}}$','interpreter','latex',FontSize=20)
ylabel('$E[T]$','interpreter','latex',FontSize=24)
legend({'LP', 'bn = $2$', 'bn = $0.25L$', 'bn = $0.50L$', 'bn = $0.75L$', 'bn = $L$'}, 'interpreter','latex','Location', 'northeast',FontSize=18);
set(legend, 'Position', [0.24, 0.66, 0.2, 0.08]);
box on
hold off

picname = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\small1NotExactsolutionLPvsQiuTime.pdf");
exportgraphics(fig, picname,'BackgroundColor', 'none','Resolution', 300);