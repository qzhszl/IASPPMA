clear,clc
T1 =[0 5 5 0 4 10
5 0 0 0 2 0
5 0 0 9 0 6
0 0 9 0 0 0
4 2 0 0 0 0
10 0 6 0 0 0];
% T1 = randi(10,6,6)
% T1 = triu(T1,1);
% T1 = T1+T1.'
G = graph(T1);
subplot(2,2,1)
plot(G,'EdgeLabel',G.Edges.Weight,'NodeColor',[0.8500 0.3250 0.0980], ...
'EdgeAlpha',0.5,'LineWidth',1,'MarkerSize',7,'EdgeLabelColor',[0 0.4470 0.7410],'NodeFontSize',10);
% Aforomega = T1;
% Aforomega(Aforomega ~= 0) = 1 ./ Aforomega(Aforomega ~= 0);
% Omega = EffectiveResistance(Aforomega);
D = distances(G);
% A =ISPP_tree(Omega);
% A2 = ISPP_tree(D);
% A2(A2 ~= 0) = 1 ./ A2(A2 ~= 0);
% G2 = graph(A2);
% subplot(2,2,2)
% plot(G2,'EdgeLabel',G2.Edges.Weight,'NodeColor',[0.8500 0.3250 0.0980], ...
% 'EdgeAlpha',0.5,'LineWidth',1,'MarkerSize',7,'EdgeLabelColor',[0 0.4470 0.7410],'NodeFontSize',10);
% % 几何倍速增加是可以获得的
% D2 = 2*D;
% A2 = ISPP_tree(D2);
% A2(A2 ~= 0) = 1 ./ A2(A2 ~= 0);
% G2 = graph(A2);
% subplot(2,2,3)
% plot(G2,'EdgeLabel',G2.Edges.Weight,'NodeColor',[0.8500 0.3250 0.0980], ...
% 'EdgeAlpha',0.5,'LineWidth',1,'MarkerSize',7,'EdgeLabelColor',[0 0.4470 0.7410],'NodeFontSize',10);
% 一个tree network的DOR
A2 = ISPP_DOR2(D);
G2 = graph(A2);
subplot(2,2,2)
plot(G2,'EdgeLabel',G2.Edges.Weight,'NodeColor',[0.8500 0.3250 0.0980], ...
'EdgeAlpha',0.5,'LineWidth',1,'MarkerSize',7,'EdgeLabelColor',[0 0.4470 0.7410],'NodeFontSize',10);
T2 = 0.0001*(T1~=0);
T2(1,2) = 1;
T2(2,1) = 1;
 
% T2 = 0.0001*(T1~=0);
% T2(1,2) = 1;
% T2(2,1) = 1;
G2 = graph(T2);
D2 = distances(G2)
 
% input data as the targeted demand matrix:
D_t = [0    5.2785    5.9572   14.7922    4.6787   10.7060
    5.9058         0   10.4854   19.9595    9.7577   15.0318
    5.1270   10.9575         0    9.6557    9.7431   15.2769
   14.9134   19.9649    9.1419         0   18.3922   24.0462
    4.6324    9.1576    9.4218   18.8491         0   14.0971
   10.0975   15.9706   15.9157   24.9340   14.1712         0]
 
Dnew = D2+D
targetdistance  = 0.5*sum(sum(abs(Dnew - D_t)))
 
 
A2 = ISPP_DOR2(Dnew)
G2 = graph(A2);
subplot(2,2,3)
plot(G2,'EdgeLabel',G2.Edges.Weight,'NodeColor',[0.8500 0.3250 0.0980], ...
'EdgeAlpha',0.5,'LineWidth',1,'MarkerSize',7,'EdgeLabelColor',[0 0.4470 0.7410],'NodeFontSize',10);
 
 
function A = ISPP_tree(Omega)
m = size(Omega,1);
u = ones(m,1);
p = 1/(u.'*inv(Omega)*u)*inv(Omega)*u;
Q_tilde = 2*(u.'*inv(Omega)*u)*p*p.'-2*inv(Omega);
A = diag(diag(Q_tilde)) - Q_tilde;
A = round(A, 10);
end
 
 
function A_new = ISPP_DOR2(D)
%  ISPP_DOR, decend order recovery
%  Input: D: N X N demand matrix;
%  Output A_new: weigthed adjacency matrix of the obtained graph
    N = size(D,1);
    if ~isequal(D,D')
        error('The demand matrix should be symmetric')
    end
    if nnz(D)<N^2-N
        G = graph(D,'lower');
        D = distances(G);
    end
    A_new = D;
    S_med = D;
    for i=1:N
        for j =i+1:N
            if A_new(i,j)~=0
                for k = 1:N
                    if  k~=i && k~=j && A_new(i,j) >= S_med(i,k)+S_med(k,j) - 1e-6
                        A_new(i,j) =0;
                        A_new(j,i)=0;
                        break
                    end
                end
            end
        end
    end  
end