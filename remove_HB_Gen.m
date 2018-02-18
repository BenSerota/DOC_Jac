% remove_HB_Gen

clear
clc
start_ben
DOC_basic
global out_paths subconds 
[NAMES,subjs] = DOC_Basic2(conds);
remove_HB_param
plothb = 1;
finito = 0;

while ~finito
    [DATAwhb, rejcomps] = SingleSubjData(NAMES,cond,subj);
    DATAnhb = remove_HB(DATAwhb, rejcomps, num, lim, plothb);
    [cond,subj, finito] = JacoClock(cond, subj);
end

% don't forget to break into epochs. in LZC code or otherwise?
% LZC

%% functions

function [NAMES,subjects,cond,subj] = DOC_Basic2(conds)
global out_paths
subjects = nan (1,length(conds));
NAMES = cell(1,length(conds));
for i = 1:length(conds)                                                     % over conditions
    cd(out_paths{i})                                                        % changes conditions. out_paths becaus out of original script is now this in-path
    load(sprintf('%s_names',conds{i}));                                     % loads name list
    names = sortn(names);                                                   % for fun
    NAMES{i} = strrep(names,'.mat','');
    subjects(i) = length(names);
end
cond = 1;
subj = 1;
end

function [cond,subj, finito] = JacoClock(cond, subj)
subj = subj + 1;
if subj > subjects(subj)
    cond = cond + 1;
end

if cond > 4
    finito = 1;
end
end


function [LZCsOneSubj] = SingleSubjData(NAMES,cond,subj)
global out_paths subconds num lim plothb
cd(out_paths{cond})
name = NAMES{cond}(subj);
name_p = [ name '_prep'];
name_I = [ name '_HBICs'];
% load each set of ICs per subj
load(name_p);                                                         % load subject
load(name_I);

i = 0;
LZCsOneSubj = nan(1,length(subconds));
while i < length(subconds)
    i = i + 1;
    DATAwhb.data = final.(subconds{i}).data;
    DATAwhb.w = final.(subconds{i}).w;
    DATAwhb.sph = final.(subconds{i}).sph;
    rejcomps = Comps2Reject.(subconds{i});
    
    DATAnhb = remove_HB(DATAwhb, rejcomps, num, lim, plothb);
    
    LZCsOneSubj(i) = onetaskLZC(DATAnhb);
    
end
end



% DATAwhb = final.TASK
% rejcomps = Comps2Reject.TASK
% plothb = 0/1;

function [DATAnhb] = remove_HB(DATAwhb, rejcomps, num, lim, plothb)
% This code is meant to remove a number of hb ICs form our data.

% ICA activation matrix  = W * Sph * Raw:
ICAact = DATAwhb.w * DATAwhb.sph * DATAwhb.data;
% len = size(ICAact,1);
% choosing #num comps from all hb cmps
if isempty(rejcomps)
    return % no need to eliminate any comp
elseif num > length(rejcomps)   % in case there are too few comps
    num = length(rejcomps);     % num = number of hb comps
end

% treating only comps below limit
rejcomps(rejcomps>lim) = [];

if isempty(rejcomps)
    return
else
    rejcomps = rejcomps(1:num);
end

if plothb
    HB_ICs(1:num,:) = ICAact(rejcomps,:);
    plot(HB_ICs)
end

%elimninating hb
ICAact(rejcomps,:) = [];
w_inv = pinv(DATAwhb.w*DATAwhb.sph);
w_inv(:,rejcomps) = [];  % rejecting corresponding colomns
DATAnhb = w_inv * ICAact;
end




function [C_task] = onetaskLZC(data)
% computes LZ Complexity for a single task (3 dim matrix)
global e E_T_flag  % e = instead of n (all) EPOCHS, FOR TEST
data_binary = onetaskLZCprep (data);
n = size(data_binary,3);
if n<e 
    e = n;
end
C_task = nan(1,e); %n !

for i = 1:e %n
    C_task(i) = LZC_Rows(data_binary(:,:,i),E_T_flag);
end
end


function [binary] = onetaskLZCprep (data)
% transforms data to binary according to set threshold
global Zthresh
data = reshape(data,206,385,[]);
data = abs(zscore(data,0,3));
binary = data>Zthresh;
binary = double(binary);
end


% function [] = SaveUniqueName(root_name)
% if ~isstring(root_name) && ~ischar(root_name)
%     error('input must be of class char or string')
% end
% cl = fix(clock);
% stamp = strrep(mat2str(cl),' ','_');
% stamp = strrep(stamp,'[','');
% stamp = strrep(stamp,']','');
% UniqueName = [root_name '_' stamp];
% cd ('E:\Dropbox\Ben Serota\momentary\WS')
% save (UniqueName)
