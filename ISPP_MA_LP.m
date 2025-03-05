clear,clc

% INPUT tree
T = [0 1 1 0 0;
     1 0 0 0 0;
     1 0 0 1 1;
     0 0 1 0 0;
     0 0 1 0 0];  % 无权树（邻接矩阵）
subplot(2,2,1)
G_T = graph(T);
plot(G_T,'EdgeLabel',G_T.Edges.Weight,'NodeColor',[0.8500 0.3250 0.0980], ...
'EdgeAlpha',0.5,'LineWidth',1,'MarkerSize',7,'EdgeLabelColor',[0 0.4470 0.7410],'NodeFontSize',10);
D_T = distances(G_T);
% [shortestDist, path,edgepath] = shortestpath(G_T, 2, 5)
% edges = G_T.Edges.EndNodes(2,2)


% INPUT demand
D = [0 1 2 2 3;
     1 0 1 1 2;
     2 1 0 2 1;
     2 1 2 0 1;
     3 2 1 1 0];  % 目标最短  路径矩阵

w_opt = optimize_tree_weights_L1(T, D);
disp('最优边权:');
disp(w_opt);
G_T.Edges.Weight = w_opt
subplot(2,2,2)
plot(G_T,'EdgeLabel',G_T.Edges.Weight,'NodeColor',[0.8500 0.3250 0.0980], ...
'EdgeAlpha',0.5,'LineWidth',1,'MarkerSize',7,'EdgeLabelColor',[0 0.4470 0.7410],'NodeFontSize',10);

distances(G_T)
sum(sum(abs(distances(G_T)-D)))/sum(sum(D))





function w = optimize_tree_weights_L1(T, D)
    % 计算最优边权 w，使树 T 的最短路径矩阵 S(T, w) 逼近目标 D
    % 使用线性规划求解最小绝对误差（p=1）
    G_T = graph(T);
    n = numnodes(G_T);  % 节点数
%     edges = find(triu(T));  % 获取树的边索引
    m = numedges(G_T);  % 边数
    G_T.Edges
    % 生成路径矩阵 P
    P = zeros(n*(n-1)/2, m);
    target_D = zeros(n*(n-1)/2, 1);
    idx = 1;
    
    for i = 1:n
        for j = i+1:n
%             path_edges = find_path_edges(T, i, j, edges); % 获取路径上的边索引
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
    epsilon = 0.01
    lb = [epsilon*ones(m,1);zeros(num_constraints, 1)];
    
    % 线性规划求解
    x = linprog(f, A, b, [], [], lb, []);
    
    % 提取最优权重 w
    w = x(1:m);
end
