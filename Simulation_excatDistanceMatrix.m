% This .m will test the performance of our approximated method for 
% the IASPP with the minimum link weight adjustment
clear,clc
N=100;
T = generate_a_tree(N,1,10);
subplot(2,2,1)
plot(T,'EdgeLabel',T.Edges.Weight,'NodeColor',[0.8500 0.3250 0.0980], ...
'EdgeAlpha',0.5,'LineWidth',1,'MarkerSize',7,'EdgeLabelColor',[0 0.4470 0.7410],'NodeFontSize',10);
A_T = full(T.adjacency("weighted"));
A = A_T;
A(A~=0) =1;


A_dis = randi(10,N,N).*triu(A,1); % network that provides the targeted shortest path distances matrix
A_dis  = A_dis+A_dis.';
G_dis = graph(A_dis);
D_dis = distances(G_dis); % TARGET DISTANCE

A_new = DOR(D_dis, 'advanced');
G2 = graph(A_new);
subplot(2,2,2)
plot(G2,'EdgeLabel',G2.Edges.Weight,'NodeColor',[0.8500 0.3250 0.0980], ...
'EdgeAlpha',0.5,'LineWidth',1,'MarkerSize',7,'EdgeLabelColor',[0 0.4470 0.7410],'NodeFontSize',10);

u = ones(1,N);
distances_deviation1 = 0.5*u*abs(distances(G2)-D_dis)*u.'
subplot(2,2,3)
A_output = ISPP_MA_Qiu(A_T,D_dis);
subplot(2,2,4)
Goutput = graph(A_output);
plot(Goutput,'EdgeLabel',Goutput.Edges.Weight,'NodeColor',[0.8500 0.3250 0.0980], ...
'EdgeAlpha',0.5,'LineWidth',1,'MarkerSize',7,'EdgeLabelColor',[0 0.4470 0.7410],'NodeFontSize',10);
distances_deviation2 = 0.5*u*abs(distances(Goutput)-D_dis)*u.'
nonzero_idx = D_dis~=0;
deviation_matrix = abs(distances(Goutput)-D_dis);
distances_deviation2_ratio = mean(deviation_matrix(nonzero_idx)./D_dis(nonzero_idx))
distances_deviation2_ratio = (u*(abs(distances(Goutput)-D_dis))*u.')/(u*(D_dis)*u.')

function T = generate_a_tree(N,minlinkweight,maxlinkweight)

% 生成完全连接的随机加权图
W = randi([minlinkweight,maxlinkweight], N, N);  % 生成 1-10 之间的随机整数
W = triu(W,1);            % 仅保留上三角部分以避免重复
W = W + W';               % 生成对称矩阵，表示无向图

% 计算最小生成树
G = graph(W);             % 生成图
T = minspantree(G);       % 计算最小生成树
end
