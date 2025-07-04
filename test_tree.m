clear,clc
% test 1
% % generate two trees , one from ER, one from BA
% A = GenerateERfast(10,0.5,10)
% G = graph(A);             % 生成图
% T = minspantree(G);       % 计算最小生成树
% 
% rou = diameter_hopcount(full(adjacency(T)))
% % T = bfs_spanning_tree(G)
% % lineAdj = generate_star_network(10,1);
% % T = graph(lineAdj)
% 
% subplot(2,2,1)
% plot(T,'EdgeLabel',T.Edges.Weight,'NodeColor',[0.8500 0.3250 0.0980], ...
% 'EdgeAlpha',0.5,'LineWidth',1,'MarkerSize',7,'EdgeLabelColor',[0 0.4470 0.7410],'NodeFontSize',10);
% 
% 
% A = generate_weighted_BA(100,3,10)
% G = graph(A)
% T = minspantree(G);       % 计算最小生成树
% % T = bfs_spanning_tree(G)
% subplot(2,2,2)
% plot(T,'EdgeLabel',T.Edges.Weight,'NodeColor',[0.8500 0.3250 0.0980], ...
% 'EdgeAlpha',0.5,'LineWidth',1,'MarkerSize',7,'EdgeLabelColor',[0 0.4470 0.7410],'NodeFontSize',10);
% 
% figure
% degreesequence = degree(G);
% h = histogram(degreesequence,'Normalization','pdf');
% x1 = h.BinEdges;
% x1 = x1(1:length(x1)-1);
% y1 = h.Values;
% plot(x1,y1)
% set(gca, 'Xscale','log')
% set(gca, 'Yscale','log')



% test 2: how the hopcount diameter change with the increment of p of ER
simutimes = 1000;

N = 20;
for p = [0.25]
    count = 1;
    rou_vec = zeros(simutimes,1);
    for i = 1: simutimes
        A_input = GenerateERfast(N,p,10);
                    % 生成图
        connect_flag = network_isconnected(A_input);
        while ~connect_flag
            A_input = GenerateERfast(N,p,10);
            % check connectivity
            connect_flag = network_isconnected(A_input);
        end
        G = graph(A_input); 
        T = minspantree(G);       % 计算最小生成树
        rou = diameter_hopcount(full(adjacency(T)));
        rou_vec(count) = rou;
        count = count+1;
    end
    mean(rou_vec)
end



function A = GenerateERfast(n,p,weighted)
    A = rand(n,n) < p;
    A = triu(A,1);
    if weighted == 0
        
    elseif weighted == 1
        linkweight_matrix = rand(n,n);
        A = A.*linkweight_matrix;
    else
        linkweight_matrix = randi(weighted,n,n);
        A = A.*linkweight_matrix;
    end
    
    A = A + A';
end


function T = bfs_spanning_tree(G, root)
% 构造无权图 G 的 BFS 生成树，从指定根节点 root 开始

% 输入:
%   G    - 无权 graph 对象
%   root - BFS 起点节点编号（默认为 1）

if nargin < 2
    root = 1;
end

% 1. 获取构成生成树的边（BFS）
bfsEdges = bfsearch(G, root, 'edgetonew');  % 每行是 [source, target]

% 2. 查询原图中每条边的权重
numEdges = size(bfsEdges, 1);
weights = zeros(numEdges, 1);

for i = 1:numEdges
    s = bfsEdges(i,1);
    t = bfsEdges(i,2);

    % 使用 findedge 查询权重（边的索引）
    edgeIdx = findedge(G, s, t);
    weights(i) = G.Edges.Weight(edgeIdx);
end

% 3. 构建带权生成树
T = graph(bfsEdges(:,1), bfsEdges(:,2), weights);

end

function A = generate_weighted_BA(N,m,weighted)
    seed =[0 1 0 0 1;1 0 0 1 0;0 0 0 1 0;0 1 1 0 0;1 0 0 0 0];
    Net = SFNG(N, m, seed);
    linkweight_matrix = randi(weighted,N,N);
    A = Net.*triu(ones(N,N),1).*linkweight_matrix;
    A = A+A.';
end


function [isConnected] = network_isconnected(adj)
    G = graph(adj);
    components = conncomp(G);
    % 判断图是否连通
    isConnected = (max(components) == 1);
end