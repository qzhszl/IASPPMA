function D_demand = generate_siyu_demand_distance_matrix(N,dsmall,dmid,dlarge)
    % delay sensitive traffic with very small latency bound from 100µs to 2ms, 
    % network control traffic with latency requirement between 2ms and 20ms, 
    % traffic that are less stringent on E2E latency, e.g., 50ms to 1s. 
    % 确保比例总和为100%
    if dsmall + dmid + dlarge ~= 1
        error('dsmall, dmid, dlarge 的总和必须为100');
    end

    % 计算矩阵中独立元素的数量（上三角不含对角线）
    num_elements = N * (N - 1) / 2;

    % 每个区间的数量
    num_a = round(dsmall * num_elements);
    num_b = round(dmid * num_elements);
    num_c = num_elements - num_a - num_b; % 剩余分给 c

    % 生成对应区间的随机数
    demands_a = 0.0001 + (0.002 - 0.0001) * rand(num_a, 1);
    demands_b = 0.002 + (0.02 - 0.002) * rand(num_b, 1);
    demands_c = 0.05 + (1 - 0.05) * rand(num_c, 1);

    % 合并并打乱顺序
    demands = [demands_a; demands_b; demands_c];
    demands = demands(randperm(length(demands)));

    % 创建上三角矩阵（不含对角线）
    D = zeros(N);
    upper_indices = find(triu(ones(N), 1));
    D(upper_indices) = demands;

    % 生成对称矩阵
    D_demand = D + D';
    G = graph(D_demand);
    D_demand = distances(G);
    % 可选：设置对角线为0（或其他值）
    % D(1:N+1:end) = 0;
end


