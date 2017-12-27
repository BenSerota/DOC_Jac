function [hb_in_elecs , counter] = HB_code(PRINT)
% finding Heart Beat boom boom
data_paths = {'E:\DOC\Data from Jaco\CTRL';...
    'E:\DOC\Data from Jaco\EMCS';...
    'E:\DOC\Data from Jaco\MCS';...
    'E:\DOC\Data from Jaco\VS'};
conds = {'CTRL';'EMCS';'MCS';'VS'};
subconds = {'LDGD';'LDGS';'LSGD';'LSGS'};
nchan = 256;
% subjects = length(info.mat);
thresh_in_elec = 0.1;                                                      % threshold ratio of heart rate detected
thresh_across_sbj = 0.25;                                                  % threshold of odds that electrode has heart beat
e = 0; sc = e; s = sc; c = s; t = c;
counter = update_counter(c,s,sc,e,t); 
load good_channels
not_good = setdiff(1:nchan,good_channels);

%~~~~~~~~~~~~~~~~~

for c = 1:length(conds)                                                    % over conditions VS/MCS/...
    cd(data_paths{c})
    info = what;
    counter = update_counter(c,s,sc,e,t); 
    hb_odds = nan(nchan,length(info.mat));                                  % preallocating, every condition anew
    for s = 1:length(info.mat)                                              % over subjects
        counter = update_counter(c,s,sc,e,t); 
        sbj_name = info.mat{s};
        loaded = load(sbj_name);                                            % loaded = 1 subject
        hb_elec = preallocate_hb_elec(subconds, nchan);
        
        for sc = 1:length(subconds)                                         % over sub-conditions
            counter = update_counter(c,s,sc,e,t); 
            DATA = loaded.data.(sprintf(subconds{sc}))(1:nchan,:,:);        % change HERE for GOOD CHANNELS only
            
            for e = 1:size(DATA,1)                                          % over electrodes
                counter = update_counter(c,s,sc,e,t); 
                hbcount = 0;
                for t = 1:size(DATA,3)                                     % over trials
                    counter = update_counter(c,s,sc,e,t); 
                    trial_DATA = DATA(e,:,t);
                    hb = hbs2fnd(trial_DATA);
                    if hb
                        hbcount = hbcount+1;
                    end
                end
                hb_prct = hbcount/size(DATA,3);                             % calculates % of trials in which hb was detected
                if hb_prct >= thresh_in_elec
                    hb_elec(e).(sprintf(subconds{sc})) = 1;
                else
                    hb_elec(e).(sprintf(subconds{sc})) = 0;
                end
            end
        end
        hb_gen_elec = cell2mat(reshape(struct2cell(hb_elec),length(subconds),[])');
        hb_odds(:,s) = mean(hb_gen_elec,2);                                 % averaging over sub-cond, calcs and saves odds for hb, per subject
    end
    
    hb_incond = mean(hb_odds,2);                                            % calcs hb odds across all subjects, in this condition
    hb_in_elecs.(sprintf('%s',conds{c})).HB = ...
        find(hb_incond>thresh_across_sbj);                                  % finds electrode numbers
    matched_not_good = setdiff(hb_in_elecs.(sprintf('%s',conds{c})).HB,not_good);
    hb_in_elecs.(sprintf('%s',conds{c})).matched_bad_chan_list = matched_not_good;  

    if PRINT == 1
    fprintf('\n thresholding at %g%% of trials per electrode and at %g%% of subjects',thresh_in_elec*100, thresh_across_sbj*100)
    fprintf('\n In condition %s, Heart beat was detected in %g electrodes:',conds{c}, length(hb_in_elecs.(sprintf('%s',conds{c}))));
    fprintf('\n%g',hb_in_elecs.(sprintf('%s',conds{c})));
    fprintf('\n This HB code matched %g electrodes in "good_channels", which are the following: ', length(matched_not_good));
    fprintf('\n %g',matched_not_good);
    end
end

hb_in_elecs.intersection = ...
    mintersect(...                                                          % mintersect finds intersection of m vectors
    hb_in_elecs.(sprintf('%s',conds{1})).HB,...
    hb_in_elecs.(sprintf('%s',conds{2})).HB,...
    hb_in_elecs.(sprintf('%s',conds{3})).HB,...
    hb_in_elecs.(sprintf('%s',conds{4})).HB ) ;
    

fprintf('\n FOR SUMMARY, see output structure \n');
