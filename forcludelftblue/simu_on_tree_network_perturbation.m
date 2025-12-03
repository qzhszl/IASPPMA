function [distances_deviation1,distances_deviation2_vec,t_LP,t_dbs_vec]=simu_on_tree_network_perturbation(N)
    %for a tree network
    %_______________________________________________________________________
    % generate a tree network with uniformly random distributed link weight
    T = generate_a_tree(N,1,10);
    A_input = full(T.adjacency("weighted"));
    
    % generate a distance matrix with uniformly random distributed link weight
    % as the demand matrix
    D_demand = demand_base_on_original_tree(A_input,1);
    
    tic
    [A_LP,D_target]=ISPP_givenA_LP(A_input,D_demand);
    t_LP = toc;
    % G2 = graph(A_LP);
    u  = ones(1,N);
    distances_deviation1 = u*abs(D_target-D_demand)*u.'/sum(sum(D_demand));
    linknum = numedges(T);
    base_num_vec =  round(linspace(2, linknum, 5));
    % distances_deviation2_vec = zeros(1,length(base_num_vec));

    distances_deviation2_vec = zeros(1,5);
    t_dbs_vec = zeros(1,5);
    count = 1;
    for basement_num = base_num_vec
        tic
        [A_Q,D_Q] = ISPP_givenA_Qiu(A_input,D_demand,basement_num);
        t_dbs = toc;
        t_dbs_vec(count) = t_dbs;
        % Goutput = graph(A_Q);
        distances_deviation2 = u*abs(D_Q-D_demand)*u.'/sum(sum(D_demand));
        distances_deviation2_vec(count) = distances_deviation2;
        count = count+1;
    end
end
