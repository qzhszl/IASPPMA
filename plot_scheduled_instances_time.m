clear,clc

% this.m plot the time simulations
% LPvsQiu_N%dPerturbation1havetime
% LPvsQiu_N%dhavetime
% LPvsQiu_N%dhavetimetest


N_vec = [10,20,50,100];
data_mean = zeros(length(N_vec),6);
count = 1;
for N = N_vec
    filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\LPvsQiu_N%dhavetime.txt",N);
    results = readmatrix(filename);
    results = results(:,7:12);
    
    time_values = max(results);
    data_mean(count,:) = time_values;
    
    count = count+1;
end

fig = figure; hold on;
colors = ["#D08082", "#C89FBF", "#62ABC7", "#7A7DB1", "#6FB494", "#D9B382"];

x = 1:4;
for i = 1:6
    if i==1
        plot(x, data_mean(:,i), 's-', 'Color', colors(i), 'LineWidth', 4, 'MarkerSize', 10);
    else
        plot(x, data_mean(:,i), 'o--', 'Color', colors(i), 'LineWidth', 4, 'MarkerSize', 10);
    end
end

% 图像美化
ax = gca;  % Get current axis
ax.FontSize = 20;  % Set font size for tick label
xlim([0.7 4.5])
% set(gca,"yscale",'log')
% ylim([0 8])
% yticks([0,1,2,3,4,5,6,7])
xticks([1 2 3 4])
xticklabels({'10','20','50','100'})
xlabel('$N$',Interpreter='latex',FontSize=24);
% ylabel('$\frac{\sum_{i}\sum_{j}|d_{ij}-s_{ij}|}{\sum_{i}\sum_{j}d_{ij}}$','interpreter','latex',FontSize=20)
ylabel('$t_f$(sec)','interpreter','latex',FontSize=30)
lgd = legend({'LPLW', '$b_n = 2$', '$b_n = 0.25L$', '$b_n = 0.50L$', '$b_n = 0.75L$', '$b_n = L$'}, 'interpreter','latex','Location', 'northwest',FontSize=24);
lgd.NumColumns = 1;
box on
hold off

picname = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\Notexactscheduled_instance_timeall.pdf");
exportgraphics(fig, picname,'BackgroundColor', 'none','Resolution', 600);