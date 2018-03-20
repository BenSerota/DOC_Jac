
% This code checks how much data we have and have lost

clear
clc
profile off
start_ben
profile on
DOC_basic
cc = 0;

for i = length(conds):-1:1                                                  % over conditions
    cd(out_paths{i})                                                        % changes conditions. out_paths becaus out of original script is now this in-path
    load(sprintf('%s_names',conds{i}));                                     % loads name list
    names = sortn(names);                                                   % for fun
    names = strrep(names,'.mat','');                                        % drops '.mat' ending
    ccc = 0;                                                                % counter for per-condition
    for ii = 1:length(names)                                                 % over subjects
        name_p = sprintf('%s_prep',names{ii});
        name_h = sprintf('%s_HBICs', names{ii});
        %% load each set of ICs per subj per task
        cd(out_paths{i})
        load(name_p);                                                         % load subject PREP
        load(name_h);
        
        for j = 1:length(subconds)                                          % treating each subcondition seperately
            cc = cc + 1;
            ccc = ccc +1;
            
            % ch = channels rejected , pr = percent, ab = absolute amount,
            % ep = epochs rejected, ep_or = original epochs amount
            ch_ab = size(final.(subconds{j}).rejChans,2);                   % absolute values not used right now
            ch_pr = final.(subconds{j}).rejChansPrcnt;
            ep_ab = final.(subconds{j}).rejEpochs;
            ep_pr = final.(subconds{j}).rejEpochsPrcnt;
            if ep_ab ~= 0                                                   % because of 0
                ep_or = round(ep_ab*100/ep_pr ,3);
            else
                cd(data_paths{i})
                load (names{ii})
                ep_or = size(data.(subconds{j}),3);
                clear data
            end
            % sanity check
            if 206 - ch_ab ~= size(final.(subconds{j}).ChansPreIntrp,2)
                Fucked_up_stuff{c,1} = {sprintf('%s %s',names{ii},subconds{j})};
                c = c+1;
            else
                
                % absolute
                    % GEN
                STATS.GEN.ab.ch(cc,1) = ch_ab;
                STATS.GEN.ab.ep(cc,1) = ep_ab;
                
                    % per COND (duplicating existing info)
                STATS.(conds{i}).ab.ch(ccc,1) = ch_ab;
                STATS.(conds{i}).ab.ep(ccc,1) = ep_ab;
                
                % percentages
                    % GEN
                STATS.GEN.pr.ch(cc,1) = ch_pr;
                STATS.GEN.pr.ep(cc,1) = ep_pr;
                
                    % per COND (duplicating existing info)
                STATS.(conds{i}).pr.ch(ccc,1) = ch_pr;
                STATS.(conds{i}).pr.ep(ccc,1) = ep_pr;
                
                    % TOT
                temp = ((206 - ch_ab) * (ep_or - ep_ab)) / (206 * ep_or);
                STATS.GEN.pr.TOT(cc,1) = 100 * (1 - round(temp,2));
                STATS.(conds{i}).pr.TOT(ccc,1) = STATS.GEN.pr.TOT(cc,1);
                
            end
        end
    end
    %% adding info: mean and std
    % ab
    STATS.(conds{i}).ab.ch_ave = mean(STATS.(conds{i}).ab.ch);
    STATS.(conds{i}).ab.ch_std = std(STATS.(conds{i}).ab.ch);
    STATS.(conds{i}).ab.ep_ave = mean(STATS.(conds{i}).ab.ep);
    STATS.(conds{i}).ab.ep_std = std(STATS.(conds{i}).ab.ep);
    
    %pr
    STATS.(conds{i}).pr.ch_ave = mean(STATS.(conds{i}).pr.ch);
    STATS.(conds{i}).pr.ch_std = std(STATS.(conds{i}).pr.ch);
    STATS.(conds{i}).pr.ep_ave = mean(STATS.(conds{i}).pr.ep);
    STATS.(conds{i}).pr.ep_std = std(STATS.(conds{i}).pr.ep);
    
    % TOT
    STATS.(conds{i}).pr.TOT_ave = mean(STATS.(conds{i}).pr.TOT);
    STATS.(conds{i}).pr.TOT_std = std(STATS.(conds{i}).pr.TOT);
    
