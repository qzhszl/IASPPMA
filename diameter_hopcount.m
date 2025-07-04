function rou = diameter_hopcount(adj)
    A = double(adj > 0);
    G = graph(A);
    D = distances(G);
    rou = max(D(:));
end
