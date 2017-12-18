%cleaning doc jac data
clear

mac_data_paths = {'/Users/admin/Desktop/DACOBO_h/VS';'/Users/admin/Desktop/DACOBO_h/EMCS';...
    '/Users/admin/Desktop/DACOBO_h/MCS';'/Users/admin/Desktop/DACOBO_h/CTRL'};

data_paths = {'E:\DOC\Data from Jaco\VS';'E:\DOC\Data from Jaco\MCS';...
    'E:\DOC\Data from Jaco\EMCS';'E:\DOC\Data from Jaco\CTRL'};
out_paths = {'E:\DOC\Data_Jaco_filt\VS';'E:\DOC\Data_Jaco_filt\MCS';...
    'E:\DOC\Data_Jaco_filt\EMCS';'E:\DOC\Data_Jaco_filt\CTRL'};
conds = {'VS';'MCS';'EMCS';'CTRL'};
subdata = {'LSGS';'LSGD';'LDGS';'LDGD'};
info = what;
subjects = length(info.mat);

[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
pop_editoptions( 'option_storedisk', 1);                                    % keep only 1 data set in memory.

% for i = 1 %:length(conds)                                                     % over conditions
i = 1;

cd(mac_data_paths{i});
% cd(data_paths{i})
    for ii = 1:length(info.mat)                                             % over subjects 
        chosen_s = ii;                                                      % chooses a sbj. this was redundant but i wanted to be consistent with the other codes
        loaded = load(info.mat{chosen_s});
        name = sprintf('subj_%s',info.mat{chosen_s});
        name = name(1:end-4);                                               % drops the '.mat' ending
        for j = 1:length(subdata)
            DATA = loaded.data.(sprintf(subdata{j}));
            EEG = pop_importdata('dataformat','array','nbchan',0,'data','DATA','srate',250,'pnts',0,'xmin',0);
            [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname',sprintf('%s',name),'gui','off');
            EEG = eeg_checkset( EEG );
            EEG = pop_reref( EEG, 257);
            [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off');
            EEG = pop_eegfiltnew(EEG, 1.5,25,414,1,[],0); %%% NOPE. TREAT DIFFERENTLY
            [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off');
            eeglab redraw
            % saving
%             var = ALLEEG(end).data;
%             cd(out_paths{i})
%             save(sprintf('%s_filt',name), 'var')
        end
    end
    clear loaded
% end
