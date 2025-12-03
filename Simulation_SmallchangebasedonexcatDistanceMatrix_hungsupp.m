% This .m will test the performance of our approximated method for 
% the IASPP with given adjacency matrix.
clear,clc
% Nvec = [10,20,50,100];
Nvec = [10,20,40,60,80,100];
simutimes = 1000;

for N = Nvec
    N
    result = zeros(simutimes,2);
    for i = 1:simutimes
        [distances_deviation1,t_LP]=simu_on_tree_network(N);
        result(i,:) = [distances_deviation1,t_LP];
    end
    filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\PerturbatedDemand\\LPvsQiu_N%dPerturbation1_hungsupp.txt",N);
    writematrix(result,filename)
end



function [distances_deviation1,t_LP]=simu_on_tree_network(N)
    %for a tree network
    %_______________________________________________________________________
    % generate a tree network with uniformly random distributed link weight
    T = generate_a_tree(N,1,10);
    A_input = full(T.adjacency("weighted"));
    
    % generate a distance matrix with uniformly random distributed link weight
    % as the demand matrix
    D_demand = demand_base_on_original_tree(A_input,1);
    
    tic
    [A_LP,D_target]=hung_ISPP(A_input,D_demand);
    t_LP = toc;
    disp(t_LP)
    % G2 = graph(A_LP);
    u  = ones(1,N);
    distances_deviation1 = u*abs(D_target-D_demand)*u.'/sum(sum(D_demand));
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
