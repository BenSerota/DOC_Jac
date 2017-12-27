clear
clc
% start_ben

data_paths = {'E:\DOC\Data from Jaco\VS';'E:\DOC\Data from Jaco\MCS';...
    'E:\DOC\Data from Jaco\EMCS';'E:\DOC\Data from Jaco\CTRL'};
mac_data_paths = {'/Users/admin/Desktop/DACOBO_h/VS';'/Users/admin/Desktop/DACOBO_h/EMCS';...
    '/Users/admin/Desktop/DACOBO_h/MCS';'/Users/admin/Desktop/DACOBO_h/CTRL'};
out_paths = {'E:\DOC\Data_Jaco_prep\VS';'E:\DOC\Data_Jaco_prep\MCS';...
    'E:\DOC\Data_Jaco_prep\EMCS';'E:\DOC\Data_Jaco_prep\CTRL'};
conds = {'VS';'MCS';'EMCS';'CTRL'};
subconds = {'LSGS';'LSGD';'LDGS';'LDGD'};

for i = length(conds):-1:1                                                  % over conditions
    cd(data_paths{i})                                                       % changes conditions
    info = what;
    names = info.mat;
    cd(out_paths{i})
    save(sprintf('%s_names',conds{i}),'names')
end
