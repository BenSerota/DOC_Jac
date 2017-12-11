% This script was meant to plot a handful of random trials in a handful of 
% ranodm channels in one random subject.
% to choose the number of trials/channels/subjects to plot edit
% the function 'random_check'
% NOTE: all plots appear in one big plot with subplots, so don't choose
% a large number of examples, rather run this script a number of times


% first go to your chosen data set 
clear 
clc

info = what;   
info.mat = sortn(info.mat);              % sorts lists ascending
[c t elecs subdata] = random_check;
subjects = length(info.mat);
data_kind = {['data.' subdata]};
thresh = 3;                             % sets STD thresh of "deviant"               

% choose 1 random subjects to plot
chosen_s = randi(subjects,1,1);

% load subject
to_load = info.mat(chosen_s);            % in a cell cuz 'load' works on cells
loaded = cellfun(@load,to_load);
DATA = loaded.data.LSGS(1:256,:,:);      % throws away reference elec #257

% concatenate trials in every channel
long_elec = reshape(DATA,size(DATA,1),[]);

% zscoring all data
z_long_elec = zscore(long_elec')';          %transpose is cuz zscore works on columns 

% choose some channels to plot
chosen_c = randi(elecs,1,c);    

% generate matrix to plot
z_plot = z_long_elec(chosen_c,:);
deviants = z_plot >= thresh  | z_plot <= -thresh  ;

% plotting
f = figure('Name','Random z-plots');
counter = 0;
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


dev_prcnt = round(sum(sum(deviants))*100/length(long_elec),3,'significant');
sprintf('%% of data over 3 STD : %s%%', dev_prcnt)

