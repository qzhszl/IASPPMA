clear,clc
%LPvsQiu_N%dPerturbation1havetime
% Perturbation1 means the perturbation is randomly from [0,1]
N_vec = [10,20,40,60,80,100,120,140,160,180,200];


data_mean = zeros(length(N_vec),6);
data_std = zeros(length(N_vec),6);
count = 1;
for N = N_vec
    filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\PerturbatedDemand\\LPvsQiu_N%dPerturbation1havetime.txt",N);
    results = readmatrix(filename);
    results = results(:,1:6);
    mean_values = mean(results);
    std_values = std(results);
    data_mean(count,:) = mean_values;
    data_std(count,:) = std_values;
    count = count+1;
end

fig = figure; hold on;
% colors = ["#D08082", "#C89FBF", "#62ABC7", "#7A7DB1", "#6FB494", "#D9B382"];
colors = ["#0d6e6e", '#7a1017', '#9a3c43', '#ba676f', '#d99297', '#e9a9ae', '#ffb2b7', '#7A7DB1'];
for i = 1:6
    if i==1
        errorbar(N_vec, data_mean(:,i), data_std(:,i), 's-', 'Color', colors(i), 'LineWidth', 2, 'MarkerSize', 20,'CapSize',15);
        errorbar(N_vec, data_mean(:,1), data_std(:,1), '^-', 'Color', colors(8), 'LineWidth', 2, 'MarkerSize', 15,'CapSize',12);
    else
        errorbar(N_vec, data_mean(:,i), data_std(:,i), 'o--', 'Color', colors(i), 'LineWidth', 2, 'MarkerSize', 8,'CapSize',10);
    end
end




%output_data
output_matrix = [N_vec.', ...
                 data_mean(:,1), data_std(:,1), ...
                 data_mean(:,1), data_std(:,1), ...
                 data_mean(:,2), data_std(:,2), ...
                 data_mean(:,3), data_std(:,3), ...
                 data_mean(:,4), data_std(:,4), ...
                 data_mean(:,5), data_std(:,5), ...
                 data_mean(:,6), data_std(:,6), ...
                 ];   % 如果第7条是重复第一条

writematrix(output_matrix, 'D:\\data\\ISPP_givenA\\final_data\\output_matrix.csv');


% filename = 'Perturbation.txt';
% 
% colnames = {'N', ...
%             'LPLW','std_LPLW', ...
%             'Hung','std_Hung', ...
%             'm2','std_m2', ...
%             'm25L','std_m25L', ...
%             'm50L','std_m50L', ...
%             'm75L','std_m75L', ...
%             'mL','std_mL'};
% 
% 
% % 1️⃣ 写入列名（第一行）
% writecell(colnames, filename, 'Delimiter', ',');
% 
% % 2️⃣ 追加数据
% writematrix(output_matrix, filename, 'Delimiter', ',', 'WriteMode', 'append');
% 
% disp('写入完成！')




% 图像美化
ax = gca;  % Get current axis
ax.FontSize = 20;  % Set font size for tick label

ax.TickLength = [0.02 0.01];
ax.LineWidth = 1;
xlim([0 210])
% ylim([0.005 0.04])
set(gca,'Yscale','log')
yticks([1e-2 2e-2])
% yticklabels({'10^{-2}','2\times10^{-2}'})
% xticks([1 2 3 4 5])
% xticklabels({'10','20','50','100','200'})
xlabel('$N$',Interpreter='latex',FontSize=24);
ylabel('$\|D-S\|$','interpreter','latex',FontSize=24)
lgd = legend({'LPLW', 'Hung', '$m = 2$', '$m = 0.25L$', '$m = 0.50L$', '$m = 0.75L$', '$m = L$'}, 'interpreter','latex','Location', 'northeast',FontSize=20);
lgd.NumColumns = 2;
lgd.ItemTokenSize = [30 500];
% lgd.IconColumnWidth = lgd.FontSize;
set(legend, 'Position', [0.485, 0.71, 0.2, 0.1]);
box on
hold off

% set(fig, 'Color', 'none');

% Save as SVG

picname = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\PerturbatedDemand\\Norm_pertubatedtree_withhung2.pdf");
exportgraphics(fig, picname,'ContentType', 'vector','BackgroundColor', 'none','Resolution', 600);
% print(fig, picname, '-dsvg');