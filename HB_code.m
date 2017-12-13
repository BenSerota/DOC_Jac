% finding Heart Beat boom boom
clear
data_paths = {'E:\DOC\Data from Jaco\VS';'E:\DOC\Data from Jaco\MCS';'E:\DOC\Data from Jaco\EMCS';'E:\DOC\Data from Jaco\CTRL'};
conds = {'VS';'MCS';'EMCS';'CTRL'};
subdata = {'LSGS';'LSGD';'LDGS';'LDGD'};
info = what;
subjects = length(info.mat);
hb_thresh = 0.1;                                                            % threshold ratio of heart rate detected
elec_thresh = 0.5;                                                         % threshold of odds that electrode has heart beat
countr_s = 0;
countr_subcond = 0;
countr_c = 0;
countr_t = 0;
load good_channels

for i = 4 %1:length(conds)                                                     % over conditions VS/MCS/...
    cd(data_paths{i})
    for s = 1:length(info.mat)                                              % over subjects
        countr_s = countr_s + 1;
        chosen_s = s;                                                       % chooses a subject
        loaded = load(info.mat{chosen_s});                                      % loaded = 1 subject
        for ii = 1:length(subdata)                                              % over sub-conditions
            countr_subcond = countr_subcond +1;
            DATA = loaded.data.(sprintf(subdata{ii}))(1:256,:,:);
            for j = 1:size(DATA,1)                                      % over electrodes
                hbcount = 0;
                countr_c = countr_c +1;
                for jj = 1:size(DATA,3)                                         % over trials
                    trial_DATA = DATA(j,:,jj);
                    hb = hbs2fnd(trial_DATA);
                    if hb
                        hbcount = hbcount+1;
                    end
                    countr_t = countr_t +1;
                end
                hb_prct = hbcount/size(DATA,3);                             % calculates % of trials in which hb was detectedheart beats
                if hb_prct >= hb_thresh
                    hb_elec(j).(sprintf(subdata{ii})) = 1;
                else
                    hb_elec(j).(sprintf(subdata{ii})) = 0;
                end
            end
        end
        hb_gen_elec = cell2mat(reshape(struct2cell(hb_elec),length(subdata),[])');
        hb_odds(:,s) = mean(hb_gen_elec,2);                                 % calcs and saves odds for hb, over sub-conditions, per subject
    end
    hb_incond = mean(hb_odds,2);                                            % calcs hb odds across all subjects, in this condition
    hb_in_elecs = find(hb_incond>elec_thresh);                              % finds electrode numbers
    
    e = setdiff(setdiff(1:256,good_channels),hb_in_elecs);
    x = hb_in_elecs';
    es = sprintf('%d',x)
    fprintf('\n In condition %s, Heart beat detected in electrodes: %d',conds{i} , num2str(hb_in_elecs));
    fprintf('\n In condition %s, Heart beat detected in electrodes: %d',conds{i} , hb_in_elecs');
    
    fprintf('This hb code and the "good_channels" disagreed on the following channels: % ', e);
end