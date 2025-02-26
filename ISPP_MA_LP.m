% Program name: ISPPMAE: Inverse all shortest path problem with the minimum
% adjustment of the sum of the link weights

% Solve the problem using ILP
% 定义树形网络T1的邻接矩阵A1和距离矩阵D
A1 = [0, 1, 0, 0;
      1, 0, 1, 1;
      0, 1, 0, 0;
      0, 1, 0, 0];  % 原始树形网络T1的邻接矩阵 (n x n)
D = [0, 2, 5, 6;
    2, 0, 3, 4;
    5, 3, 0, 5;
    6, 4, 5, 0];   % 目标距离矩阵D (n x n)

% 节点数目
n = size(A1, 1);

% 定义所有节点的单位向量u
u = ones(n, 1);

% 初始猜测：令A2的初始值与A1相同
A2_init = A1(:);  % 将A1重塑为列向量

% 设置优化参数
options = optimset('Display', 'iter', 'Algorithm', 'interior-point');

% 定义A2的下界和上界（假设权重是非负的）
lb = zeros(size(A2_init));  % 下界：权重必须为非负
ub = inf * ones(size(A2_init));  % 上界：没有明确的上界

% 设置epsilon（约束的容忍度）
epsilon = 1e-5;

% 使用fmincon进行优化求解
[A2_opt, fval] = fmincon(@(A2) objective(A2, A1), A2_init, [], [], [], [], lb, ub, @(A2) constraint(A2, A1, D, epsilon), options);

% 将优化后的A2重塑为矩阵形式
A2_opt_matrix = reshape(A2_opt, size(A1));

% 输出结果
disp('优化后的邻接矩阵A2：');
disp(A2_opt_matrix);
disp('最终目标函数值（邻接矩阵调整的绝对差异）：');
disp(fval);


% 计算最短路径矩阵的函数 (使用Dijkstra算法)
function S = shortestPath(A, W)
    % 初始化最短路径矩阵
    S = inf(n, n);
    for i = 1:n
        % 使用Dijkstra算法计算从节点i到所有其他节点的最短路径
        [dist, ~] = graphshortestpath(sparse(A), i, 'Weights', W(i, :));
        S(i, :) = dist;
    end
end

% 目标函数 (最小化邻接矩阵调整的绝对差异)
function f = objective(A2, A1)
    A2_matrix = reshape(A2, size(A1));  % 将A2重塑为邻接矩阵
    f = sum(abs(A2_matrix - A1), 'all');  % 计算元素之和的绝对差异
end

% 约束函数 (确保最短路径矩阵与目标矩阵D的差异小于epsilon)
function [c, ceq] = constraint(A2, A1, D, epsilon)
    A2_matrix = reshape(A2, size(A1));  % 将A2重塑为邻接矩阵
    S = shortestPath(A1, A2_matrix);  % 计算T2网络的最短路径矩阵S
    c = sum(abs(S - D), 'all') - epsilon;  % 确保S和D的差异小于epsilon
    ceq = [];  % 无等式约束
end
