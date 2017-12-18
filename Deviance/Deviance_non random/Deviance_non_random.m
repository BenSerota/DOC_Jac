function [mean_dev , SE] = Deviance_non_random (subconds, thresh)
% Calculates th deviance of data above a given STD threshold (given in the
% nested non_random_check function), in all data files in the inputed path.

clc
close all

load good_channels
info = what;
n = length(info.mat);                                                       % # of subjects in given directory

for i = 1:n                                                                 % over subjects
    
    sbj = info.mat{i}(1:end-4);                                             % gets rid of .mat ending
    load(sprintf(sbj))                                                      % loads subject
    
    for ii = length(subconds):-1:1                                          % over sub-conditions
        DATA = data.(subconds{ii})(good_channels,:,:);                      % chooses only scalp channels
        data_z = zscore(DATA,[],3);                                         % z scores according to trial
        data_z = reshape(data_z,size(DATA,1),[]);
        STD_m(i,ii) = mean(std(data_z));                                    % MEAN of STD?! i.e. across time points, across channels
        deviants = data_z >= thresh  | data_z <= -thresh  ;
        prcnt_dev(i).(sprintf(subconds{ii})) = nnz(deviants)*100 / (size(data_z,1)*size(data_z,2)) ;
    end
end

full_mat = reshape(cell2mat(struct2cell(prcnt_dev)),[n,length(subconds)])';

for ii = length(subconds):-1:1
    mean_dev.(sprintf(subconds{ii})) = mean(full_mat(:,ii));
end

STD_m_m = mean(STD_m,1);

for ii = length(subconds):-1:1
    SE.(sprintf(subconds{ii})) = STD_m_m(ii)/sqrt(n);
end