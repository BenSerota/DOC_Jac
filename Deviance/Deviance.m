function [mean_dev , SE] = Deviance (COND, subconds, thresh)
% Calculates th deviance of data above a given STD threshold (given in the
% nested non_random_check function), in all data files in the inputed path.

clc
close all

load good_channels
info = what;
n = length(info.mat);                                                       % # of subjects in given directory
switch COND
    case 'CTRL'
        cond = 4;
    case 'EMCS'
        cond = 3;
    case 'MCS'
        cond = 2;
    otherwise
        cond = 1;
end


for i = 1:n                                                                 % over subjects
    
    sbj = info.mat{i}(1:end-4);                                             % gets rid of .mat ending
    load(sprintf(sbj))                                                      % loads subject
    
    for ii = length(subconds):-1:1                                          % over sub-conditions
        DATA = data.(subconds{ii})(good_channels,:,:);                      % chooses only scalp channels
        data_z = zscore(DATA,[],3);                                         % z scores according to trial
        data_z = reshape(data_z,size(DATA,1),[]);
        deviants = data_z >= thresh  | data_z <= -thresh  ;
        CELL{cond}(i,ii)= nnz(deviants)*100 / numel(deviants);              % CELL is condsXsbjXsubconds
    end
end

mean_dev = mean(CELL{cond},1);
STD = std(CELL{cond});
SE = STD./sqrt(n);
