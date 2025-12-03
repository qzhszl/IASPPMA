function run_Simulation_SmallchangebasedonexcatDistanceMatrix(N,external_simu_time)
    filename = sprintf("LPvsQiu_N%dPerturbation1havetime_simu%d.txt",N,external_simu_time);
    disp(filename)
    rng(external_simu_time)
    simutimes = 50;
    for N = Nvec
        result = zeros(simutimes,12);
        for i = 1:simutimes
            [distances_deviation1,distances_deviation2_vec,t_LP,t_dbs_vec]=simu_on_tree_network_perturbation(N);
            result(i,:) = [distances_deviation1,distances_deviation2_vec,t_LP,t_dbs_vec];
        end
        writematrix(result,filename)
    end
end


