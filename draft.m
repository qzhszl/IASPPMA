
N = 100
results = zeros(1000,1);
u  = ones(1,N);
for i = 1:1000
    D_Q = randi(10,N);
    D_demand = randi(100,N);
    distances_deviation2 = u*abs(D_Q-D_demand)*u.'/sum(sum(D_demand));
    results(i) =distances_deviation2;
end
mean(results)