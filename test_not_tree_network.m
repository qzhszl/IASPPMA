clear,clc

% A1 = GenerateERfast(10,0.5,0)
A1 = [0	1	0	0	1	1	0	0	1	1
1	0	1	1	1	0	1	1	0	1
0	1	0	1	0	0	0	0	0	0
0	1	1	0	0	1	0	1	0	0
1	1	0	0	0	1	0	0	0	0
1	0	0	1	1	0	0	1	1	1
0	1	0	0	0	0	0	1	0	0
0	1	0	1	0	1	1	0	0	1
1	0	0	0	0	1	0	0	0	1
1	1	0	0	0	1	0	1	1	0]

G = graph(A1);
G1 = G;
G1.Edges.Weight = randi(10,numedges(G1),1);
subplot(2,2,1)
plot(G1,'EdgeLabel',G1.Edges.Weight,'NodeColor',[0.8500 0.3250 0.0980], ...
'EdgeAlpha',0.5,'LineWidth',1,'MarkerSize',7,'EdgeLabelColor',[0 0.4470 0.7410],'NodeFontSize',10);
D1 = distances(G1);


G2 = G;
G2.Edges.Weight = randi(10,numedges(G2),1);
subplot(2,2,2)
plot(G2,'EdgeLabel',G2.Edges.Weight,'NodeColor',[0.8500 0.3250 0.0980], ...
'EdgeAlpha',0.5,'LineWidth',1,'MarkerSize',7,'EdgeLabelColor',[0 0.4470 0.7410],'NodeFontSize',10);

D2 = distances(G2);

D3 = D1+D2;
A3 = DOR(D3,'advanced')
A3(A3~=0)=1
A3-A1





