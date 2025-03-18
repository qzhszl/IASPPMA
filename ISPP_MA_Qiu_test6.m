clear,clc
% 用线性方法求解，以不同矩阵为基底
tic
T = [0 1 1 0 0; 
     1 0 0 0 0;
     1 0 0 1 1;
     0 0 1 0 0;
     0 0 1 0 0];  % 无权树（邻接矩阵）
% N = 100
% T = generate_a_tree(N,1,10);
% T = full(T.adjacency("weighted"));

% subplot(2,2,1)
G_T = graph(T);
% plot(G_T,'EdgeLabel',G_T.Edges.Weight,'NodeColor',[0.8500 0.3250 0.0980], ...
%     'EdgeAlpha',0.5,'LineWidth',1,'MarkerSize',7,'EdgeLabelColor',[0 0.4470 0.7410],'NodeFontSize',10);

% D_T = distances(G_T);

% 目标最短路径矩阵（目标 D）
D = [0 1 2 2 3;
     1 0 1 1 2;
     2 1 0 2 1;
     2 1 2 0 1;
     3 2 1 1 0];

% D = generate_demand_distance_matrix(N,10)

basenumber = 2
% 计算每条边对应的 D_list
T_O = 0.0001*T;
G_o = graph(T_O);
D_list = cell([numedges(G_T), 1]);
diff_list = zeros(numedges(G_T), 1);

for i = 1:numedges(G_T)
    G_base = G_o;
    G_base.Edges.Weight(i) = 1;
    D_base = distances(G_base);
    D_list{i} = D_base;
    diffVals = sum(sum(abs(D_base - D)));
    diff_list(i) = diffVals;
end


% for i = 1:numedges(G_T)
%     G_base = G_o;
%     G_base.Edges.Weight = randi(10,numedges(G_T),1);
%     D_base = 0.001*distances(G_base);
%     D_list{i} = D_base;
%     diffVals = sum(sum(abs(D_base - D)));
%     diff_list(i) = diffVals;
% end


[sortedVals, sortedIdx] = mink(diff_list, 2);
D_list = D_list(sortedIdx);


% 调用 linprog 求解
e_opt = solve_weighted_matrix_linprog(D, D_list);
D_solution = sum(cat(3, D_list{:}) .* reshape(e_opt, 1, 1, []), 3);
difference = sum(sum(abs(D_solution - D)));


[A_output,Dnew] = ISPP_givenA_Qiu(T,D,2);
difference2 = sum(sum(abs(Dnew - D)))

disp(['总误差: ', num2str(difference)]);


% ------------------------  线性规划求解函数 ------------------------
function e_opt = solve_weighted_matrix_linprog(D, D_list)
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
