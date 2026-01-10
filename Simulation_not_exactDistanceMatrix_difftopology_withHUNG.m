% This .m will test the performance of our approximated method for 
% the IASPP with given adjacency matrix.

% the demand matrix is random generated demand matrix
% the topology of the tree network is from a star to a path graph(a line)
% thus we change the diameter of the underlying topology
clear,clc
% Nvec = [10,20,50,100];
N=50;
simutimes = 1000;
% input_diameter_vec = [2,5,10,15,20,25,30,35,40,45,49];
input_diameter_vec = [30,35];



for diameter = input_diameter_vec
    result = zeros(simutimes,14);
    for i = 1:simutimes
        [distances_deviation1,dev_hung,distances_deviation2_vec,t_LP,t_hung,t_dbs_vec]=simu_on_tree_network(N,diameter);
        result(i,:) = [distances_deviation1,dev_hung,distances_deviation2_vec,t_LP,t_hung,t_dbs_vec];
    end
    filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\diff_diameter\\LPvsQiu_N%dhavetime_randominput_tree%diameter%d.txt",N,diameter);
    filename = sprintf("D:\\data\\ISPP_givenA\\test\\LPvsQiu_N%dhavetime_randominput_tree%diameter%d.txt",N,diameter);
    % filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\diff_diameter\\LPvsQiu_N%dhavetime_randominput_pathnetwork.txt",N);

    writematrix(result,filename)
end


function [distances_deviation1,dev_hung,distances_deviation2_vec,t_LP,t_hung,t_dbs_vec]=simu_on_tree_network(N,diameter)
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
%     T = generate_a_tree_fromER(N,0.06,10);
%     A_input = full(adjacency(T,"weighted"));
    
    [A_input, ~, ~] = strict_random_tree_with_diameter_retry(N, diameter);

    % generate a distance matrix with uniformly random distributed link weight
    % as the demand matrix
    D_demand = generate_demand_distance_matrix(N,10);
    
    tic
    [A_LP,D_target]=ISPP_givenA_LP(A_input,D_demand);
    t_LP = toc;
    disp(t_LP)
   

    u  = ones(1,N);
    distances_deviation1 = u*abs(D_target-D_demand)*u.'/sum(sum(D_demand));
    linknum = N-1;
    
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

    
    tic
    [A_LP,D_target_hung]=hung_ISPP(A_input,D_demand);
    t_hung = toc;
    disp(t_LP)
    % G2 = graph(A_LP);
    dev_hung = u*abs(D_target_hung-D_demand)*u.'/sum(sum(D_demand));


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



function [A, edgeList, attempts] = strict_random_tree_with_diameter_retry(N, D, seed, maxAttempts, verbose)
% strict_random_tree_with_diameter_retry 生成节点数为 N 且直径严格为 D 的随机树（自动重试）
% 边权重为 1~10 的均匀随机整数
%
% 输入:
%   N           - 节点数（N >= D+1）
%   D           - 指定直径（正整数，1 <= D < N）
%   seed        - (可选) 基础随机种子；若提供则可复现（但每次尝试会改变种子）
%   maxAttempts - (可选) 最大重试次数，默认 100
%   verbose     - (可选) 是否打印重试信息，默认 true
%
% 输出:
%   A        - N x N 对称加权邻接矩阵（未连边为 0）
%   edgeList - E x 3 矩阵，每行 [u, v, weight]
%   attempts - 实际尝试次数（成功时返回成功时的次数）
%
% 例:
%   [A,E,att] = strict_random_tree_with_diameter_retry(20,6,123,200,true);
%
    if nargin < 3
        seed = [];
    end
    if nargin < 4 || isempty(maxAttempts)
        maxAttempts = 100;
    end
    if nargin < 5 || isempty(verbose)
        verbose = true;
    end

    % 参数检查
    if D < 1 || D >= N
        error('D must satisfy 1 <= D < N');
    end
    if N < D + 1
        error('N must be at least D+1');
    end

    % 初始随机化
    if isempty(seed)
        rng('shuffle');
        baseSeed = rng;  % keep current rng state but we won't reuse fixed seed
        useSeeded = false;
    else
        useSeeded = true;
        baseSeed = seed;
    end

    A = [];
    edgeList = [];
    attempts = 0;
    success = false;

    for att = 1:maxAttempts
        attempts = att;
        try
            % 如果给定 seed 每次尝试用不同的子种子，这样生成是可复现但不同的树
            if useSeeded
                rng(baseSeed + att); %#ok<RAND>
            else
                rng('shuffle');
            end

            % ------------- 构造主干路径 1..D+1 -------------
            edges = zeros(0,3);
            for u = 1:D
                v = u + 1;
                w = randi([1,10]);
                edges = [edges; u, v, w];
            end

            % ------------- 将其余节点作为叶子接到主干非端点 -------------
            nextNode = D + 2;
            attachCandidates = 2:D;  % 只允许接到非端点节点
            while nextNode <= N
                attachTo = attachCandidates(randi(length(attachCandidates)));
                w = randi([1,10]);
                edges = [edges; attachTo, nextNode, w];
                nextNode = nextNode + 1;
            end

            % ------------- 构造邻接矩阵 -------------
            A_try = zeros(N);
            for k = 1:size(edges,1)
                i = edges(k,1); j = edges(k,2); w = edges(k,3);
                A_try(i,j) = w;
                A_try(j,i) = w;
            end

            % ------------- 验证（以边数计算直径 -> 无权图） -------------
            Gu = graph(sparse(double(A_try > 0)));  % 无权结构
            D_actual = max(distances(Gu),[],'all');

            if D_actual == D
                % 成功：返回结果
                A = A_try;
                edgeList = edges;
                success = true;
                if verbose
                    fprintf('Success on attempt %d: constructed diameter = %d\n', att, D_actual);
                end
                break;
            else
                % 未通过验证（理论上不应出现，但如果出现则重试）
                if verbose
                    fprintf('Attempt %d: diameter=%d (wanted %d). Retrying...\n', att, D_actual, D);
                end
                continue;
            end

        catch ME
            % 捕获任何异常并重试（而不是直接报错）
            if verbose
                fprintf('Attempt %d raised an error: %s\nRetrying...\n', att, ME.message);
            end
            continue;
        end
    end

    if ~success
        error('Failed to construct a tree with diameter=%d after %d attempts.', D, maxAttempts);
    end
end
