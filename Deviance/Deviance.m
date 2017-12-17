function [mean_dev , chosen_sbj, n ] = Deviance (PATH subconds)
% Calculates th deviance of data above a given STD threshold (given in the 
% nested non_random_check function), in all data files in the inputed path.

clc
close all

cd(PATH)

prcnt_dev_acc = zeros(4,1);
info = what;
n = length(info.mat);                                                       % # of subjects in given directory

for i = 1:n                                                                 % over subjects
    for ii = 1:size(subconds,2)                                             % over sub-conditions
        %[prcnt_dev_single , chosen_sbj(i,ii)] = random_check_bytrial(ii,0);
        [prcnt_dev_single , chosen_sbj(i,ii)] = non_random_check_bytrial(ii,0);
        prcnt_dev_acc(ii) = prcnt_dev_acc(ii) + prcnt_dev_single  ;
    end
    
    mean_dev.(sprintf(subconds{ii})) = prcnt_dev_acc(ii)/n;
    
    fprintf('\n \n  In condition %s, after randomly selecting 5 electrodes in a random subject %G times, \n the mean %% of data over 3 STD was: %G%%',subconds{ii}, n, mean_dev.(sprintf(subconds{ii})))
    fprintf('\n i.e., the data in condition %s has %g times the amount of extreme values than that of a normal distribution.', subconds{ii}, mean_dev.(sprintf(subconds{ii}))/2)
end
