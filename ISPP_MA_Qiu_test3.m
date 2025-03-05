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

T_O = 0.01*T;
G_o = graph(T_O);
D1 = distances(G_o);
G1 = G_o;
G1.Edges.Weight(1) = 1
D2 = distances(G1)
G2 = G_o;
G2.Edges.Weight(2) = 1
D3 = distances(G2)
G3 = G_o;
G3.Edges.Weight(3) = 1
D3 = distances(G3)


[e1, e2, e3] = solve_weights(D, D1, D2, D3);
disp(['Optimal e1: ', num2str(e1)]);
disp(['Optimal e2: ', num2str(e2)]);
disp(['Optimal e3: ', num2str(e3)]);

D_solution = e1*D1 + e2*D2 + e3*D3
difference = sum(sum(abs(e1*D1 + e2*D2 + e3*D3 - D)));


function [e1, e2, e3] = solve_weights(D, D1, D2, D3)
    % 定义目标函数（最小化加权矩阵与目标矩阵之间的元素绝对差异）
    objective = @(e) sum(sum(abs(e(1)*D1 + e(2)*D2 + e(3)*D3 - D)));

    % 初始猜测：e1, e2, e3 都设置为 1
    initial_guess = [1, 1, 1];

    % 设置非负约束
    lb = [0, 0, 0];  % e1, e2, e3 的下界是 0
    ub = [];          % 没有上界

    % 使用 fmincon 求解最优化问题
    options = optimoptions('fmincon', 'Display', 'off');
    [e_opt, fval] = fmincon(objective, initial_guess, [], [], [], [], lb, ub, [], options);

    % 提取最优的 e1, e2, e3
    e1 = e_opt(1);
    e2 = e_opt(2);
    e3 = e_opt(3);
end
