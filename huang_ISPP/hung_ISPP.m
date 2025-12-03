function [A_output,D_output]=hung_ISPP(A,D)
    G_T = graph(A);
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
    while iteration_times<30
        [sum_infeasibility,infeasibility,~,G_T] = solve_infeasibility_minimization(P,target_D,m,G_T,D);
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
        options = optimoptions('linprog','Display','none'); % 或 'none'
        [w_opt, ~, ~, ~] = linprog(f, A, B, Aeq, Beq, lb, ub, options);
        
        G_T.Edges.Weight = w_opt;
        A_output = full(G_T.adjacency("weighted"));
        D_output = distances(G_T);
        % sum_infeasibility =  sum(sum(abs(D_output-D)));
        iteration_times = iteration_times+1;
    end

end




