% This code is meant to remove a number of hb ICs form our data.

clear
clc
start_ben
profile on

% % r chooses how many of the first ICs to reject in each dataset:
% r = 3;
% r chooses IC position, above which hb ICs are NOT rejected:
% r = 10;

% input data here is the output of PrePro_ICA
DOC_basic

for i = length(conds):-1:1                                                  % over conditions
    cd(out_paths{i})                                                        % changes conditions. out_paths becaus out of original script is now this in-path
    load(sprintf('%s_names',conds{i}));                                     % loads name list
    names = sortn(names);                                                   % for fun
    for q = 1:length(names)                                                 % drops '.mat' ending
        names{q,1} = names{q,1}(1,1:end-4);
    end
    
    for ii = 1:length(names)                                                 % over subjects
        name_p = sprintf('%s_prep',names{ii});
        name_I = sprintf('%s_HBICs',names{ii});
        
        %% load each set of ICs per subj per task
        load(name_p);                                                         % load subject
        load(name_I);
        
        for j = length(subconds):-1:1                                       % treating each subcondition seperately
            DATA = final.(sprintf(subconds{j}));
            rej = Comps2Reject.(sprintf(subconds{j})).ICs;
%             rej = rej(rej<=r);
            
            %if choosing r = first x NUMBER of ICS
            %             % for cases where hb ICs are few (handles 0 hb ICs too):
            %             if length(rej)<r
            %                 r = length(rej);
            %                 c = c+1
            %             end
            %
            %             rej = rej(1:r);
            
            % ICA activation matrix  = W * Sph * Raw:
            ICAact = DATA.w * DATA.sph * DATA.data;
            len = size(ICAact,1);
            HB_ICs.(sprintf(subconds{j})) = ICAact(rej,:); % PROBLEM HERE: rej is larger than len for some reason. possible mixup of data?
            ICAact(rej,:) = [];
            w_inv = pinv(DATA.w*DATA.sph);
            w_inv(:,rej) = [];  % rejecting corresponding colomns
%             NEW.(sprintf(subconds{j})) = w_inv * ICAact;
            
            %             ICA.(sprintf(subconds{j})) = ICAact;
        end
        
        %         save (sprintf('%s_Raw_clean',names{ii}),'NEW')
        save (sprintf('%s_Heart',names{ii}),'HB_ICs')
        clear HB_ICs
    end
end