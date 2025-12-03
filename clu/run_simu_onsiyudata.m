function run_simu_onsiyudata(N, dsmall,dmid,dlarge,external_simu_time)

% This .m will test the performance of our approximated method for 
% the IASPP with given adjacency matrix.

% the demand matrix is random generated demand matrix
%  The service instances considered during the evaluations are classified into three categories: 
% delay sensitive traffic with very small latency bound from 100µs to 2ms, 
% network control traffic with latency requirement between 2ms and 20ms, 
% traffic that are less stringent on E2E latency, e.g., 50ms to 1s. 
% The percentage of the three categories so that in one scenario, you have e.g., more than 50\% of the traffic with very stringent latency bound, etc. 

% clear,clc
% Nvec = [10,20,50,100];
% for N = Nvec
%     run_simu_onsitydata(N,0.5,0.25,0.25)
% end

% the sum of the percentage of three types of delay should be 1
rng(external_simu_time)
simutimes = 10;
result = zeros(simutimes,13);
for i = 1:simutimes
    tic
    [distances_deviation1,distances_deviation2_vec,t_LP,t_dbs_vec,tree_diameter]=simu_on_tree_network_siyu(N, dsmall,dmid,dlarge);
    result(i,:) = [distances_deviation1,distances_deviation2_vec,t_LP,t_dbs_vec,tree_diameter];
    disp(toc)
end
filename = sprintf("LPvsQiu_N%ddataper%.2f%.2f%.2f_siyuinput_treefromERp05_simu%d.txt",N,dsmall,dmid,dlarge,external_simu_time);
writematrix(result,filename)
end






