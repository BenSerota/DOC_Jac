
function [CAT] = matcat (STRCT)
% this funciton is for our avalanche analysis: 
% 1. it concatenates all trials (and all conditions)
% 2. it deletes 257th channel (reference)
    % DETAILS : in every sub-condition of the task. It takes a 3-dim matrix (channel X sample X trial)
    % and returns a 2-dim matrix: (channel X sample).
    % importantly: matcat inmserts a 0 between every trial, to avoid
    % combining avalanches. 

subcndt = fields(STRCT);
subcndt(5:6) = [];                                                          % no need for last 2 sub-conditions

% adding 0 after every trial
for i = 1:length(subcndt)
   STRCT.(subcndt{i})(:,end+1,:) = 0;
end

% concatenating all conditions and trials
CAT = cat(3,STRCT.(subcndt{1}),STRCT.(subcndt{2}),STRCT.(subcndt{3}),STRCT.(subcndt{4}));

%reshaping into 1 matrix (electrodesXtime)
rows = size(STRCT.(subcndt{i}),1);                                          % just eliciting # of electrodes
CAT = reshape(CAT,rows,[]);

% deleting 257th row (reference)
CAT(end,:) = [];

end