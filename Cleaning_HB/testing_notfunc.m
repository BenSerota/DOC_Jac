clear
clc
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
load good_channels
% choosing chan location file:
fileloc = 'GSN-HydroCel-257.sfp';
peeglab = fileparts(which('eeglab.m'));
fileloc = fullfile(peeglab, 'sample_locs', fileloc);

[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
pop_editoptions('option_storedisk', 1);                                    % keep only 1 data set in memory.

for i = length(conds):-1:1                                                  % over conditions
    cd(data_paths{i})                                                       % changes conditions
    info = what;
    for ii = 1:length(info.mat)                                             % over subjects
        %% load into Workspace
        loaded = load(info.mat{ii});                                        % loads data of one sbj 
        name = sprintf('subj_%s',info.mat{ii});
        name = name(1:end-4);                                               % drops the '.mat' ending
        for j = 1:length(subconds)                                          % over sub conds (tasks)
            %% import one subcond matrix into eeglab 
            DATA = loaded.data.(sprintf(subconds{j}));                      % this IS used, just appears in a string, in the eeglab command below
            EEG = pop_importdata('dataformat','array','nbchan',0,'data','DATA','srate',250,'pnts',0,'xmin',0);
            [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname',sprintf('%s',name),'gui','off');
            EEG.chanlocs = readlocs(fileloc);
            %% reference to #257
            EEG = pop_reref( EEG, 257);
            [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off');
            %% throw away non-scalp channels
            EEG = pop_select( EEG, 'channel',[good_channels] );
            [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off');
            %% stat reject channels: kurtosis + probability (both @ 4STD)
            EEG = pop_rejchan(EEG, 'elec',[1:EEG.nbchan] ,'threshold',4,'norm','on','measure','kurt');
            EEG = pop_rejchan(EEG, 'elec',[1:EEG.nbchan] ,'threshold',4,'norm','on','measure','prob');
            %% interpolate lost channels
            EEG = pop_interp(EEG,EEG.chanlocs,'spherical');
            
            %% stat reject epochs (over ? STD)
            EEG = pop_autorej(EEG, 'nogui','on','eegplot','off');
            [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off');
            
            %% reshaping data into continuous (cat trials)
            EEG.data = reshape(EEG.data,EEG.nbchan,[]);
            EEG.pnts = size(EEG.data,2);
            EEG.trials = 1;
            EEG.epoch = 1;
            EEG = eeg_checkset(EEG);
            
            %% ICA
            EEG = pop_runica(EEG, 'extended',1,'interrupt','off');
            [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
            %% preparing variables to save (includes all subconds)
            % Components = Weights * sphere * Data
            ICA_spheres.(sprintf(subconds{j})) = EEG.icasphere;
            ICA_weights.(sprintf(subconds{j})) = EEG.icaweights;            
            DATA_cont.(sprintf(subconds{j})) = EEG.data;
            
        end
        %% saving variables
        cd(out_paths{i})
        save(sprintf('icaW_%s', name),'ICA_weights')
        save(sprintf('icaSph_%s', name),'ICA_spheres')
        save(sprintf('prepro_%s', name),'DATA_cont')
        
    end
    
end

p = profile('info');
profile viewer
