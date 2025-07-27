num_a =10
num_b = 10
num_c = 10
options_a = [0.1, 0.5, 1, 2];
demands_a = options_a(randi(length(options_a), num_a, 1));

% 类 b: 从 [5, 10, 20] ms 中随机选
options_b = [5, 10, 20];
demands_b = options_b(randi(length(options_b), num_b, 1));

% 类 c: 从 [50, 100, 500, 1000] ms 中随机选
options_c = [50, 100, 500, 1000];
demands_c = options_c(randi(length(options_c), num_c, 1));