function run_Simulation_exacttreeDistanceMatrix(N,external_simu_time)

% This .m will test the performance of our approximated method for 
% the IASPP with given adjacency matrix.
filename = sprintf("LPvsQiu_N%dExactsolutonhavetime_simu%d.txt",N,external_simu_time);
disp(filename)
rng(external_simu_time)
simutimes = 50;

result = zeros(simutimes,12);
for i = 1:simutimes
    [distances_deviation1,distances_deviation2_vec,t_LP,t_dbs_vec]=simu_on_tree_network(N);
    result(i,:) = [distances_deviation1,distances_deviation2_vec,t_LP,t_dbs_vec];
end
writematrix(result,filename)
end


