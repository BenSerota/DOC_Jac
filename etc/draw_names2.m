clear
clc
% start_ben

DOC_Basic2

for i = length(conds):-1:1                                                  % over conditions
    cd(out_paths{i})                                                       % changes conditions
    info = what;
    names = info.mat;
    cd(out_paths{i})
    save(sprintf('%s_names',conds{i}),'names')
end

