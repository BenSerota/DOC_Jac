
% This code looks for heart beat using hb2fnd in every ICA component
% in every task, in every subject.
% order:
% 1. compose the ICA activation mat
% 2. identify hb in ICs
% 3. save a profile of the subj

% clear
clc
start_ben
profile on

% input data here is the output of PrePro_ICA 
DOC_basic

for i = length(conds):-1:1                                                  % over conditions
    cd(out_paths{i})                                                        % changes conditions. out_paths becaus out of original script is now this in-path
    load(sprintf('%s_names',conds{i}));                                     % loads name list
    names = sortn(names);                                                   % for fun
    strrep(names,'.mat','')                                                 % drops '.mat' ending
       
    
    for ii = 1:length(names)                                                 % over subjects
        name = sprintf('%s_prep',names{ii});
        
        %% load each set of ICs per subj per task
        load(name);                                                         % load subject
        
        for j = 1:length(subconds); %:-1:1                                       % treating each subcondition seperately
            DATA = final.(sprintf(subconds{j}));
            
            % ICA activation matrix  = W * Sph * Raw:
            ICAact = DATA.w * DATA.sph * DATA.data;
            
            for jj = 1:size(ICAact,1)                                          % per component
                hb.(sprintf(subconds{j}))(jj) = hbs2fnd(ICAact(jj,:));         % returns 0/1
            end
            
            Comps2Reject.(sprintf(subconds{j})).ICs = ...              % identifies ICs
                find(hb.(sprintf(subconds{j})))';
            
            lengths(j) = length(Comps2Reject.(subconds{j}).ICs);            % storing for use later
            ICs{j} = Comps2Reject.(sprintf(subconds{j})).ICs;             % storing for use later
            first = ismember...                                             % flags if first component is HB
                (1,Comps2Reject.(sprintf(subconds{j})).ICs);
            if first
                Comps2Reject.(sprintf(subconds{j})).first = 'TRUE';
            else
                Comps2Reject.(sprintf(subconds{j})).first = 'FALSE';
            end
        end
        
        %% adding additional info
        
        Comps2Reject.ave_amount = mean(lengths);
        Comps2Reject.ave_precent = mean(lengths)*100/jj;
        Comps2Reject.joint = mintersect(ICs{1},ICs{2},ICs{3},ICs{4});
        save(sprintf('%s_HBICs4',name(1:end-5)),'Comps2Reject')                                  % saves list of ICs to reject in prep folder
        
    end
    
end
profile viewer