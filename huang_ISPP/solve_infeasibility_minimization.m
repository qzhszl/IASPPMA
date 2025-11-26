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
