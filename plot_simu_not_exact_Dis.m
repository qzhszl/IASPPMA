clear,clc
N_vec = [10,20,50];
data_mean = zeros(length(N_vec),6);
data_std = zeros(length(N_vec),6);
count = 1;
% LPvsQiu_N%dExactsolutonhavetime
% LPvsQiu_N%dhavetime
% LPvsQiu_N%dhavetimetest
% LPvsQiu_N%dPerturbation
% LPvsQiu_N%dPerturbation1havetime

for N = N_vec
    filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\LPvsQiu_N%dhavetimetestrandom.txt",N);
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
x = 1:3;
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
xlim([0.7 4.5])
ylim([0 0.03])
xticks([1 2 3 4])
xticklabels({'10','20','50','100'})
xlabel('$N$',Interpreter='latex',FontSize=24);
ylabel('$\frac{u \cdot |D-S|\cdot u^T}{u \cdot D \cdot u^T}$','interpreter','latex',FontSize=30)
% lgd = legend({'LPLW', '$b_n = 2$', '$b_n = 0.25L$', '$b_n = 0.50L$', '$b_n = 0.75L$', '$b_n = L$'}, 'interpreter','latex','Location', 'northeast',FontSize=23.5);
% lgd.NumColumns = 2;
% set(legend, 'Position', [0.446, 0.73, 0.2, 0.1]);
box on
hold off

picname = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\randomtestNotExactLPvsQiu.pdf");
exportgraphics(fig, picname,'BackgroundColor', 'none','Resolution', 600);