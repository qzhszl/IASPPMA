clear,clc
% folderPath = 'D:\data\ISPP_givenA\complete_random_demand\SiyuData';
% folderPath = 'D:\data\ISPP_givenA\complete_random_demand\PerturbatedDemand';
% folderPath = 'D:\data\ISPP_givenA\complete_random_demand\RandomDemand';
% folderPath = 'D:\data\ISPP_givenA\complete_random_demand\ExactdistanceDemand';
% folderPath = "C:\Users\zqiu1\OneDrive - Delft University of Technology\Desktop\temdata2";
% folderPath = 'D:\data\ISPP_givenA\complete_random_demand\SiyuData\discrete';
% folderPath = "D:\\data\\ISPP_givenA\\complete_random_demand\\SiyuData\\test"
folderPath = 'D:\data\ISPP_givenA\test';

% 获取所有包含 "_simu" 的 .txt 文件
fileList = dir(fullfile(folderPath, '*_simu*.txt'));


% 提取文件名前缀（在 "_simu" 之前的部分）
prefixes = cell(length(fileList), 1);
for i = 1:length(fileList)
    name = fileList(i).name;
    underscoreIdx = strfind(name, '_simu');
    if ~isempty(underscoreIdx)
        prefixes{i} = name(1:underscoreIdx(1)-1);
    end
end

% 找出唯一的前缀
uniquePrefixes = unique(prefixes);

% 对每个前缀进行处理
for i = 1:length(uniquePrefixes)
    prefix = uniquePrefixes{i};
    
    % 找到所有以该前缀开头并包含 _simu 的 .txt 文件
    matchedFiles = dir(fullfile(folderPath, [prefix, '_simu*.txt']));
    
    A = [];  % 初始化拼接矩阵
    
    for j = 1:length(matchedFiles)
        filePath = fullfile(folderPath, matchedFiles(j).name);
        
        % 读取文件为数值矩阵
        B = readmatrix(filePath);  % 如果分隔符非标准可加 'Delimiter'
        
        A = [A; B];  % 纵向拼接
    end
    
    % 保存结果为以前缀命名的新 txt 文件

    outputPath = fullfile(folderPath, [prefix, '.txt']);

    writematrix(A, outputPath);

    for j = 1:length(matchedFiles)
        delete(fullfile(folderPath, matchedFiles(j).name));
    end
    
    fprintf('已完成并清理前缀：%s\n', prefix);
end

disp('所有 TXT 文件处理完成！');
