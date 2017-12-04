
function [CAT] = matcat (STRCT)

% concatenating all conditions and trials
CAT = cat(3,STRCT.data.LSGS,STRCT.data.LSGD,STRCT.data.LDGS,STRCT.data.LDGD);

%reshaping into 1 matrix (electrodesXtime)
rows = size(STRCT.data.LSGS,1); % just eliciting # of electrodes
CAT = reshape(CAT,rows,[]);

% deleting 257th row (reference)
CAT(end,:) = [];

end