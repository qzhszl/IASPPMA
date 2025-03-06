clear,clc
% 用非线性方法求解，以不同矩阵为基底，

% T = [0 1 1 0 0;
%      1 0 0 0 0;
%      1 0 0 1 1;
%      0 0 1 0 0;
%      0 0 1 0 0];  % 无权树（邻接矩阵）
% subplot(2,2,1)
% G_T = graph(T);
% plot(G_T,'EdgeLabel',G_T.Edges.Weight,'NodeColor',[0.8500 0.3250 0.0980], ...
% 'EdgeAlpha',0.5,'LineWidth',1,'MarkerSize',7,'EdgeLabelColor',[0 0.4470 0.7410],'NodeFontSize',10);
% D_T = distances(G_T);
% % [shortestDist, path,edgepath] = shortestpath(G_T, 2, 5)
% % edges = G_T.Edges.EndNodes(2,2)
% 
% 
% % INPUT demand
% D = [0 1 2 2 3;
%      1 0 1 1 2;
%      2 1 0 2 1;
%      2 1 2 0 1;
%      3 2 1 1 0];  % 目标最短  路径矩阵
N = 100
G_T = generate_a_tree(N,1,10);
T = full(G_T.adjacency("weighted"));

% generate a distance matrix with uniformly random distributed link weight
% as the demand matrix
D_demand = generate_demand_distance_matrix(N,10);
tic
[A_Q,D_Q] = ISPP_givenA_Qiu(T,D_demand,99);
time1 = toc
T_O = 0.01*T;
G_o = graph(T_O);
D_list = cell([numedges(G_T) 1]);

for i = 1:99
    G_base = G_o;
    G_base.Edges.Weight(i) = 1;
    D_base = distances(G_base);
    D_list{i} = D_base;
end


e_opt = solve_weighted_matrix(D_demand, D_list);
D_solution = sum(cat(3, D_list{:}) .* reshape(e_opt, 1, 1, []), 3);
difference = sum(sum(abs(D_solution - D_demand)));
toc-time1


function e_opt = solve_weighted_matrix(D, D_list)
    % 定义目标函数（最小化加权矩阵与目标矩阵之间的元素绝对差异）
    objective = @(e) sum(sum(abs(sum(cat(3, D_list{:}) .* reshape(e, 1, 1, []), 3) - D)));
    m = size(D_list,1);
    % 初始猜测：e1, e2, e3 都设置为 1
    initial_guess = ones(m,1);

    % 设置非负约束
    lb = zeros(m,1);  % e1, e2, e3 的下界是 0
    ub = [];          % 没有上界

    % 使用 fmincon 求解最优化问题
    options = optimoptions('fmincon', 'Display', 'iter');
    [e_opt, fval] = fmincon(objective, initial_guess, [], [], [], [], lb, ub, [], options);

    % 提取最优的 e1, e2, e3
    disp('最优权重:');
    disp(e_opt);
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