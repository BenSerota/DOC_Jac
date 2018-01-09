clear
clc
profile on

% myFcn(1)

DOC_basic

load good_channels
% choosing chan location file:
fileloc = 'GSN-HydroCel-257.sfp';
peeglab = fileparts(which('eeglab.m'));
fileloc = fullfile(peeglab, 'sample_locs', fileloc);

[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;                                    % Open EEGlab
pop_editoptions('option_storedisk', 1);                                     % keep only 1 data set in memory.
pop_editoptions( 'option_computeica', 0);                                   % don't compute ica_act
pop_editoptions( 'option_saveversion6', 0);                                 % allows files larger than 2GB to be written

for i = length(conds):-1:1                                                  % over conditions
    cd(data_paths{i})                                                       % changes conditions
    info = what;
    info.mat = sortn(info.mat);                                             % not necessary but wtv
    for ii = 1:length(info.mat)                                             % over subjects
        try                                                                 % trying a subject
            %% load into Workspace
            loaded = load(info.mat{ii});                                    % loads data of one sbj
            name = info.mat{ii};
            name = name(1:end-4);                                           % drops the '.mat' ending
            for j = 1:length(subconds)                                      % over sub conds (tasks)
                try                                                         % trying a subcondition
                    %% import one subcond matrix into eeglab
                    DATA = loaded.data.(sprintf(subconds{j}));             % our EEGlab data
                    EEG = pop_importdata('dataformat','array','nbchan',0,'data','DATA','srate',250,'pnts',0,'xmin',0);
                    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname',sprintf('%s',name),'gui','off');
                    EEG = eeg_checkset(EEG);
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
                    
                    %% ICA
                    EEG = pop_runica(EEG, 'extended',5,'interrupt','on');
%                     EEG = pop_runica(EEG, ); % FASTICA
                    
                    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
                    %% preparing variables to save (includes all subconds)
                    % Components = Weights * sphere * Data
                    final.(sprintf(subconds{j})).sph = EEG.icasphere;
                    final.(sprintf(subconds{j})).w = EEG.icaweights;
                    final.(sprintf(subconds{j})).data = EEG.data;
                    
                    clear EEG DATA 
                    ALLEEG = [];
                    
                catch
                    c = c + 1;
                    Fucked_up_stuff{c,1} = {sprintf('%s %s',name,subconds{j})};
                end
                
                fprintf('\n \n progress: %s %s %s \n \n', conds{i}, name, subconds{j})
                
            end
            %% saving variables                                            % saves per subject
            cd(out_paths{i})
            save(sprintf('%s_prep', name),'final')
            
        catch
            c = c + 1;
            Fucked_up_stuff{c,1} = {name};
        end
    end
    
end

p = profile('info');
profile viewer
