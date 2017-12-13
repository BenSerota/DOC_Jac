
function [dev_prcnt_trials , to_load] = random_check (DATA_FLAG,PLOT_FLAG)
% This function plots the activity in a handful of random electrodes, in
% one random subject.
    % The function returns both aw-data and z-score plots of the electrode. 
    % All trials are concatenated to give one 'long' time series. 
    % To choose the number of trials/channels/subjects to plot edit
    % the parameters in the scripts 'random_check'
    % FIRST GO TO YOUR CHOSEN DATA FOLDER 
 
% loading good channels
load good_channels
xlm = [1 10000]+10000;
thresh = 3;                             % sets STD thresh of "deviant"               

% choosing condition in data
data_flag = DATA_FLAG;
% plot_flag = PLOT_FLAG;
switch data_flag
    case 1
        subdata = 'LSGS';
    case 2
        subdata = 'LSGD';
    case 3
        subdata = 'LDGS';
    case 4
        subdata = 'LDGD';
    case 5
        subdata = 'H_STD';
    case 6
        subdata = 'H_DVT';
    otherwise
    h = errordlg('please input flag (between 1-6) to choose condition of data'); pause;
end

info = what;
info.mat = sortn(info.mat);              % sorts lists ascending
random_check_param;                      % sets wanted parameters
subjects = length(info.mat);
data_kind = {['data.' subdata]};


% choose 1 random subjects to plot
chosen_s = randi(subjects,1,1);

% load subject
loaded = load(info.mat{chosen_s});
DATA = loaded.data.(sprintf(subdata))(1:256,:,:);
clear loaded

% concatenate trials in every channel
long_elec = reshape(DATA,size(DATA,1),[]);

%% choose some channels to plot
% option 1: takes into account ALL electrodes:
    % chosen_c = randi(elecs,1,c);
% option 2: takes into account only scalp electrodes:
    chosen_c = good_channels(randperm(length(good_channels),c));
% option 3: takes into account only non-scalp electrodes:
    % chosen_c = setdiff(1:256,good_channels);
    % chosen_c = chosen_c(randperm(length(chosen_c),c));

%% plotting
if PLOT_FLAG == 1
    figure('Name','Random channel data plots');
    for i = 1:c
        subplot(c,1,i)
        plot(long_elec(i,:)')
        title(['electrode #' num2str(chosen_c(i))])
        xlim(xlm)
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

z_plot_trials = reshape(z_plot,[c,size(DATA,2),size(DATA,3)]);
z_plot_trials = zscore(z_plot_trials,[],2);

deviants_trials = z_plot_trials >= thresh  | z_plot_trials <= -thresh  ;


%% plotting z scores by electrode

%Averaging across subjects:
dev_events = sum(sum(deviants));
dev_prcnt = round(dev_events*100/length(long_elec),2);

if PLOT_FLAG == 1
    figure('Name','Random z-plots. z by trial');
    for i = 1:c
        subplot(c,1,i)
        plot(z_plot(i,:)')
        hold on
        plot(find(deviants(i,:)),z_plot(i,find(deviants(i,:))),'r*')
        title(['electrode #' num2str(chosen_c(i))])
        xlim(xlm)
        xlabel('ms')
        ylabel('z-score')
    end
    mtit('z-scores of random channels, z by electrode');
   
    fprintf('%% of data over 3 STD : %G%%', dev_prcnt)
    % for a normal dist, +-3STD covers 98% of data, ideally dev_prcnt=2:
    fprintf('\n Averaging across electrodes, data is %g times the noise of a normal distribution', dev_prcnt/2)
    tilefigs
end

%% plotting z by trials
dev_events_trials = sum(sum(sum(deviants_trials)));
%Averaging across subjects:
dev_prcnt_trials = round(dev_events_trials*100/length(long_elec),2);

if PLOT_FLAG == 1 
    figure('Name','Random z-plots');
    for i = 1:c
        subplot(c,1,i)
        plot(z_plot_trials(i,:)')
        hold on
        plot(find(deviants_trials(i,:)),z_plot_trials(i,find(deviants_trials(i,:))),'r*')
        title(['electrode #' num2str(chosen_c(i))])
        xlim(xlm)
        xlabel('ms')
        ylabel('z-score')
    end
    mtit('z-scores of random channels, z by trial');
   
    fprintf('%% of data over %g STD : %G%%', thresh, dev_prcnt_trials)
    % for a normal dist, +-3STD covers 98% of data, ideally dev_prcnt=2:
    fprintf('\n Averaging across electrodes, data is %g times the noise of a normal distribution', dev_prcnt_trials/2)
    tilefigs
end

