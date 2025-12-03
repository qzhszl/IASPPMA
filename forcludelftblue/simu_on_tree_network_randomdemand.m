function [distances_deviation1,distances_deviation2_vec,t_LP,t_dbs_vec]=simu_on_tree_network_randomdemand(N)
    %for a tree network
    %_______________________________________________________________________
    % generate a tree network with uniformly random distributed link weight
    T = generate_a_tree(N,1,10);
    A_input = full(T.adjacency("weighted"));
    
    % generate a distance matrix with uniformly random distributed link weight
    % as the demand matrix
    D_demand = generate__random_demand_distance_matrix(N,10);
    
    tic
    [A_LP,D_target]=ISPP_givenA_LP(A_input,D_demand);
    t_LP = toc;
    disp(t_LP)
    % G2 = graph(A_LP);
    u  = ones(1,N);
    distances_deviation1 = u*abs(D_target-D_demand)*u.'/sum(sum(D_demand));
    linknum = numedges(T);
    base_num_vec =  round(linspace(2, linknum, 5));
    distances_deviation2_vec = zeros(1,5);
    t_dbs_vec = zeros(1,5);

    count = 1;
    for basement_num = base_num_vec
        tic
        [A_Q,D_Q] = ISPP_givenA_Qiu(A_input,D_demand,basement_num);
        % [A_Q,D_Q] = ISPP_givenA_Qiu_randombase(A_input,D_target,basement_num);
        t_dbs = toc;
        t_dbs_vec(count) = t_dbs;
        % Goutput = graph(A_Q);
        distances_deviation2 = u*abs(D_Q-D_demand)*u.'/sum(sum(D_demand));
        distances_deviation2_vec(count) = distances_deviation2;
        count = count+1;
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
