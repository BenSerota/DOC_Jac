
conds = {'VS';'MCS';'EMCS';'CTR'};
subconds =  {'LSGS';'LSGD';'LDGS';'LDGD'}; %{'LDGD';'LSGD';'LSGS';'LDGS'}; %{'LDGD';'LDGS';'LSGD';'LSGS';};% original: {'LSGS';'LSGD';'LDGS';'LDGD'};
Fucked_up_stuff = {};
c = 0;

if ispc
    in_root = 'E:\DOC\Data from Jaco\';
    out_root = 'E:\DOC\Data_Jaco_Prep\';
    for i = length(conds):-1:1
        data_paths{i} = sprintf('%s%s',in_root,conds{i});
        out_paths{i} = sprintf('%s%s',out_root,conds{i});
    end
    
elseif ismac
    in_root = '/Users/admin/Desktop/DACOBO_h/origin/';
    out_root = '/Users/admin/Desktop/DACOBO_h/prep/';
    for i = length(conds):-1:1
        data_paths{i} = sprintf('%s%s',in_root,conds{i});
        out_paths{i} = sprintf('%s%s',out_root,conds{i});
    end
end

data_paths = data_paths';
out_paths = out_paths';
