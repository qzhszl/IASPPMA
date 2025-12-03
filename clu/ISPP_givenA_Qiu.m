function [A_output,Dnew] = ISPP_givenA_Qiu(A_input,D_target,base_num)
    T = A_input;
    T(T~=0) =1;
    G_T = graph(T);
    tic
    D_T = 0.001*distances(G_T);    
    linknum = numedges(G_T);
    G_base = graph(A_input);
    D_base = 0.001*distances(G_base);

    if base_num < 1
        error('Not enough number of basement');
    elseif base_num > linknum
        error('too many basement');
    end

    if base_num ==2
        D_list = {D_T;D_base};
    elseif base_num == linknum
        T_O = 0.001*T;
        G_o = graph(T_O);
        D_list = cell([numedges(G_T), 1]);
        for i = 1:linknum
            G_base = G_o;
            G_base.Edges.Weight(i) = 1;
            D_base = distances(G_base);
            D_list{i} = D_base;
        end
    else
        T_O = 0.001*T;
        G_o = graph(T_O);
        D_list = cell([base_num, 1]);
        D_list{1} = D_T;
        D_list{2} = D_base;
        for i = 3:base_num
            G_base = G_o;
            G_base.Edges.Weight(i) = 1;
            D_base = distances(G_base);
            D_list{i} = D_base;
        end
    end
    e_opt = solve_weighted_matrix_linprog(D_target, D_list);
    Dnew = sum(cat(3, D_list{:}) .* reshape(e_opt, 1, 1, []), 3);
    A_output = DOR(Dnew,'advanced');
    % difference = sum(sum(abs(Dnew - D_target)));
    % disp(['总误差: ', num2str(difference)]);
end




