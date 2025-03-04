clear,clc
A_INPUT = [0	0	0	1	0	0	0	0	0	1
0	0	0	1	0	0	0	0	0	0
0	0	0	0	0	0	4	0	0	0
1	1	0	0	2	0	1	0	0	0
0	0	0	2	0	0	0	1	0	0
0	0	0	0	0	0	0	0	2	0
0	0	4	1	0	0	0	0	0	0
0	0	0	0	1	0	0	0	0	0
0	0	0	0	0	2	0	0	0	2
1	0	0	0	0	0	0	0	2	0];


D_target = [0	8	19	6	7	13	13	13	12	7
8	0	15	2	3	21	9	9	20	15
19	15	0	13	14	32	6	20	31	26
6	2	13	0	1	19	7	7	18	13
7	3	14	1	0	20	8	6	19	14
13	21	32	19	20	0	26	26	1	6
13	9	6	7	8	26	0	14	25	20
13	9	20	7	6	26	14	0	25	20
12	20	31	18	19	1	25	25	0	5
7	15	26	13	14	6	20	20	5	0];

G = graph(A_INPUT);
D_o = distances(G);

A = A_INPUT;
A(A~=0) =1;
G_base = graph(A);
D_base = distances(G_base)

A_base1 = 0.01*A;
G_base = graph(A_base1);
G_base.Edges.Weight(1) = 1;
D_base1 = distances(G_base)


A_base2 = 0.01*A;
G_base = graph(A_base2);
G_base.Edges.Weight(3) = 1;
D_base2 = distances(G_base)


idx = ~eye(size(D_o));  % 逻辑矩阵，非对角线位置为 1
% 对非对角线元素执行逐元素除法
ratioMatrix = D_target ./ D_o;  % 计算 A/B
validRatios = ratioMatrix(idx);  % 仅保留非对角线元素
% 找到最小值
minValue = min(validRatios);
D_o = D_o*minValue;

difference_matrix = (D_target - D_o)./D_base;
maxstep = max(difference_matrix(idx));

compute_region = 0:0.1:maxstep;


difference_matrix1 = (D_target - D_o)./D_base1;
maxstep1 = max(difference_matrix1(idx));
compute_region1 = 0:1:maxstep1;


difference_matrix2 = (D_target - D_o)./D_base2;
maxstep2 = max(difference_matrix2(idx));
compute_region2 = 0:1:maxstep2;

targetdistance_vec = zeros(length(compute_region)*length(compute_region1)*length(compute_region2),1);
targetdistance_vec2 = zeros(length(compute_region)*length(compute_region1)*length(compute_region2),1);
count = 1;
minratio = inf;
minratio2 = inf;
for epsilon = compute_region
    for epsilon2 = compute_region2
        for epsilon1 = compute_region1
            Dnew = D_o+epsilon*D_base+epsilon2*D_base2+epsilon1*D_base1;
            targetdistance  = sum(sum(abs(Dnew - D_target)))/sum(sum(abs(D_target)));
            targetdistance_vec(count) = targetdistance;
            
            nonzero_idx = D_target~=0;
            deviation_matrix = abs(Dnew-D_target);
            distances_deviation2_ratio = mean(deviation_matrix(nonzero_idx)./D_target(nonzero_idx));
            targetdistance_vec2(count) = distances_deviation2_ratio;
            if targetdistance < minratio
                bestepsilon = epsilon;
                bestepsilon1 = epsilon1;
                bestepsilon2 = epsilon2;
                minratio = targetdistance;
            end

            if distances_deviation2_ratio < minratio2
                bestepsilon_2 = epsilon;
                bestepsilon1_2 = epsilon1;
                bestepsilon2_2 = epsilon2;
                minratio2 = distances_deviation2_ratio;
            end
            count=count+1;
            if rem(count, 100000)==0
                count/100000
            end
        end
    end
end

minratio
minratio2

plot(targetdistance_vec2)


% function A_output = ISPP_MA_Qiu(A_input,D)
%     G = graph(A_input)
%     distance 
%     D_o = 
% 
% 
% end