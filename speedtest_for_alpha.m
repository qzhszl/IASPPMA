clear,clc
% this i. is of testing the speed and accuracy of the tiny value \alpha
% conclusion: a smaller alpha leads to a smaller differences at the cost of
% increasing the computation time for bn = L


Nvec = [100];
simutimes = 100;

% 001:   0.253918377393889	0.373932104120029	0.351765608393789	0.325002761464233	0.287857767694455	0.259744723522120	2.65249091400000	1.31282722600000	3.03051079200000	5.50754539800000	9.83808345900000	15.6027840280000
% 0001:  0.252277614827960	0.374453924170252	0.350274906303088	0.324424689076755	0.284483136111203	0.252955299130279	2.74253580200000	1.29300674800000	3.20739334700000	5.63342588000000	10.2668312110000	17.5304052600000
% 00001: 0.253494103151207	0.371932837600911	0.349825792643108	0.323697289470744	0.285066436917701	0.253558657229052	2.87177086100000	1.33791740000000	3.42418790500000	6.38075271400000	11.3125643890000	19.2536093380000
for N = Nvec
    N
    result = zeros(simutimes,32);
    for i = 1:simutimes
        [distances_deviation1,distances_deviation2_vec,t_LP,t_dbs_vec]=simu_on_tree_network(N);
        result(i,:) = [distances_deviation1,distances_deviation2_vec,t_LP,t_dbs_vec];
    end
    filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\speedtest\\LPvsQiu_N%dhavetimetestrandomalphamixed.txt",N);
    writematrix(result,filename)
    mean_values = mean(result)
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
    
    tic
    [A_LP,D_target]=ISPP_givenA_LP(A_input,D_demand);
    t_LP = toc;
    disp(t_LP)
    % G2 = graph(A_LP);
    u  = ones(1,N);
    distances_deviation1 = u*abs(D_target-D_demand)*u.'/sum(sum(D_demand));
    linknum = numedges(T);
    base_num_vec =  round(linspace(2, linknum, 5));
    distances_deviation2_vec = zeros(1,15);
    t_dbs_vec = zeros(1,15);
    count = 1;
    for alpha  = [0.001,0.0001,0.000001]
        for basement_num = base_num_vec
            tic
            [A_Q,D_Q] = ISPP_givenA_Qiuspeedtest(A_input,D_demand,basement_num,alpha);
            % [A_Q,D_Q] = ISPP_givenA_Qiu_randombase(A_input,D_target,basement_num);
            t_dbs = toc;
            t_dbs_vec(count) = t_dbs;
            % Goutput = graph(A_Q);
            distances_deviation2 = u*abs(D_Q-D_demand)*u.'/sum(sum(D_demand));
            distances_deviation2_vec(count) = distances_deviation2;
            count = count+1;
        end
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


function [A_output,Dnew] = ISPP_givenA_Qiuspeedtest(A_input,D_target,base_num,alpha)
    T = A_input;
    T(T~=0) =1;
    G_T = graph(T);
    tic
    D_T = alpha*distances(G_T);    
    linknum = numedges(G_T);
    G_base = graph(A_input);
    D_base = alpha*distances(G_base);

    if base_num < 1
        error('Not enough number of basement');
    elseif base_num > linknum
        error('too many basement');
    end

    if base_num ==2
        D_list = {D_T;D_base};
    elseif base_num == linknum
        T_O = alpha*T;
        G_o = graph(T_O);
        D_list = cell([numedges(G_T), 1]);
        for i = 1:linknum
            G_base = G_o;
            G_base.Edges.Weight(i) = 1;
            D_base = distances(G_base);
            D_list{i} = D_base;
        end
    else
        T_O = alpha*T;
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
    e_opt = solve_weighted_matrix_linprog(D_target, D_list);
    Dnew = sum(cat(3, D_list{:}) .* reshape(e_opt, 1, 1, []), 3);
    A_output = DOR(Dnew,'advanced');
    % difference = sum(sum(abs(Dnew - D_target)));
    % disp(['总误差: ', num2str(difference)]);
end

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
%     disp('最优权重:');
%     disp(e_opt);
end
