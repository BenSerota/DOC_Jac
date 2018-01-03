
%looking for heart beat
clear
clc
start_ben
% profile on

% data is ICA outputs
DOC_basic

for i = length(conds):-1:3       % ONLY TWO                                           % over conditions
    cd(out_paths{i})                                                        % changes conditions. out_paths becaus out of original script is now this in-path
    load(sprintf('%s_names',conds{i}));                                     % loads name list
    names = sortn(names);                                                   % for fun
    for q = 1:length(names)                                                 % drops '.mat' ending
        names{q,1} = names{q,1}(1,1:end-4);
    end
    %     info = what;
    for ii = 1:length(names)                                                 % over subjects
        name = sprintf('%s_prep',names{ii});
        
        %% load each set of ICs per subj per task
        load(name);                                                         % load subject
        
        for j = length(subconds):-1:1                                       % treating each subcondition seperately
            DATA = final.(sprintf(subconds{j}));
            
            % ICs = W * Sph * Raw:
            ICs = DATA.w * DATA.sph * DATA.data;
            
            for jj = 1:size(ICs,1)                                          % per component
                hb.(sprintf(subconds{j}))(jj) = hbs2fnd(ICs(jj,:));         % returns 0/1
            end
            Comps2Reject.(sprintf(subconds{j})).channels = ...              % identifies channels
                find(hb.(sprintf(subconds{j})))';
            
            lengths(j) = length(Comps2Reject.(subconds{j}).channels);                % storing for use later
            chans{j} = Comps2Reject.(sprintf(subconds{j})).channels;        % storing for use later
            first = ismember...                                             % flags if first component is HB
                (1,Comps2Reject.(sprintf(subconds{j})).channels);
            if first
                Comps2Reject.(sprintf(subconds{j})).first = 'TRUE';
            else
                Comps2Reject.(sprintf(subconds{j})).first = 'FALSE';
            end
        end
        
        %% adding additional info
        
        Comps2Reject.ave_amount = round(mean(lengths));
        Comps2Reject.ave_precent = Comps2Reject.ave_amount*100/jj;
        Comps2Reject.joint = mintersect(chans{1},chans{2},chans{3},chans{4});
        
        save(sprintf('%s_HBICs',name(1:end-5)),'Comps2Reject')                                  % saves list of ICs to reject in prep folder
        
    end
    
end