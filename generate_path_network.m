function lineAdj = generate_path_network(N,maxweightinput)
%GENERATE_PATH_NETWORK a path 1-2 2-3 3-4
% N network size
    if maxweightinput == 0
        weightFun = 1;
    elseif maxweightinput ==1 
        weightFun = @() rand();  % Randomly pick 1 or 10
    else
        weightFun = @() randi(maxweightinput,1);  % Uniform random from 0 to 1
    end
    lineAdj = zeros(N);
    for i = 1:N-1
        w = weightFun();
        lineAdj(i, i+1) = w;
        lineAdj(i+1, i) = w;
    end
end

