% This .m will test the performance of our approximated method for 
% the IASPP with given adjacency matrix.
clear,clc
Nvec = [10,20,50,100];
simutimes = 1000;


for N = Nvec
    N
    result = zeros(simutimes,12);
    for i = 1:simutimes
        [distances_deviation1,distances_deviation2_vec,t_LP,t_dbs_vec]=simu_on_tree_network(N);
        result(i,:) = [distances_deviation1,distances_deviation2_vec,t_LP,t_dbs_vec];
    end
    filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\LPvsQiu_N%dhavetimetestpreSP.txt",N);
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
    D_demand = generate_demand_distance_matrix(N,10);
    
    
    n = N;
    m = numedges(T);
    P = zeros(n*(n-1)/2, m);
    idx = 1;
    for i = 1:n
        for j = i+1:n
            [~, ~,path_edges] = shortestpath(T, i, j);
            P(idx, path_edges) = 1; % 标记路径
            idx = idx + 1;
        end
    end
    
    tic
    [~,D_target]=ISPP_givenA_LP_pre_savesp(A_input,D_demand,P);
    t_LP = toc;
    
    % G2 = graph(A_LP);
    u  = ones(1,N);
    distances_deviation1 = u*abs(D_target-D_demand)*u.'/sum(sum(D_demand));
    linknum = numedges(T);
    base_num_vec =  round(linspace(2, linknum, 5));
        distances_deviation2_vec = zeros(1,5);
    t_dbs_vec = zeros(1,5);

    count = 1;
    for basement_num = base_num_vec
        D_list = generate_distances_base(A_input,basement_num);
        tic
        [~,D_Q] = ISPP_givenA_Qiu_preSP(A_input,D_demand,basement_num,D_list);
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


function D_demand = generate_demand_distance_matrix(N,max_linkweight)
    A = ones(N);
    A_demand = randi(max_linkweight,N,N).*triu(A,1); % network that provides the targeted shortest path distances matrix
    G_demand = graph(A_demand,'upper');
    D_demand = distances(G_demand);
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




function [A_output,D_output] = ISPP_givenA_LP_pre_savesp(A_input,D_demand,P)
    
    T = A_input;  % 无权树（邻接矩阵）
    T(T~=0) =1;
    G_T = graph(T);
    % INPUT demand
    w_opt = optimize_tree_weights_L1_pre_savesp(T, D_demand,P);
    G_T.Edges.Weight = w_opt;
    A_output = full(G_T.adjacency("weighted"));
    D_output = distances(G_T);
end

function w = optimize_tree_weights_L1_pre_savesp(T, D, P)
    % 计算最优边权 w，使树 T 的最短路径矩阵 S(T, w) 逼近目标 D
    % 使用线性规划求解最小绝对误差（p=1）
    G_T = graph(T);
    n = numnodes(G_T);  % 节点数
%     edges = find(triu(T));  % 获取树的边索引
    m = numedges(G_T);  % 边数
    % 生成路径矩阵 P
    % P = zeros(n*(n-1)/2, m);
    target_D = zeros(n*(n-1)/2, 1);
    idx = 1;
    
    for i = 1:n
        for j = i+1:n
            % [~, ~,path_edges] = shortestpath(G_T, i, j);
            % P(idx, path_edges) = 1; % 标记路径
            target_D(idx) = D(i,j);
            idx = idx + 1;
        end
    end

    % 线性规划变量：
    % w: 边权重
    % t: 误差变量 |S_ij - D_ij|
    num_constraints = size(P, 1);  % 约束数量
    
    % 线性规划问题
    f = [zeros(m,1); ones(num_constraints,1)];  % 目标函数 (最小化 t)
    
    % 约束矩阵 (S_ij - D_ij <= t)
    A = [P -eye(num_constraints); -P -eye(num_constraints)];
    b = [target_D; -target_D];
    
    % 变量约束 w > 0, t >= 0
    epsilon = 0.001;
    lb = [epsilon*ones(m,1);zeros(num_constraints, 1)];
    
    % 线性规划求解
    x = linprog(f, A, b, [], [], lb, []);
    
    % 提取最优权重 w
    w = x(1:m);
end

