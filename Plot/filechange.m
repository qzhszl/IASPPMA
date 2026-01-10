clear,clc

N  = 80
param_sets = [0.5, 0.25, 0.25;
              0.25,0.5,0.25;
              0.25,0.25,0.5;
              0.34, 0.33, 0.33;
              ];
i=1;
dsmall = param_sets(i, 1);
dmid   = param_sets(i, 2);
dlarge = param_sets(i, 3);


file1_name = sprintf("D:\\data\\ISPP_givenA\\complete_random_demand\\SiyuData\\discrete\\descretedemandLPvsQiu_N%ddataper%.2f%.2f%.2f_siyuinput_treefromERp05.txt",N,dsmall,dmid,dlarge);
file2_name = sprintf("D:\\data\\ISPP_givenA\\test\\descretedemandLPvsQiu_N%ddataper%.2f%.2f%.2f_siyuinput_treefromERp05.txt",N,dsmall,dmid,dlarge);

result1 = readmatrix(file1_name);

result2 = readmatrix(file2_name);

output_matrix = result1;

output_matrix(:,7:12) = result2(:,7:12);



file3_name = sprintf("D:\\data\\ISPP_givenA\\test\\filechange\\descretedemandLPvsQiu_N%ddataper%.2f%.2f%.2f_siyuinput_treefromERp05.txt",N,dsmall,dmid,dlarge);
writematrix(output_matrix, file3_name);
