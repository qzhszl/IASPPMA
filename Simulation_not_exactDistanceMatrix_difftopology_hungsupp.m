% This .m will test the performance of our approximated method for 
% the IASPP with given adjacency matrix.

% the demand matrix is random generated demand matrix
% the topology of the tree network is from a star to a path graph(a line)
% thus we change the diameter of the underlying topology
clear,clc
% Nvec = [10,20,50,100];
Nvec = [100];
simutimes = 1000;


for N = Nvec
    N
    result = zeros(simutimes,3);
    for i = 1:simutimes
        [distances_deviation1,t_LP,tree_diameter]=simu_on_tree_network(N);
        result(i,:) = [distances_deviation1,t_LP,tree_diameter];
    end
    filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\diff_diameter\\LPvsQiu_N%dhavetime_randominput_treefromERp006_hungsupp.txt",N);
    % filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\diff_diameter\\LPvsQiu_N%dhavetime_randominput_pathnetwork.txt",N);

    writematrix(result,filename)
end





function [distances_deviation1,t_LP,tree_diameter]=simu_on_tree_network(N)
    %for a tree network
    %_______________________________________________________________________
    % generate a tree network with uniformly random distributed link weight
    % 1. star network
    % ----------------------------------------------------------
    % A_input  = generate_star_network(N,10);
    % T = graph(A_input);
    
    % 2. path network(a line)
    % ----------------------------------------------------------
    % A_input  = generate_path_network(N,10);
    % T = graph(A_input);

    % 3. normal ER network with diff p
    % ----------------------------------------------------------
    T = generate_a_tree_fromER(N,0.06,10);
    A_input = full(adjacency(T,"weighted"));
    
    tree_diameter = diameter_hopcount(A_input);
    % generate a distance matrix with uniformly random distributed link weight
    % as the demand matrix
    D_demand = generate_demand_distance_matrix(N,10);
    
    tic
    [A_LP,D_target]=hung_ISPP(A_input,D_demand);
    t_LP = toc;
    disp(t_LP)
    % G2 = graph(A_LP);
    u  = ones(1,N);
    distances_deviation1 = u*abs(D_target-D_demand)*u.'/sum(sum(D_demand));
end


function D_demand = generate_demand_distance_matrix(N,max_linkweight)
    A = ones(N);
    A_demand = randi(max_linkweight,N,N).*triu(A,1); % network that provides the targeted shortest path distances matrix
    G_demand = graph(A_demand,'upper');
    D_demand = distances(G_demand);
end

function T = generate_a_tree_fromER(N,p,maxlinkweight)
    A = GenerateERfast(N,p,maxlinkweight);
                    % 生成图
    connect_flag = network_isconnected(A);
    while ~connect_flag
        A = GenerateERfast(N,p,10);
        % check connectivity
        connect_flag = network_isconnected(A);
    end
    G = graph(A); 
    T = minspantree(G);       % 计算最小生成树
end


function [isConnected] = network_isconnected(adj)
    G = graph(adj);
    components = conncomp(G);
    % 判断图是否连通
    isConnected = (max(components) == 1);
end