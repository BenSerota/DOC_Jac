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

for i = length(conds):-1:1                                                  % over conditions
    cd(data_paths{i})                                                       % changes conditions
    %     cd(mac_data_paths{i})                                                   % changes conditions
    
    % Clean this condition i, with these subconditions, and throw output to
    % these paths. DATA gives cleaned and preprocessed data.
    [DATA, ICA_weights] = cleaning_DOC(conds{i}, subconds, out_paths);
    % reconstructing components (to be transferred to a different script)
    ICA_comp = (ICA_weights^-1) * DATA * ICA_weights;
    hb()
    
end


