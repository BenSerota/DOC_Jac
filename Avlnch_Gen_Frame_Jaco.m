% Avlnch_Gen_Frame
% size of av_size/length/size_length histograms is: M x N, where:
%   M = 5 = # of manifestations of thresh, 
%   N = # of different bin sizes

%% for multiple subjects ( mult data matrices):

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
