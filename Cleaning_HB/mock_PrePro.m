clear
clc
profile on

% myFcn(1)

DOC_Basic2

load good_channels
% choosing chan location file:
fileloc = 'GSN-HydroCel-257.sfp';
peeglab = fileparts(which('eeglab.m'));
fileloc = fullfile(peeglab, 'sample_locs', fileloc);

[ALLEEG,EEG,CURRENTSET,ALLCOM] = eeglab;                                    % Open EEGlab
pop_editoptions('option_storedisk', 1);                                     % keep only 1 data set in memory.
pop_editoptions( 'option_computeica', 0);                                   % don't compute ica_act
pop_editoptions( 'option_saveversion6', 0);                                 % allows files larger than 2GB to be written

for i = length(conds):-1:1                                                  % over conditions
    cd(data_paths{i})                                                       % changes conditions
    info = what;
    info.mat = sortn(info.mat);                                             % not necessary but wtv
    for ii = 1 %:length(info.mat)                                             % over subjects
        
        %% load into Workspace
        name = info.mat{ii};
        loaded = load(name);                                            % loads data of one sbj
        name = strrep(name,'.mat','');                                  % drops the '.mat' ending
        for j = 1:length(subconds)                                      % over sub conds (tasks)
            
            %% import one subcond matrix into eeglab
            DATA = loaded.data.(subconds{j});             % our EEGlab data
            EEG = pop_importdata('dataformat','array','nbchan',0,'data','DATA','srate',250,'pnts',0,'xmin',0);
            [ALLEEG,EEG,CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname',sprintf('%s',name),'gui','off');
            EEG = eeg_checkset(EEG);
            EEG.chanlocs = readlocs(fileloc);
            
            %% reference to #257
            EEG = pop_reref( EEG, 257);
            [ALLEEG,EEG,CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off');
            
            %% throw away non-scalp channels
            EEG = pop_select( EEG, 'channel',good_channels );
            [ALLEEG,EEG,CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off');
            
            %% stat reject channels: kurtosis + probability (both @ 4STD)
            original_chans = EEG.chanlocs;                          % saves 206-chan structure
            EEG = pop_rejchan(EEG, 'elec',1:EEG.nbchan ,'threshold',4,'norm','on','measure','kurt');
            EEG = pop_rejchan(EEG, 'elec',1:EEG.nbchan ,'threshold',4,'norm','on','measure','prob');
            
            %% interpolate lost channels
            chans_pre_intrp = EEG.chanlocs;
            EEG = pop_interp(EEG,original_chans,'spherical');
            
            %% stat reject epochs (over ? STD)
            old_epochs = size(EEG.data,3);
            EEG = pop_autorej(EEG, 'nogui','on','eegplot','off');
            [ALLEEG,EEG,CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off');
            new_epochs = size(EEG.data,3);
            %% recognize rejects
            % electrodes
            rej = arrayfun(@(x) x.labels, chans_pre_intrp,...
                'UniformOutput', false);
            rej = rej';
            rej = str2double(cellfun(@(x) x(2:end), rej, 'un', 0));
            rej = setdiff(good_channels,rej);                       % notice that order in setdiff is important
            
            % epochs
            epochs_lost = old_epochs - new_epochs;
            %% reshaping data into continuous (cat trials)
            EEG.data = reshape(EEG.data,EEG.nbchan,[]);
            EEG.pnts = size(EEG.data,2);
            EEG.trials = 1;
            EEG.epoch = 1;
            
            %% preparing variables to save (includes all subconds)
            % Components = Weights * sphere * Data
            final.(subconds{j}).data = EEG.data;
            final.(subconds{j}).ChansPreIntrp = chans_pre_intrp;
            final.(subconds{j}).rejChans = rej;
            final.(subconds{j}).rejChansPrcnt = length(rej)*100/length(chans_pre_intrp);
            final.(subconds{j}).rejEpochs = epochs_lost;
            final.(subconds{j}).rejEpochsPrcnt = epochs_lost*100/old_epochs;
            
            clear EEG DATA
            ALLEEG = [];
            
        end
        
        fprintf('\n \n progress: %s %s %s \n \n', conds{i}, name, subconds{j})
        
    end
    %% saving variables                                            % saves per subject
    cd(out_paths{i})
    save(sprintf('%s_prep', name),'final')
    
end



p = profile('info');
profile viewer
