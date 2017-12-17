
function [dev_prcnt] = non_random_check_bytrial (PATH, SUBCONDS, PLOT_FLAG)
% This function plots the activity in a handful of random electrodes, in
% one random subject.
% The function returns both aw-data and z-score plots of the electrode.
% All trials are concatenated to give one 'long' time series.
% To choose the number of trials/channels/subjects to plot edit
% the parameters in the scripts 'random_check'


info = what;
[elecs thresh] = non_random_check_param;  

% load subject
to_load = info.mat(chosen_s);                                               % in a cell cuz 'load' works on cells
loaded = cellfun(@load,to_load);
for i = 1:length(info.mat)
load PATH.(
DATA = loaded.data.(sprintf(subdata))(1:256,:,:);                           % throws away reference elec #257
clear loaded

for i = 1:length(SUBCONDS)                                             % over sub-conditions

% switch DATA_FLAG
%     case 1
%         subdata = 'LSGS';
%     case 2
%         subdata = 'LSGD';
%     case 3
%         subdata = 'LDGS';
%     case 4
%         subdata = 'LDGD';
%     case 5
%         subdata = 'H_STD';
%     case 6
%         subdata = 'H_DVT';
%     otherwise
%         h = errordlg('Please input flag (between 1-6) to choose condition of data'); pause;
% end




% concatenate trials in every channel
long_elec = reshape(DATA,size(DATA,1),[]);

% choose some channels to plot
chosen_c = randi(elecs,1,c);

%% plotting
if PLOT_FLAG == 1
    figure('Name','Random channel data plots');
    for i = 1:c
        subplot(c,1,i)
        plot(long_elec(i,:)')
        title(['electrode #' num2str(chosen_c(i))])
        xlabel('ms')
        ylabel('z-score')
    end
    mtit('z-scores of random channels');
end

%% Z-scoring

% zscoring all data
z_long_elec = zscore(long_elec,[],2);

% generate matrix to plot
z_plot = z_long_elec(chosen_c,:);
deviants = z_plot >= thresh  | z_plot <= -thresh  ;


%% back to z by trials
z_plot_trials = reshape(z_plot,[c,size(DATA)]);

%% plotting
if plot_flag == 1
    figure('Name','Random z-plots');
    for i = 1:c
        subplot(c,1,i)
        plot(z_plot(i,:)')
        hold on
        plot(find(deviants(i,:)),z_plot(i,find(deviants(i,:))),'r*')
        title(['electrode #' num2str(chosen_c(i))])
        xlabel('ms')
        ylabel('z-score')
    end
    mtit('z-scores of random channels');
    
end

%Averaging across subjects:
dev_prcnt = round(sum(sum(deviants))*100/length(long_elec),2);

if plot_flag == 1
    fprintf('%% of data over 3 STD : %G%%', dev_prcnt)
    % for a normal dist, +-3STD covers 98% of data, ideally dev_prcnt=2:
    fprintf('\n Averaging across electrodes, data is %g times the noise of a normal distribution', dev_prcnt/2)
    tilefigs
end


