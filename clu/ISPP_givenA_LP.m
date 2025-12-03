function [A_output,D_output] = ISPP_givenA_LP(A_input,D_demand)    
    T = A_input;  % 无权树（邻接矩阵）
    T(T~=0) =1;
    G_T = graph(T);
    % INPUT demand
    w_opt = optimize_tree_weights_L1(T, D_demand);
    G_T.Edges.Weight = w_opt;
    A_output = full(G_T.adjacency("weighted"));
    D_output = distances(G_T);
end

