% Program name: ISPPMAE: Inverse all shortest path problem with the minimum
% adjustment of the sum of the link weights
% Author: Zhihao Qiu
% Date created: 2023-07-03
% Date modified: 2023-07-03
clear,clc


% n = 20;
% p = log(n)/n+0.1
% % p=0.1
% % rand('seed',100); % reseed so you get a similar picture
% A = rand(n,n) < p;
% A = triu(A,1);



% linkweight_matrix = rand(n,n)
% A = A.*linkweight_matrix
% 
A = [0 3 0 0 0;
    0 0 6 2 3
    0 0 0 4 5
    0 0 0 0 2
    0 0 0 0 0];

% A=[0	0	0	0	1	0	1	1	1	0
% 0	0	0	0	1	0	0	0	0	0
% 0	0	0	0	0	0	0	0	1	0
% 0	0	0	0	0	0	0	1	0	0
% 1	1	0	0	0	1	1	1	1	0
% 0	0	0	0	1	0	0	1	0	0
% 1	0	0	0	1	0	0	0	0	1
% 1	0	0	1	1	1	0	0	1	1
% 1	0	1	0	1	0	0	1	0	1
% 0	0	0	0	0	0	1	1	1	0];

% A = rand(20,20).*triu(A,1)
% % 
% % 
A = A + A';
N = size(A,1);
% g_A = graph(A);


% N = 10
% A = generate_ERgraph(N); 
g_A = graph(A);

% figure;
% subplot(2,2,1)
% plot(g_A,'EdgeLabel',g_A.Edges.Weight,'NodeColor',[0.8500 0.3250 0.0980], ...
%     'EdgeAlpha',0.5,'LineWidth',1,'MarkerSize',7,'EdgeLabelColor',[0 0.4470 0.7410],'NodeFontSize',10);


D0= distances(g_A)

for perturbation = 0:0.05:1
    D=D0+perturbation*ones(N,N)-perturbation*diag(ones(N,1));
    check_triangle_relationship(D,N)
    G_D = graph(D,'lower');
    subplot(2,2,2)
    % plot(G_D,'EdgeLabel',G_D.Edges.Weight,'NodeColor',[0.8500 0.3250 0.0980], ...
    %     'EdgeAlpha',0.5,'LineWidth',1,'MarkerSize',7,'EdgeLabelColor',[0 0.4470 0.7410],'NodeFontSize',10);
    
    A1 = ISPP_LR(D);
    
    z=0;
    if length(find(A1==0))~=N
        disp('DOR has removed links')
    end

end

D =  [0     4     9     5     8
     4     0     6     2     3
     9     6     0     2     5
     5     2     2     0     2
     8     3     5     2     0]
A1 = ISPP_LR(D)

% G1 = graph(A1,'lower');
% subplot(2,2,3)
% plot(G1,'EdgeLabel',G1.Edges.Weight,'NodeColor',[0.8500 0.3250 0.0980], ...
%     'EdgeAlpha',0.5,'LineWidth',1,'MarkerSize',7,'EdgeLabelColor',[0 0.4470 0.7410],'NodeFontSize',10);

% for i = 1:N
%     for j=1:N
% 
%     end
% end


% T = minspantree(G_D);
% subplot(2,2,3)
% plot(T,'EdgeLabel',T.Edges.Weight,'NodeColor',[0.8500 0.3250 0.0980], ...
%     'EdgeAlpha',0.5,'LineWidth',1,'MarkerSize',7,'EdgeLabelColor',[0 0.4470 0.7410],'NodeFontSize',10);
% A_T = full(adjacency(T,"weighted"));
% 
% % distances(T)-D
% % tril(distances(T))-tril(D)
% 
% max_dif_distance_value =  max(max(tril(distances(T))-tril(D)));
% [maxrow,maxcol] = find(tril(distances(T)-D) == max_dif_distance_value,1);
% A_new = A_T;
% while max_dif_distance_value>0.0000001
% %     distances(T)
%     A_new(maxrow,maxcol) = D(maxrow,maxcol);
%     A_new(maxcol,maxrow) = D(maxrow,maxcol);
%     G_new = graph(A_new,'lower');
%     A_new = full(adjacency(G_new,"weighted"));
% %     distances(G_new)-D
%     max_dif_distance_value =  max(max(distances(G_new)-D));
%     [maxrow,maxcol] = find((distances(G_new)-D) == max_dif_distance_value,1);
% 
%     decend_step = sum(sum(tril(abs(distances(G_new)-tril(D)))));
% end
% 
% 
% A_new = remove_triangle(A_new);
% G_new = graph(A_new);
% adjsum = sum(sum(A_new-A));
% dif_distance_sum = sum(sum(tril(abs(distances(G_new)-tril(D)))));
% dif_distance_num = nnz(distances(G_new)-D);
% Demand_linkweightsum = 0.5*sum(sum(D));
% % plot(G_new)
% subplot(2,2,4)
% plot(G_new,'EdgeLabel',G_new.Edges.Weight,'NodeColor',[0.8500 0.3250 0.0980], ...
%     'EdgeAlpha',0.5,'LineWidth',1,'MarkerSize',7,'EdgeLabelColor',[0 0.4470 0.7410],'NodeFontSize',10);
% 
% % TR = shortestpathtree(g_graphcomplete,1);
% % % p = plot(G)
% % distances(TR)



function A_OUT = remove_triangle(A)
    N = size(A,1);
% INPUT: 
%       [0,1,2
%        1,0,3
%        2,3,0];
% OUTPUT
%      0     1     2
%      1     0     0
%      2     0     0
    for i=1:N
        for j =i+1:N
            if A(i,j)~=0
                for k = 1:N
                    if  k~=i && k~=j && A(i,k)~=0 && A(k,j)&& A(i,j)==A(i,k)+A(k,j)
                        A(i,j) = 0;
                        A(j,i) = 0;
                    end
                end
            end
        end
    end
    A_OUT=A;
end


function ER_adj = generate_ERgraph(n)
    p = log(n)/n+1/n;
    % p=0.1
    % rand('seed',100); % reseed so you get a similar picture
    A = rand(n,n) < p;
    A = triu(A,1);
    linkweight_matrix = rand(n,n);
%     linkweight_matrix = randi(10,n,n);
    A = A.*linkweight_matrix;
    A = A + A';
    G_ori = graph(A);
    while max(conncomp(G_ori))>1
        A = rand(n,n) < p;
        A = triu(A,1);
%         linkweight_matrix = randi(10,n,n);
%         A = A.*linkweight_matrix;
        linkweight_matrix = rand(n,n);
        A = A.*linkweight_matrix;
        A = A + A';
        G_ori = graph(A);
    end
    ER_adj=A;
end

function check_triangle_relationship(A,N)
    for  i=1:N
        for j=1:N
            for k=1:N
                if  k~=i && k~=j && A(i,k)~=0 && A(i,j)~=0 && A(k,j)~=0 &&A(i,j)>A(i,k)+A(k,j)
                    disp('break triangle rules')
                end
            end
        end
    end
end
