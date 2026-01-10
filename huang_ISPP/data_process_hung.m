% 目标文件夹路径
% folderPath = 'D:\data\ISPP_givenA\complete_random_demand\PerturbatedDemand\';
% folderPath = 'D:\data\ISPP_givenA\complete_random_demand\RandomDemand\';
folderPath = 'D:\data\ISPP_givenA\complete_random_demand\SiyuData\discrete\';


% 步骤 1: 使用 dir 接受的通配符 (*) 获取一个粗略的文件列表
% 匹配所有包含 '_simu' 和 '_hungsupp' 的文件
roughPattern = fullfile(folderPath, '*_simu*_hungsupp*');
fileList = dir(roughPattern);

if isempty(fileList)
    disp(['在文件夹: ', folderPath, ' 中没有找到匹配文件（*\_simu\*\_hungsupp\*）。']);
    return;
end

% 步骤 2: 使用正则表达式对列表进行精确筛选
% 正则表达式模式，确保 '_simu' 后面跟着数字 (\d+)
regexPattern = '_simu\d+_hungsupp';

% 获取文件名列表 (cell array)
fileNames = {fileList.name};

% 匹配并保留符合正则表达式的文件的索引
% 'once' 确保每个文件名只匹配一次
matchIndex = ~cellfun('isempty', regexp(fileNames, regexPattern, 'once'));

% 筛选出最终要处理的文件列表
finalFileList = fileList(matchIndex);

if isempty(finalFileList)
    disp('粗略筛选后的文件列表中，没有文件符合 _simu[N]_hungsupp 的精确格式。');
    return;
end

disp(['找到 ', num2str(length(finalFileList)), ' 个匹配文件，开始重命名...']);

% 定义重命名的正则表达式模式 (用于 regexprep)
% 捕获组 () 用来“记住”匹配到的内容
pattern_rename = '(_simu\d+)(_hungsupp)'; 
replacement = '$2$1'; % 交换顺序

% 遍历最终的文件列表并执行重命名
for i = 1:length(finalFileList)
    originalName = finalFileList(i).name;
    oldPath = fullfile(folderPath, originalName);
    
    % 执行正则表达式替换操作
    newName = regexprep(originalName, pattern_rename, replacement);
    
    newPath = fullfile(folderPath, newName);
    
    % 执行重命名
    [status, message, messageId] = movefile(oldPath, newPath);
    
    if status == 1
        disp(['成功重命名: ', originalName, ' -> ', newName]);
    else
        warning(['重命名失败: ', originalName, '. 错误信息: ', message]);
    end
end

disp('重命名操作完成。');