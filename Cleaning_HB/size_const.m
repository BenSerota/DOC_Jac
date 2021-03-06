% testing for consistent size
% This code was made to check consistency of data set sizes (spec: having 256 chennels )

clear
subdata = {'LSGS';'LSGD';'LDGS';'LDGD'};
data_paths = {'E:\DOC\Data from Jaco\VS';'E:\DOC\Data from Jaco\MCS';'E:\DOC\Data from Jaco\EMCS';'E:\DOC\Data from Jaco\CTRL'}; 
conds = {'VS';'MCS';'EMCS';'CTRL'};
for i = 4
    cd(data_paths{i})
    info = what;
    info.mat = sortn(info.mat);
    for ii = 1:length(info.mat)
        to_load = info.mat(ii);           % in a cell cuz 'load' works on cells
        loaded = cellfun(@load,to_load);
        for j = 1:length(subdata)
            if size(loaded.data.(subdata{j}),1) ~= 257
                fprintf('\n condition %s , subject %g subdata %s', conds{i}, ii, subdata{j});
            end
        end
        clear loaded
    end
end