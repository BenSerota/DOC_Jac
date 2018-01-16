
% This code checks how much data we have and have lost

clear
clc
start_ben
profile on

DOC_basic

for i = length(conds):-1:1                                                  % over conditions
    cd(out_paths{i})                                                        % changes conditions. out_paths becaus out of original script is now this in-path
    load(sprintf('%s_names',conds{i}));                                     % loads name list
    names = sortn(names);                                                   % for fun
    names = strrep(names,'.mat','');                                        % drops '.mat' ending
    
    for ii = 1:length(names)                                                 % over subjects
        name = sprintf('%s_prep',names{ii});
        %% load each set of ICs per subj per task
        load(name);                                                         % load subject
        
        for j = 1:length(subconds)                                          % treating each subcondition seperately
            c = c + 1;
            HIST_chan_ALL(c) = final.(subconds{j}).rejChansPrcnt;
            HIST_chan_TASK.(subconds{j})(c) = final.(subconds{j}).rejChansPrcnt;
            HIST_epoch_ALL = final.(subconds{j}).rejEpochs;
            HIST_epoch_TASK = final.(subconds{j}).rejEpochs;
        end
    end
    % decide if i want to reproduce this per COND, or generae 1 structure
    % for ALL:
    % HIST.chan.COND.SUBCOND.
    % HIST.epoch.COND.SUBCOND.
end
        %% adding additional info
% save