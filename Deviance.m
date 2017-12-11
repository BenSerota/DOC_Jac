function [mean_dev , chosen_sbj] = Deviance (PATH)

clc
close all

cd(PATH)

prcnt_dev_acc = zeros(4,1);
cndt = {'LSGS', 'LSGD', 'LDGS', 'LDGD'};
info = what;
N = size(info.mat,1); n = round(N*log(N)); % n = number of times we sample
% according to average coupon-collectors-problem

for ii = 1:size(cndt,2)        % over conditions
    for i = 1:n     % check randomly n times
        [prcnt_dev_single , chosen_sbj(i,ii)]= random_check(ii,0);
        prcnt_dev_acc(ii) = prcnt_dev_acc(ii) + prcnt_dev_single  ;
    end
    
    mean_dev.(sprintf(cndt{ii})) = prcnt_dev_acc(ii)/n;
    
    fprintf('\n \n  In condition %s, after randomly selecting 5 electrodes in a random subject %G times, \n the mean %% of data over 3 STD was: %G%%',cndt{ii}, n, mean_dev.(sprintf(cndt{ii})))
    fprintf('\n i.e., the data in condition %s has %g times the amount of extreme values than that of a normal distribution.', cndt{ii}, mean_dev.(sprintf(cndt{ii}))/2)
end
