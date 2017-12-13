%cleaning doc jac data
clear

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

for i = 1:3 %length(conds)                                                     % over conditions
    cd(data_paths{i})
    %     chosen_s = randi(subjects,1,1);                                   % choose a subject.
    for ii = 1:length(info.mat)
        chosen_s = ii;                                                      % this was redundant but i wanted to be consistent with the other codes
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
            EEG = pop_eegfiltnew(EEG, 12,25,414,1,[],0);
            [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off');
%             eeglab redraw
            % saving
            var = ALLEEG(end).data;
            cd(out_paths{i})
            save(sprintf('%s_filt',name), 'var')
        end
    end
    clear loaded
end

