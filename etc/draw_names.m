clear
clc
% start_ben

DOC_basic

for i = length(conds):-1:1                                                  % over conditions
    cd(data_paths{i})                                                       % changes conditions
    info = what;
    names = info.mat;
    cd(out_paths{i})
    save(sprintf('%s_names',conds{i}),'names')
end

