function D_demand = generate__random_demand_distance_matrix(N,max_linkweight)
    A = ones(N);
    A_demand = randi(max_linkweight,N,N).*triu(A,1); % network that provides the targeted shortest path distances matrix
    G_demand = graph(A_demand,'upper');
    D_demand = distances(G_demand);
end

