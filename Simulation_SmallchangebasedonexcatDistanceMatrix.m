% This .m will test the performance of our approximated method for 
% the IASPP with given adjacency matrix.
clear,clc
% Nvec = [10,20,50,100];
Nvec = [40,70,90];
simutimes = 1000;

for N = Nvec
    N
    result = zeros(simutimes,12);
    for i = 1:simutimes
        [distances_deviation1,distances_deviation2_vec,t_LP,t_dbs_vec]=simu_on_tree_network(N);
        result(i,:) = [distances_deviation1,distances_deviation2_vec,t_LP,t_dbs_vec];
    end
    filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\LPvsQiu_N%dPerturbation1havetime.txt",N);
    writematrix(result,filename)
end



function [distances_deviation1,distances_deviation2_vec,t_LP,t_dbs_vec]=simu_on_tree_network(N)
    %for a tree network
    %_______________________________________________________________________
    % generate a tree network with uniformly random distributed link weight
    T = generate_a_tree(N,1,10);
    A_input = full(T.adjacency("weighted"));
    
    % generate a distance matrix with uniformly random distributed link weight
    % as the demand matrix
    D_demand = demand_base_on_original_tree(A_input,1);
    
    tic
    [A_LP,D_target]=ISPP_givenA_LP(A_input,D_demand);
    t_LP = toc;
    % G2 = graph(A_LP);
    u  = ones(1,N);
    distances_deviation1 = u*abs(D_target-D_demand)*u.'/sum(sum(D_demand));
    linknum = numedges(T);
    base_num_vec =  round(linspace(2, linknum, 5));
    % distances_deviation2_vec = zeros(1,length(base_num_vec));

    distances_deviation2_vec = zeros(1,5);
    t_dbs_vec = zeros(1,5);
    count = 1;
    for basement_num = base_num_vec
        tic
        [A_Q,D_Q] = ISPP_givenA_Qiu(A_input,D_demand,basement_num);
        t_dbs = toc;
        t_dbs_vec(count) = t_dbs;
        % Goutput = graph(A_Q);
        distances_deviation2 = u*abs(D_Q-D_demand)*u.'/sum(sum(D_demand));
        distances_deviation2_vec(count) = distances_deviation2;
        count = count+1;
    end
    % subplot(2,2,1)
    % plot(T,'EdgeLabel',T.Edges.Weight,'NodeColor',[0.8500 0.3250 0.0980], ...
    % 'EdgeAlpha',0.5,'LineWidth',1,'MarkerSize',7,'EdgeLabelColor',[0 0.4470 0.7410],'NodeFontSize',10);
    % subplot(2,2,2)
    % plot(G2,'EdgeLabel',G2.Edges.Weight,'NodeColor',[0.8500 0.3250 0.0980], ...
    % 'EdgeAlpha',0.5,'LineWidth',1,'MarkerSize',7,'EdgeLabelColor',[0 0.4470 0.7410],'NodeFontSize',10);
    % subplot(2,2,3)
    % plot(Goutput,'EdgeLabel',Goutput.Edges.Weight,'NodeColor',[0.8500 0.3250 0.0980], ...
    % 'EdgeAlpha',0.5,'LineWidth',1,'MarkerSize',7,'EdgeLabelColor',[0 0.4470 0.7410],'NodeFontSize',10);
end


function D_demand = demand_base_on_original_tree(A_input,perturbation_scale)
    N = size(A_input,1);
    G = graph(A_input);
    D_demand = distances(G);
    perturbation = rand(N,N);
    perturbation = triu(perturbation,1);
    perturbation = perturbation+perturbation.';
    perturbation = perturbation_scale.*perturbation;
    D_demand = D_demand+perturbation;
end

function T = generate_a_tree(N,minlinkweight,maxlinkweight)
% 生成完全连接的随机加权图
W = randi([minlinkweight,maxlinkweight], N, N);  % 生成 1-10 之间的随机整数
W = triu(W,1);            % 仅保留上三角部分以避免重复
W = W + W';               % 生成对称矩阵，表示无向图
% 计算最小生成树
G = graph(W);             % 生成图
T = minspantree(G);       % 计算最小生成树
T.Edges.Weight = randi([minlinkweight,maxlinkweight], numedges(T), 1);
end
