
% This code looks for heart beat using hb2fnd in every ICA component
% in every task, in every subject.
% order:
% 1. compose the ICA activation mat
% 2. identify hb in ICs
% 3. save a profile of the subj

clear
clc
start_ben
profile on

% input data here is the output of PrePro_ICA
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
        compNum = 0;
        
        for j = length(subconds):-1:1                                       % treating each subcondition seperately
            DATA = final.(subconds{j});
            
            % ICA activation matrix  = W * Sph * Raw:
            ICAact = DATA.w * DATA.sph * DATA.data;
            hb.(subconds{j}) = zeros(1,size(ICAact,1));
            compNum = compNum + size(ICAact,1);
            
            for jj = 1:size(ICAact,1)                                          % per component
                hb.(subconds{j})(jj) = hbs2fnd(ICAact(jj,:));         % returns 0/1
            end
            
            Comps2Reject.(subconds{j}) = ...              % identifies ICs
                find(hb.(subconds{j}))';
            lengths(j) = length(Comps2Reject.(subconds{j}));            % storing for use later
            ICs{j} = Comps2Reject.(subconds{j});             % storing for use later
        end
        
        %% adding additional info
        Comps2Reject.ave_amount = mean(lengths);
        Comps2Reject.ave_precent = sum(lengths)*100/compNum;
        save(sprintf('%s_HBICs',name(1:end-5)),'Comps2Reject')                                  % saves list of ICs to reject in prep folder
        
    end
    
end

profile viewer