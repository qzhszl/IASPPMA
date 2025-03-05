function A_output = ISPP_MA_Qiu(A_input,D_target)
    G = graph(A_input);
    D_o = distances(G);
    
    A = A_input;
    A(A~=0) =1;
    G_base = graph(A);
    D_base = distances(G_base);
    

    idx = ~eye(size(D_o));  % 逻辑矩阵，非对角线位置为 1
    % 对非对角线元素执行逐元素除法
    ratioMatrix = D_target ./ D_o;  % 计算 A/B
    validRatios = ratioMatrix(idx);  % 仅保留非对角线元素
    % 找到最小值
    minValue = min(validRatios);
    D_o = D_o*minValue;
    difference_matrix = (D_target - D_o)./D_base;
    maxstep = max(difference_matrix(idx));

    step_region = 0:0.01:maxstep;
    targetdistancediff_vec = zeros(length(step_region),1);
    
    count = 1;
    for epsilon = step_region
        Dnew = D_o+epsilon*D_base;
        targetdistancediff  = sum(sum(abs(Dnew - D_target)))/sum(sum(abs(D_target)));
        targetdistancediff_vec(count) = targetdistancediff;
        count=count+1;
    end
    
    [ymin,yminidx] = min(targetdistancediff_vec);
    epsilon_target = step_region(yminidx);
    Dnew = D_o+epsilon_target*D_base;
    plot(step_region,targetdistancediff_vec)
    A_output = DOR(Dnew,'advanced');
end