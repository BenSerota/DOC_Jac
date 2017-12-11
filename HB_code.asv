% finding Heart Beat boom boom 

data_paths = {'E:\DOC\Data from Jaco\VS';'E:\DOC\Data from Jaco\MCS';'E:\DOC\Data from Jaco\EMCS';'E:\DOC\Data from Jaco\CTRL'}; 
conds = {'VS';'MCS';'EMCS';'CTRL'};
subdata = {'LSGS';'LSGD';'LDGS';'LDGD'};
info = what;
subjects = length(info.mat);

%%%RIGHT NOW number of iterations is very low: 4x4 (like CONDSxSUBDATA) . change. 

for i = 1:length(conds)
    cd(data_paths{i})
    
    chosen_s = randi(subjects,1,1);
    to_load = info.mat(chosen_s);           % in a cell cuz 'load' works on cells
    loaded = cellfun(@load,to_load);
    for ii = 1:length(subdata)
        DATA = loaded.data.(subdata{ii})(1:256,:,:);
        hb{i,ii} = hbs2fnd(DATA);
    end
    clear loaded
    
end
