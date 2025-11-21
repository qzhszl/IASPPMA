clear,clc
% test HUNG ALOGRITHM FOR TREE
%input:
A = [0 1 3 0 0
    0 0 0 1 1
    0 0 0 0 0
    0 0 0 0 0
    0 0 0 0 0];
A = A+A';
G_T = graph(A);
plot(G_T,'EdgeLabel',G_T.Edges.Weight,'NodeColor',[0.8500 0.3250 0.0980], ...
'EdgeAlpha',0.5,'LineWidth',1,'MarkerSize',7,'EdgeLabelColor',[0 0.4470 0.7410],'NodeFontSize',10);

D = [0     9    10    11    19
     9     0    19     2    10
    10    19     0    21    29
    11     2    21     0    12
    19    10    29    12     0];

% Initialization

n = numnodes(G_T);  % 节点数
%     edges = find(triu(T));  % 获取树的边索引
m = numedges(G_T);  % 边数

P = zeros(n*(n-1)/2, m);
target_D = zeros(n*(n-1)/2, 1);
idx = 1;

% choose one path for each node pair
for i = 1:n
    for j = i+1:n
        [~, ~,path_edges] = shortestpath(G_T, i, j);
        P(idx, path_edges) = 1; % 标记路径
        target_D(idx) = D(i,j);
        idx = idx + 1;
    end
end

iteration_times = 1;
while iteration_times<100
    [sum_infeasibility,infeasibility,w,G_T] = solve_infeasibility_minimization(P,target_D,m,G_T,D);

    innneridx = 1;
    for i = 1:n
        for j = i+1:n
            [~, ~,path_edges] = shortestpath(G_T, i, j);
            P(innneridx, path_edges) = 1; % 标记路径
            innneridx = innneridx + 1;
        end
    end
    if sum_infeasibility ==0
        break
    end

    % perturbation
    epsilon = 1e-9;   % 小正数保证 w>0
    r = rand(m,1);
    b_new = target_D+infeasibility;

    % 目标函数系数 f = r
    f = r;
    
    % 无不等式约束：Ax <= b 为空
    A = [];
    B = [];
    
    % 等式约束：P * w = b
    Aeq = P;
    Beq = b_new;
    
    % 变量下界 w >= epsilon
    lb = epsilon * ones(m,1);
   
    % 无上界
    ub = [];
  
    % 求解 LP
    options = optimoptions('linprog','Display','iter'); % 或 'none'
    [w_opt, ~, ~, ~] = linprog(f, A, B, Aeq, Beq, lb, ub, options)
    
    
    G_T.Edges.Weight = w;
    % A_output = full(G_T.adjacency("weighted"));
    D_output = distances(G_T);
    sum_infeasibility =  sum(sum(abs(D_output-D)))

    iteration_times = iteration_times+1;
end




function [sum_infeasibility,infeasibility,w,G_T] = solve_infeasibility_minimization(P,target_D,m,G_T,D)

    num_constraints = size(P, 1);  % 约束数量
    n = size(D,1);
    % 线性规划问题
    f = [zeros(m,1); ones(num_constraints,1)];  % 目标函数 (最小化 t)
    
    % 约束矩阵 (S_ij - D_ij <= t)
    A = [P -eye(num_constraints); -P -eye(num_constraints)];
    b = [target_D; -target_D];
    
    % 变量约束 w > 0, t >= 0
    epsilon = 0.000001;
    lb = [epsilon*ones(m,1);zeros(num_constraints, 1)];
    
    % 线性规划求解
    [x, ~, ~, ~] = linprog(f, A, b, [], [], lb, []);
    w = x(1:m);
    
    G_T.Edges.Weight = w;
    % A_output = full(G_T.adjacency("weighted"));
    D_output = distances(G_T);
    
    diff = D_output-D;
    infeasibility = zeros(num_constraints,1);
    idx = 1;
    for i = 1:n
        for j = i+1:n
            infeasibility(idx) = diff(i,j);
            idx = idx + 1;
        end
    end
    sum_infeasibility =  sum(sum(abs(D_output-D)));
end



