function T = generate_a_tree_fromER(N,p,maxlinkweight)
    A = GenerateERfast(N,p,maxlinkweight);
                    % 生成图
    connect_flag = network_isconnected(A);
    while ~connect_flag
        A = GenerateERfast(N,p,10);
        % check connectivity
        connect_flag = network_isconnected(A);
    end
    G = graph(A); 
    T = minspantree(G);       % 计算最小生成树
end

