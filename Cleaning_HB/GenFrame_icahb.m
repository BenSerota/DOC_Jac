% GenFrame_icahb

clear
start_ben
profile on

data_paths = {'E:\DOC\Data from Jaco\VS';'E:\DOC\Data from Jaco\MCS';...
    'E:\DOC\Data from Jaco\EMCS';'E:\DOC\Data from Jaco\CTRL'};
mac_data_paths = {'/Users/admin/Desktop/DACOBO_h/VS';'/Users/admin/Desktop/DACOBO_h/EMCS';...
    '/Users/admin/Desktop/DACOBO_h/MCS';'/Users/admin/Desktop/DACOBO_h/CTRL'};
out_paths = {'E:\DOC\Data_Jaco_prep\VS';'E:\DOC\Data_Jaco_prep\MCS';...
    'E:\DOC\Data_Jaco_prep\EMCS';'E:\DOC\Data_Jaco_prep\CTRL'};

conds = {'VS';'MCS';'EMCS';'CTRL'};
subconds = {'LSGS';'LSGD';'LDGS';'LDGD'};

for i = length(conds):-1:1                                                     % over conditions
    cd(data_paths{i})                                                       % changes conditions
%         cd(mac_data_paths{i})                                                    % changes conditions
    [DATA, ICA_weights] = cleaning_DOC (conds{i}, subconds, out_paths);
    ICA_comp = ICA;
    hb()

end


