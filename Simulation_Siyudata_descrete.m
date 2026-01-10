% This .m will test the performance of our approximated method for 
% the IASPP with given adjacency matrix.

% the demand matrix is random generated demand matrix
%  The service instances considered during the evaluations are classified into three categories: 
% delay sensitive traffic with very small latency bound 
% network control traffic with latency requirement  
% traffic that are less stringent on E2E latency
% options_a = [0.1, 0.5, 1, 2];
% options_b = [5, 10, 15, 20];
% options_c = [50, 100, 500, 1000];
% The percentage of the three categories so that in one scenario, you have e.g., more than 50\% of the traffic with very stringent latency bound, etc. 

clear,clc
Nvec = [40,60,80,100];
for N = Nvec
    run_simu_onsitydata_descrete(N,0.5,0.25,0.25)
    run_simu_onsitydata_descrete(N,0.25,0.5,0.25)
    run_simu_onsitydata_descrete(N,0.25,0.25,0.5)
    run_simu_onsitydata_descrete(N,0.34,0.33,0.33)
end


function run_simu_onsitydata_descrete(N, dsmall,dmid,dlarge)
    % the sum of the percentage of three types of delay should be 1
    simutimes = 1000;
    result = zeros(simutimes,13);
    for i = 1:simutimes
        [distances_deviation1,distances_deviation2_vec,t_LP,t_dbs_vec,tree_diameter]=simu_on_tree_network(N, dsmall,dmid,dlarge);
        result(i,:) = [distances_deviation1,distances_deviation2_vec,t_LP,t_dbs_vec,tree_diameter];
    end
%     filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\SiyuData\\discrete\\descretedemandLPvsQiu_N%ddataper%.2f%.2f%.2f_siyuinput_treefromERp05.txt",N,dsmall,dmid,dlarge);
    filename = sprintf("D:\\data\\ISPP_givenA\\test\\descretedemandLPvsQiu_N%ddataper%.2f%.2f%.2f_siyuinput_treefromERp05.txt",N,dsmall,dmid,dlarge);
    
    writematrix(result,filename)
end

function [distances_deviation1,distances_deviation2_vec,t_LP,t_dbs_vec,tree_diameter]=simu_on_tree_network(N, dsmall,dmid,dlarge)
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
    T = generate_a_tree_fromER(N,0.5,10)
    A_input = full(adjacency(T,"weighted"));
    
    tree_diameter = diameter_hopcount(A_input);
    % generate a distance matrix with uniformly random distributed link weight
    % as the demand matrix
    D_demand = generate_siyu_demand_distance_matrix(N,dsmall,dmid,dlarge);
    
    tic
    [A_LP,D_target]=ISPP_givenA_LP(A_input,D_demand);
    t_LP = toc;
    disp(t_LP)
    % G2 = graph(A_LP);
    u  = ones(1,N);
    distances_deviation1 = u*abs(D_target-D_demand)*u.'/sum(sum(D_demand));
    linknum = numedges(T);
    base_num_vec =  round(linspace(2, linknum, 5));
        distances_deviation2_vec = zeros(1,5);
    t_dbs_vec = zeros(1,5);

    count = 1;
    for basement_num = base_num_vec
        tic
        [A_Q,D_Q] = ISPP_givenA_Qiu(A_input,D_demand,basement_num);
        % [A_Q,D_Q] = ISPP_givenA_Qiu_randombase(A_input,D_target,basement_num);
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


function D_demand = generate_siyu_demand_distance_matrix(N,dsmall,dmid,dlarge)
    % delay sensitive traffic with very small latency bound from 100µs to 2ms, 
    % network control traffic with latency requirement between 2ms and 20ms, 
    % traffic that are less stringent on E2E latency, e.g., 50ms to 1s. 
    % 确保比例总和为100%
    if dsmall + dmid + dlarge - 1 >0.0000001
        error('dsmall, dmid, dlarge 的总和必须为1');
    end

    % 计算矩阵中独立元素的数量（上三角不含对角线）
    num_elements = N * (N - 1) / 2;

    % 每个区间的数量
    num_a = round(dsmall * num_elements);
    num_b = round(dmid * num_elements);
    num_c = num_elements - num_a - num_b; % 剩余分给 c

    % 生成对应区间的随机数
    % demands_a = 0.1 + (2 - 0.1) * rand(num_a, 1);
    % demands_b = 2 + (20 - 2) * rand(num_b, 1);
    % demands_c = 50 + (1000 - 50) * rand(num_c, 1);

    options_a = [0.1, 0.5, 1, 2];
    demands_a = options_a(randi(length(options_a), num_a, 1));
    
    % 类 b: 从 [5, 10, 20] ms 中随机选
    options_b = [5, 10, 15, 20];
    demands_b = options_b(randi(length(options_b), num_b, 1));
    
    % 类 c: 从 [50, 100, 500, 1000] ms 中随机选
    options_c = [50, 100, 500, 1000];
    demands_c = options_c(randi(length(options_c), num_c, 1));

    % 合并并打乱顺序
    demands = [demands_a, demands_b, demands_c];
    demands = demands(randperm(length(demands)));

    % 创建上三角矩阵（不含对角线）
    D = zeros(N);
    upper_indices = find(triu(ones(N), 1));
    D(upper_indices) = demands;

    % 生成对称矩阵
    D_demand = D + D';
    G = graph(D_demand);
    D_demand = distances(G);
    % 可选：设置对角线为0（或其他值）
    % D(1:N+1:end) = 0;
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