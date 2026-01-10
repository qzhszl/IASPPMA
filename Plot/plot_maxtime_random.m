clear,clc

% this.m plot the time simulations
% LPvsQiu_N%dPerturbation1havetime
% LPvsQiu_N%dhavetime
% LPvsQiu_N%dhavetimetest


% N_vec = [10,20,50,100,200];
N_vec = [10,20,40,60,80,100,120,140,160,180,200];



data_mean = zeros(length(N_vec),6);
count = 1;
for N = N_vec

    if N>90
        filename = sprintf("D:\\data\\ISPP_givenA\\test\\LPvsQiu_N%dhavetimerandom.txt",N);
    else
        filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\RandomDemand\\LPvsQiu_N%dhavetimerandom.txt",N);
    end

    results = readmatrix(filename);


    if size(results,2)==12
        results = results(:,7:12);
    else
        results = results(:,[8,10:14]);
    end
    
    results = results(1:size(results,1),:);
    
%     try 
%         hung_filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\PerturbatedDemand\\LPvsQiu_N%dPerturbation1havetime_hungsupp.txt",N);
%         hung_results = readmatrix(hung_filename);
%     catch
%         hung_filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\PerturbatedDemand\\LPvsQiu_N%dPerturbation1_supphung.txt",N);
%         hung_results = readmatrix(hung_filename);
%     end
   
%     hung_results = hung_results(:,2);
%     max(hung_results)

    time_values = max(results);
    data_mean(count,:) = time_values;
    
    count = count+1;
end

% N = 20
% filename = sprintf("D:\\data\\ISPP_givenA\\test\\LPvsQiu_N%dhavetimerandom.txt",N);
% results = readmatrix(filename);
% results = results(:,8:14);
% time_values = max(results)


fig = figure; hold on;
colors = ["#D08082", "#C89FBF", "#62ABC7", "#7A7DB1", "#6FB494", "#D9B382"];

data_mean(11,1) = 1.075713520000000e+02;
data_mean(11,2) = 62.704972000000000;
x = 1:5;
for i = [1,2]
    if i==1
        plot(N_vec, data_mean(:,i)./data_mean(:,1), 's-', 'Color', colors(i), 'LineWidth', 4, 'MarkerSize', 10);
    else
        plot(N_vec, data_mean(:,i)./data_mean(:,1), 'o--', 'Color', colors(i), 'LineWidth', 4, 'MarkerSize', 10);
    end
end


output_matrix = [N_vec.', data_mean(:,1),data_mean(:,2)
                 ];   % 如果第7条是重复第一条


writematrix(output_matrix, 'D:\\data\\ISPP_givenA\\final_data\\maxtime_matrix_random.csv');


% 图像美化
ax = gca;  % Get current axis
ax.FontSize = 20;  % Set font size for tick label
xlim([0 210])
% set(gca,"yscale",'log')
% ylim([0 8])
% yticks([0,1,2,3,4,5,6,7])
% xticks([1 2 3 4])
% xticklabels({'10','20','50','100'})
xlabel('$N$',Interpreter='latex',FontSize=24);
% ylabel('$\frac{\sum_{i}\sum_{j}|d_{ij}-s_{ij}|}{\sum_{i}\sum_{j}d_{ij}}$','interpreter','latex',FontSize=20)
ylabel('$t_f$(sec)','interpreter','latex',FontSize=30)
lgd = legend({'LPLW', '$b_n = 2$', '$b_n = 0.25L$', '$b_n = 0.50L$', '$b_n = 0.75L$', '$b_n = L$'}, 'interpreter','latex','Position', [0.67, 0.26, 0.2, 0.08],FontSize=24);
lgd.NumColumns = 1;
box on
hold off

set(fig, 'Color', 'none');

% picname = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\PerturbatedDemand\\Finishtime_perturbateddemand.svg");
% % exportgraphics(fig, picname,'BackgroundColor', 'none','Resolution', 600);
% print(fig, picname, '-dsvg');