end

%% adding info: means and stds
%ab
STATS.GEN.ab.ch_ave = mean(STATS.GEN.ab.ch);
STATS.GEN.ab.ch_std = std(STATS.GEN.ab.ch);
STATS.GEN.ab.ep_ave = mean(STATS.GEN.ab.ep);
STATS.GEN.ab.ep_std = std(STATS.GEN.ab.ep);

%pr
STATS.GEN.pr.ch_ave = mean(STATS.GEN.pr.ch);
STATS.GEN.pr.ch_std = std(STATS.GEN.pr.ch);
STATS.GEN.pr.ep_ave = mean(STATS.GEN.pr.ep);
STATS.GEN.pr.ep_std = std(STATS.GEN.pr.ep);

% TOT
STATS.GEN.pr.TOT_ave = mean(STATS.GEN.pr.TOT);
STATS.GEN.pr.TOT_std = std(STATS.GEN.pr.TOT);

%% saving. adding additional info
if cc ~= 183*4 % 183 is number of subj i think, 4 = num of tasks
    C = 'some data sets were not analyzed properly';
else
    C = ['number of subjects analyzed: ' num2str(cc/4) ];
end
cd('E:\DOC\Data_Jaco_prep')
save ('Loss_Report', 'STATS', 'Fucked_up_stuff', 'C')

%% plotting
% violin plots (=distributionPlot)
colors = {'g';'r';'m';'b'};

%% percentages 
cd('E:\Dropbox\Ben Serota\momentary\Figs')
% first: TOT
for i = 1:4
    d{i} = STATS.(conds{i}).pr.TOT;
end
f1 = figure();
title('Percentages of data lost (channels+epochs)')
distributionPlot (d,'xNames',conds,'showMM',4,'histOpt',1,'globalNorm',0,...
    'color',colors) % norm,1, hist,0 , 'variableWidth','false'
ylabel('Percent of data rejected')
savefig(f1,'DataLoss_TOT')

% second: chans
for i = 1:4
    d_chan{i} = STATS.(conds{i}).pr.ch;
end
f2 = figure();
title('Percentages CHANNELS rejected')
distributionPlot (d_chan,'xNames',conds,'showMM',4,'histOpt',1,'globalNorm',0,...
    'color',colors) % norm,1, hist,0 , 'variableWidth','false'
ylabel('Percent of data rejected')
savefig(f2,'DataLoss_n_chan')

% third: epochs
for i = 1:4
    d_epoch{i} = STATS.(conds{i}).pr.ep;
end
f3 = figure();
title('Percentages of EPOCH rejected')
distributionPlot (d_epoch,'xNames',conds,'showMM',4,'histOpt',1,'globalNorm',0,...
    'color',colors) % norm,1, hist,0 , 'variableWidth','false'
ylabel('Percent of data rejected')
savefig(f3,'DataLoss_n_epoch')

%% absolute values
clear d d_chan d_epoch

% first: chans
for i = 1:4
    d_chan{i} = STATS.(conds{i}).ab.ch;
end
f4 = figure();
title('Number of CHANNELS rejected')
distributionPlot (d_chan,'xNames',conds,'showMM',4,'histOpt',1,'globalNorm',0,...
    'color',colors) % norm,1, hist,0 , 'variableWidth','false'
ylabel('Percent of data rejected')
savefig(f4,'DataLoss_p_chan')

% second: epochs
for i = 1:4
    d_epoch{i} = STATS.(conds{i}).ab.ep;
end
f5 = figure();
title('Number of EPOCH rejected')
distributionPlot (d_epoch,'xNames',conds,'showMM',4,'histOpt',1,'globalNorm',0,...
    'color',colors) % norm,1, hist,0 , 'variableWidth','false'
ylabel('Percent of data rejected')
savefig(f5,'DataLoss_p_epoch')

tilefigs


%%
profile viewer