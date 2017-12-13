% finding Heart Beat boom boom
clear
data_paths = {'E:\DOC\Data from Jaco\CTRL';...
    'E:\DOC\Data from Jaco\EMCS';...
    'E:\DOC\Data from Jaco\MCS';...
    'E:\DOC\Data from Jaco\VS'};
conds = {'CTRL';'EMCS';'MCS';'VS'};
subconds = {'LDGD';'LDGS';'LSGD';'LSGS'};
info = what;
nchan = 256;
subjects = length(info.mat);
thresh_in_elec = 0.1;                                                      % threshold ratio of heart rate detected
thresh_across_sbj = 0.25;                                                  % threshold of odds that electrode has heart beat
COUNTER = [0 0 0 0 0];
load good_channels
not_good = setdiff(1:nchan,good_channels);

%~~~~~~~~~~~~~~~~~

for i = 1:length(conds)                                                    % over conditions VS/MCS/...
    COUNTER = COUNTER + [1 0 0 0 0];
    cd(data_paths{i})
    hb_odds = nan(nchan,length(info.mat));                                   % preallocating
    for s = 1:length(info.mat)                                             % over subjects
        COUNTER = COUNTER + [0 1 0 0 0];
        chosen_s = s;                                                      % chooses a subject
        sbj_name = info.mat{chosen_s};
        loaded = load(sbj_name);                                 % loaded = 1 subject
        
        for k = length(subconds):-1:1                             % preallocating structure
            hb_elec(nchan).(sprintf(subconds{k})) = [];
        end
        
        for ii = 1:length(subconds)                                   % over sub-conditions
            COUNTER = COUNTER + [0 0 1 0 0];
            DATA = loaded.data.(sprintf(subconds{ii}))(1:nchan,:,:);
            
            for j = 1:size(DATA,1)                                         % over electrodes
                hbcount = 0;
                COUNTER = COUNTER + [0 0 0 1 0];
                for jj = 1:size(DATA,3)                                    % over trials
                    trial_DATA = DATA(j,:,jj);
                    hb = hbs2fnd(trial_DATA);
                    if hb
                        hbcount = hbcount+1;
                    end
                    COUNTER = COUNTER + [0 0 0 0 1];
                end
                hb_prct = hbcount/size(DATA,3);                            % calculates % of trials in which hb was detectedheart beats
                if hb_prct >= thresh_in_elec
                    hb_elec(j).(sprintf(subconds{ii})) = 1;
                else
                    hb_elec(j).(sprintf(subconds{ii})) = 0;
                end
            end
        end
        hb_gen_elec = cell2mat(reshape(struct2cell(hb_elec),length(subconds),[])');
        hb_odds(:,s) = mean(hb_gen_elec,2);                                 % averaging over sub-cond, calcs and saves odds for hb, per subject
    end
    
    hb_incond = mean(hb_odds,2);                                            % calcs hb odds across all subjects, in this condition
    hb_in_elecs.(sprintf('%s',conds{i})) = find(hb_incond>thresh_across_sbj);                              % finds electrode numbers
    matched_not_good = setdiff(hb_in_elecs.(sprintf('%s',conds{i})),not_good);
    
    fprintf('\n thresholding at %g%% of trials per electrode and at %g%% of subjects',thresh_in_elec*100, thresh_across_sbj*100)
    fprintf('\n In condition %s, Heart beat was detected in %g electrodes:',conds{i}, length(hb_in_elecs.(sprintf('%s',conds{i}))));
    fprintf('\n%g',hb_in_elecs.(sprintf('%s',conds{i})));
    fprintf('\n This HB code matched %g electrodes in "good_channels", which are the following: ', length(matched_not_good));
    fprintf('\n %g',matched_not_good);
end

fprintf('\n FOR SUMMARY, see structure "hb_in_elecs" \n');
