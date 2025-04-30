function [A_output,D_output] = ISPP_givenA_LP(A_input,D_demand)
    
    T = A_input;  % 无权树（邻接矩阵）
    T(T~=0) =1;
    G_T = graph(T);
    % INPUT demand
    w_opt = optimize_tree_weights_L1(T, D_demand);
    G_T.Edges.Weight = w_opt;
    A_output = full(G_T.adjacency("weighted"));
    D_output = distances(G_T);
end

function w = optimize_tree_weights_L1(T, D)
    % 计算最优边权 w，使树 T 的最短路径矩阵 S(T, w) 逼近目标 D
    % 使用线性规划求解最小绝对误差（p=1）
    G_T = graph(T);
    n = numnodes(G_T);  % 节点数
%     edges = find(triu(T));  % 获取树的边索引
    m = numedges(G_T);  % 边数
    % 生成路径矩阵 P
    P = zeros(n*(n-1)/2, m);
    target_D = zeros(n*(n-1)/2, 1);
    idx = 1;
    
    for i = 1:n
        for j = i+1:n
            [~, ~,path_edges] = shortestpath(G_T, i, j);
            P(idx, path_edges) = 1; % 标记路径
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

