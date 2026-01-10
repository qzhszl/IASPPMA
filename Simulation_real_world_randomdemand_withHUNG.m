% This .m will test the performance of our approximated method for 
% the IASPP with given adjacency matrix.

% the demand matrix is random generated demand matrix
% the topology of the tree network is from a star to a path graph(a line)
% thus we change the diameter of the underlying topology
clear,clc
% Nvec = [10,20,50,100];
% A = loadrealA(10)
N = 30;
simutimes = 1000;

result = zeros(simutimes,14);
for i = 1:simutimes
    [distances_deviation1,dev_hung,distances_deviation2_vec,t_LP,t_hung,t_dbs_vec]=simu_on_realtree_network(N);
    result(i,:) = [distances_deviation1,dev_hung,distances_deviation2_vec,t_LP,t_hung,t_dbs_vec];
end
filename = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\realworld\\LPvsQiu_N%dhavetime_randominput_realworld.txt",N);

writematrix(result,filename)


function [distances_deviation1,dev_hung,distances_deviation2_vec,t_LP,t_hung,t_dbs_vec]=simu_on_realtree_network(N)
    A_input = loadrealA(10);
    
    % generate a distance matrix with uniformly random distributed link weight
    % as the demand matrix
    D_demand = generate_demand_distance_matrix(N,10);
    
    tic
    [A_LP,D_target]=ISPP_givenA_LP(A_input,D_demand);
    t_LP = toc;
    disp(t_LP)
   

    u  = ones(1,N);
    distances_deviation1 = u*abs(D_target-D_demand)*u.'/sum(sum(D_demand));
    linknum = N-1;
    
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

    
    tic
    [A_LP,D_target_hung]=hung_ISPP(A_input,D_demand);
    t_hung = toc;
    disp(t_LP)
    % G2 = graph(A_LP);
    dev_hung = u*abs(D_target_hung-D_demand)*u.'/sum(sum(D_demand));


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

function A = loadrealA(max_linkweight)
    % number of nodes
    N = 30;
    
    % initialize adjacency matrix
    A = zeros(N);
    
    % =========================
    % Core -> Aggregation
    % =========================
    A(1,2) = 1; A(2,1) = 1;
    A(1,3) = 1; A(3,1) = 1;
    A(1,4) = 1; A(4,1) = 1;
    A(1,11) = 1; A(11,1) = 1;
    A(1,12) = 1; A(12,1) = 1;
    A(1,13) = 1; A(13,1) = 1;
    
    % =========================
    % Aggregation -> Access
    % =========================
    A(2,5)  = 1; A(5,2)  = 1;
    A(2,6)  = 1; A(6,2)  = 1;
    A(2,14)  = 1; A(14,2)  = 1;
    A(2,15)  = 1; A(15,2)  = 1;
    
    A(3,16)  = 1; A(16,3)  = 1;
    
    A(4,7)  = 1; A(7,4)  = 1;
    A(4,8)  = 1; A(8,4)  = 1;
    A(4,9)  = 1; A(9,4)  = 1;
    A(4,10)  = 1; A(10,4)  = 1; 
    A(4,17) = 1; A(17,4)= 1;
    A(4,18) = 1; A(18,4)= 1;
    
    % =========================
    % Access -> End Devices
    % =========================
    % SW5
    A(5,19) = 1; A(19,5) = 1;
    A(5,20) = 1; A(20,5) = 1;
    
    
    % SW6
    A(6,22) = 1; A(22,6) = 1;
    A(6,23) = 1; A(23,6) = 1;
    A(6,24) = 1; A(24,6) = 1;
    A(6,25) = 1; A(25,6) = 1;
    
    
    % SW7
    A(7,26) = 1; A(26,7) = 1;
    A(7,21) = 1; A(21,7) = 1;
    
    % SW8
    A(8,27) = 1; A(27,8) = 1;
    
    
    % SW9
    A(9,28) = 1; A(28,9) = 1;
    A(9,29) = 1; A(29,9) = 1;
    
    % SW10
    A(10,30) = 1; A(30,10) = 1;
    

    W = randi(max_linkweight,N,N).*triu(A,1);
%     A = A.*W;
    A = W+W.';


%     G = graph(A);
%     figure;
%     plot(G, ...
%         'Layout','layered', ...
%         'Direction','down', ...
%         'EdgeLabel',G.Edges.Weight);

end


