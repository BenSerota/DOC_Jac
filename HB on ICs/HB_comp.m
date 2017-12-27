
%looking for heart beat
clear
clc
start_ben
profile on

% data is ICA outputs
DOC_basic

for i = length(conds):-1:1                                                  % over conditions
    cd(data_paths{i})                                                       % changes conditions
    load(sprintf('%s_names',conds{i}));                           % loads name list
    %     info = what;
    for ii = 1:length(names)                                             % over subjects
        name = sprintf('subj_%s',names{ii});
        %% load each set of ICs per subj per task
        load(sprintf('icaW_%s', name));
        load(sprintf('icaSph_%s', name));
        load(sprintf('prepro_%s', name));
        for j = length(subconds):-1:1                                       % treating each subcondition seperately
            W = ICA_weights.(sprintf(subconds{j}));
            Sph = ICA_spheres.(sprintf(subconds{j}));
            Raw = DATA_cont.(sprintf(subconds{j}));
            
            ICs = W * Sph * Raw;
            
            for jj = 1:size(ICs,1)                                          % per component
                hb.(sprintf(subconds{j}))(jj) = hbs2fnd(ICs(jj,:));
            end
            Comps2Reject.(sprintf('%s_2Reject',name(1:end-4))).(sprintf(subconds{j})) = find(hb.(sprintf(subconds{j})));
            
            rej(j) = length(Comps2Reject.(sprintf('%s_2Reject',name(1:end-4))).(sprintf(subconds{j})));
        end
        
        Comps2Reject.(sprintf('%s_2Reject',name(1:end-4))).ave_amount = mean(rej);
        Comps2Reject.(sprintf('%s_2Reject',name(1:end-4))).ave_precent = mean(rej)/jj;
        Comps2Reject.(sprintf('%s_2Reject',name(1:end-4))).joint = mintersect(Comps2Reject.(sprintf('%s_2Reject',name(1:end-4))).LDGD,Comps2Reject.(sprintf('%s_2Reject',name(1:end-4))).LDGS,Comps2Reject.(sprintf('%s_2Reject',name(1:end-4))).LSGD,Comps2Reject.(sprintf('%s_2Reject',name(1:end-4))).LSGS);
    end
    
    save('Comps2Reject',sprintf(conds{i}))                                  % saves list of ICs to reject in prep folder
    
end