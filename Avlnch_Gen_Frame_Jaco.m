% Avlnch_Gen_Frame
% size of av_size/length/size_length histograms is: M x N, where:
%   M = 5 = # of manifestations of thresh, 
%   N = # of different bin sizes

%% Checking Data quality 
clear
global testingcounter
testingcounter = 0;
data_paths = {'E:\DOC\Data from Jaco\VS';'E:\DOC\Data from Jaco\MCS';'E:\DOC\Data from Jaco\EMCS';'E:\DOC\Data from Jaco\CTRL'}; 
conds = {'VS';'MCS';'EMCS';'CTRL'};
for i = 1:4
   [Dev_all.(sprintf(conds{i})) , subjects_chosen.(sprintf(conds{i}))] = Deviance(data_paths{i});
end

%% deviation differences between conditions (LSGS/LSGD etc...)
% bar3()

%% Data Analysis

% % set path first
clear
clc
% close all

av_param_values % sets avalanche parameters
fold = what;
subjects = length(fold.mat);
SUBJECTS = cell(subjects,1);

% TODO: maybe size by length is actually only prob of size

for i = 1:subjects
    temp = load(fold.mat{i});
    temp_raw = matcat(temp);
    raw_data{i} = temp_raw'; % must have correct structure!
    clear temp
    [BIG5] = eeg2avalnch_ben(raw_data{i},tb_size,thresh,pos,cont);
    SUBJECTS{i} = BIG5; % feeding into main cell array
    clear BIG4
end

%%

loggingplots(SUBJECTS)

calc_Entropy(SUBJECTS)


% % functions
