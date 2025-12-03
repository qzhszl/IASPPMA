function D_demand = generate_demand_distance_matrix(Ainput,minlinkweight,maxlinkweight)
    G_demand = graph(Ainput);
    G_demand.Edges.Weight = randi([minlinkweight,maxlinkweight], numedges(G_demand), 1);
    D_demand = distances(G_demand);
end
