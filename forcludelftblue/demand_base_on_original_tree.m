function D_demand = demand_base_on_original_tree(A_input,perturbation_scale)
    N = size(A_input,1);
    G = graph(A_input);
    D_demand = distances(G);
    perturbation = rand(N,N);
    perturbation = triu(perturbation,1);
    perturbation = perturbation+perturbation.';
    perturbation = perturbation_scale.*perturbation;
    D_demand = D_demand+perturbation;
end