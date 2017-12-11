% Avlnch_Gen_Frame
% size of av_size/length/size_length histograms is: M x N, where:
%   M = 5 = # of manifestations of thresh, 
%   N = # of different bin sizes

%% Checking Data quality 
clc
close all
prcnt_dev_acc = zeros(4,1);
cndt = {'LSGS', 'LSGD', 'LDGS', 'LDGD'};
info = what;
n = 1; % size(info.mat,1)*2;

for ii = 1:1        % over conditions
    for i = 1:n     % check randomly n times
        [prcnt_dev_single , chosen_sbj]= random_check(ii,1);
        prcnt_dev_acc(ii) = prcnt_dev_acc(ii) + prcnt_dev_single  ;
    end
    
    mean_dev(ii) = prcnt_dev_acc(ii)/n;
    
    fprintf('\n \n  In condition %s, after randomly selecting 5 electrodes in a random subject %G times, \n the mean %% of data over 3 STD was: %G%%',cndt{ii}, n, mean_dev(ii))
    fprintf('\n i.e., the data in condition %s has %g times the amount of extreme values than that of a normal distribution.', cndt{ii}, mean_dev(ii)/2)
end

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
