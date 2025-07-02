function starAdj = generate_star_network(N,maxweightinput)
    if maxweightinput == 0
        weightFun = 1;
    elseif maxweightinput ==1 
        weightFun = @() rand();  % Randomly pick 1 or 10
    else
        weightFun = @() randi(maxweightinput,1);  % Uniform random from 0 to 1
    end
    starAdj = zeros(N);  % Adjacency matrix
    for i = 2:N
        w = weightFun();
        starAdj(1, i) = w;
        starAdj(i, 1) = w;
    end
end

