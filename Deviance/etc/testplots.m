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

% choose 1 random subjects to plot
chosen_s = randi(subjects,1,1);
% choose some channels to plot
chosen_c = randi(elecs,1,c);

% load subject
to_load = info.mat(chosen_s);           % in a cell cuz 'load' works on cells
loaded = cellfun(@load,to_load);

% choose some trials to plot
trials = size(loaded.data.LSGS,3);           % trials is the amount of trials for THIS subjects, in condition LSGS
chosen_t = randi(trials,1,t);           % chosen_t is the trials chosen, per subject(row)
    

% plotting
f = figure('Name','Random plots');
title('random channels and random trials');
counter = 0;

for i = chosen_c                        % per electrode
    for j = chosen_t                    % per trials
        counter =  counter+1;
        temp = loaded.data.LSGS(i,:,j); % this takes entire duration of recording 
        subplot(c,t,counter)
        switch mod(counter,c)
            case 1
                plot(temp,'r')
            case 2
                plot(temp,'b')
            case 3
                plot(temp,'g')
            case 4
                plot(temp,'c')
            otherwise 
                plot(temp)
        end
        xlabel('ms')
        ylabel('mv')
    end
end
figure(f)
mtit('random channels and random trials');

%TODO 
%1. re-write in this format. see for xample ow this plot is for some
%reason very noisy in the end trials...
%2. write z-score plots.
