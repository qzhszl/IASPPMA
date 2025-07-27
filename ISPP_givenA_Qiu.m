function [A_output,Dnew] = ISPP_givenA_Qiu(A_input,D_target,base_num)
    T = A_input;
    T(T~=0) =1;
    G_T = graph(T);
    tic
    D_T = 0.0001*distances(G_T);    
    linknum = numedges(G_T);
    G_base = graph(A_input);
    D_base = 0.0001*distances(G_base);

    if base_num < 1
        error('Not enough number of basement');
    elseif base_num > linknum
        error('too many basement');
    end

    if base_num ==2
        D_list = {D_T;D_base};
    elseif base_num == linknum
        T_O = 0.0001*T;
        G_o = graph(T_O);
        D_list = cell([numedges(G_T), 1]);
        for i = 1:linknum
            G_base = G_o;
            G_base.Edges.Weight(i) = 1;
            D_base = distances(G_base);
            D_list{i} = D_base;
        end
    else
        T_O = 0.0001*T;
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


