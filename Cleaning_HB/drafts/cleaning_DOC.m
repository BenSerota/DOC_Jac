function [DATA_cont, ICA_weights] = cleaning_DOC (COND, subconds, out_paths)
%cleaning DOC jaco data

load good_channels
switch COND
    case 'CTRL'
        cond = 4;
    case 'EMCS'
        cond = 3;
    case 'MCS'
        cond = 2;
    otherwise
        cond = 1;
end

[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
pop_editoptions( 'option_storedisk', 1);                                    % keep only 1 data set in memory.

info = what;
for ii = 1:length(info.mat)                                             % over subjects
    loaded = load(info.mat{ii});
    name = sprintf('subj_%s',info.mat{ii});
    name = name(1:end-4);                                               % drops the '.mat' ending
    for j = 1:length(subconds)                                          % over sub conds (tasks)
        %% load
        %FOR SOME RESON THIS IMPORT DOESN'T WORK SUDDENLY :( :(
        DATA = loaded.data.(sprintf(subconds{j}));                      % this IS used, just appears in a string, in the eeglab command below
        EEG = pop_importdata('dataformat','array','nbchan',0,'data','DATA','srate',250,'pnts',0,'xmin',0);
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname',sprintf('%s',name),'gui','off');
        EEG = eeg_checkset( EEG );
        %% reference to #257
        EEG = pop_reref( EEG, 257);
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off');
        EEG = eeg_checkset( EEG );
        %% throw away non-scalp channels
        EEG = pop_select( EEG, 'channel',[good_channels] );
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off');
        %% stat reject channels: kurtosis + probability (both @ 4STD)
        EEG = pop_rejchan(EEG, 'elec',[1:EEG.nbchan] ,'threshold',4,'norm','on','measure','kurt');
        EEG = eeg_checkset( EEG );
        EEG = pop_rejchan(EEG, 'elec',[1:EEG.nbchan] ,'threshold',4,'norm','on','measure','prob');
        EEG = eeg_checkset( EEG );
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
        test = (EEG.icaweights^-1) * EEG.data * EEG.icaweights;
        %% preparing variables to save (includes all subconds)
        DATA_cont{ii}(:,:,j) = EEG.data;
        ICA_weights{ii}(:,:,j) = EEG.icaweights;
        eeglab redraw
        
    end
    %% saving variables
    cd(out_paths{cond})
    save(sprintf('prep_%s', name),'DATA_cont')
    save(sprintf('icaw_%s', name),'ICA_weights')
    
end


p = profile('info');
profile viewer
