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

compute_region = 0:0.01:maxstep;
targetdistance_vec = zeros(length(compute_region),1);

count = 1;
for epsilon = compute_region
    Dnew = D_o+epsilon*D_base;
    targetdistance  = sum(sum(abs(Dnew - D_target)))/sum(sum(abs(D_target)));
    targetdistance_vec(count) = targetdistance;
    count=count+1;
end

plot(compute_region,targetdistance_vec)


% function A_output = ISPP_MA_Qiu(A_input,D)
%     G = graph(A_input)
%     distance 
%     D_o = 
% 
% 
% end