function D_list = generate_distances_base(A_input,base_num)
    T = A_input;
    T(T~=0) =1;
    G_T = graph(T);
    D_T = 0.001*distances(G_T);    
    linknum = numedges(G_T);
    G_base = graph(A_input);
    D_base = 0.001*distances(G_base);

    if base_num < 1
        error('Not enough number of basement');
    elseif base_num > linknum
        error('too many basement');
    end

    if base_num ==2
        D_list = {D_T;D_base};
    elseif base_num == linknum
        T_O = 0.001*T;
        G_o = graph(T_O);
        D_list = cell([numedges(G_T), 1]);
        for i = 1:linknum
            G_base = G_o;
            G_base.Edges.Weight(i) = 1;
            D_base = distances(G_base);
            D_list{i} = D_base;
        end
    else
        T_O = 0.001*T;
        G_o = graph(T_O);
        D_list = cell([base_num, 1]);
        D_list{1} = D_T;
        D_list{2} = D_base;
        for i = 3:base_num
            G_base = G_o;
            G_base.Edges.Weight(i) = 1;
            D_base = distances(G_base);
            D_list{i} = D_base;
        end
    end
end


function [A_output,Dnew] = ISPP_givenA_Qiu_preSP(A_input,D_target,base_num,D_list)
    % T = A_input;
    % T(T~=0) =1;
    % G_T = graph(T);
    % D_T = 0.001*distances(G_T);    
    % linknum = numedges(G_T);
    % G_base = graph(A_input);
    % D_base = 0.001*distances(G_base);
    % if base_num < 1
    %     error('Not enough number of basement');
    % elseif base_num > linknum
    %     error('too many basement');
    % end
    % 
    % if base_num ==2
    %     D_list = {D_T;D_base};
    % elseif base_num == linknum
    %     T_O = 0.001*T;
    %     G_o = graph(T_O);
    %     D_list = cell([numedges(G_T), 1]);
    %     for i = 1:linknum
    %         G_base = G_o;
    %         G_base.Edges.Weight(i) = 1;
    %         D_base = distances(G_base);
    %         D_list{i} = D_base;
    %     end
    % else
    %     T_O = 0.001*T;
    %     G_o = graph(T_O);
    %     D_list = cell([base_num, 1]);
    %     D_list{1} = D_T;
    %     D_list{2} = D_base;
    %     for i = 3:base_num
    %         G_base = G_o;
    %         G_base.Edges.Weight(i) = 1;
    %         D_base = distances(G_base);
    %         D_list{i} = D_base;
    %     end
    % end
    e_opt = solve_weighted_matrix_linprog_preSP(D_target, D_list);
    Dnew = sum(cat(3, D_list{:}) .* reshape(e_opt, 1, 1, []), 3);
    A_output = DOR(Dnew,'advanced');
    % difference = sum(sum(abs(Dnew - D_target)));
    % disp(['总误差: ', num2str(difference)]);
end

function e_opt = solve_weighted_matrix_linprog_preSP(D, D_list)
    m = size(D_list,1); % 变量个数
    [n, ~] = size(D); % D 的大小（n × n）
    
    % 获取 D 的上三角索引（不包括对角线）
    [row_idx, col_idx] = find(triu(ones(n), 1));  
    num_constraints = length(row_idx);  % 只考虑上三角元素的个数
    
    % 决策变量: [e1, e2, ..., em, s1, s2, ..., s_num_constraints]
    num_vars = m + num_constraints;

    % 目标函数: 最小化 sum(s_ij)
    f = [zeros(m,1); ones(num_constraints,1)]; % e 部分系数为 0，s 部分系数为 1

    % 约束矩阵 (A * x <= b)
    % s_k >= sum_k e_k * D_k(i,j) - D(i,j)
    % s_k >= D(i,j) - sum_k e_k * D_k(i,j)
    A = zeros(2*num_constraints, num_vars);
    b = zeros(2*num_constraints, 1);
    
    % 组装约束
    for idx = 1:num_constraints
        i = row_idx(idx);
        j = col_idx(idx);
        
        % 计算 D' = sum(e_k * D_k)
        A(idx, 1:m) = reshape(cellfun(@(Dk) Dk(i,j), D_list), 1, []); % sum_k e_k * D_k(i,j)
        A(idx, m+idx) = -1; % -s_k
        b(idx) = D(i,j); % 右侧 D(i,j)
        
        % 另一组不等式: s_k >= D(i,j) - sum_k e_k * D_k(i,j)
        A(num_constraints+idx, 1:m) = -A(idx, 1:m);
        A(num_constraints+idx, m+idx) = -1;
        b(num_constraints+idx) = -D(i,j);
    end

    % 变量非负约束 (lb <= x <= ub)
    lb = zeros(num_vars, 1);
    ub = []; % 无上界

    % 线性规划求解
    options = optimoptions('linprog', 'Display', 'iter');
    x_opt = linprog(f, A, b, [], [], lb, ub, options);

    % 提取 e_opt
    e_opt = x_opt(1:m);
%     disp('最优权重:');
%     disp(e_opt);
end