clear,clc
%LPvsQiu_N%dPerturbation1havetime
% Perturbation1 means the perturbation is randomly from [0,1]


N_vec = [10,20,50,100,200];
% N_vec = [200]
data_mean = zeros(length(N_vec),6);
data_std = zeros(length(N_vec),6);
count = 1;
for N = N_vec
    filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\RandomDemand\\LPvsQiu_N%dhavetime.txt",N);
    results = readmatrix(filename);
    results = results(:,1:6);
    mean_values = mean(results);
    std_values = std(results);
    data_mean(count,:) = mean_values;
    data_std(count,:) = std_values;
    count = count+1;
end

B = data_mean(:, 2:2:end) - data_mean(:, 1:2:end)



fig = figure; hold on;
colors = ["#D08082", "#C89FBF", "#62ABC7", "#7A7DB1", "#6FB494", "#D9B382"];
x = 1:5;
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
exportgraphics(fig, picname,'ContentType', 'vector','BackgroundColor', 'none','Resolution', 600);
% print(fig, picname, '-dsvg');