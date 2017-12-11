function hb = hbs2fnd(ts,sr,thresh)
%%%%%%%%perhaps add a user defined thresh option

if size(ts,2) > size(ts,1)
    ts = permute(ts,[2 1 3]);
end
if ~exist('sr','var')
    sr = 250;
end
if ~exist('thresh','var')
    thresh = 3;
end
ts = zscore(ts);
if thresh < 1
    if thresh < 0.5
        thresh = 1 - thresh;
    end
    dstrb = sort(ts(:));
    l = length(dstrb);
    k = round(l*thresh);
    thresh(1) = dstrb(k);
    k2 = round(l*(1 - thresh));
    thresh(2) = dstrb(k2);
else
    thresh = sort([-thresh thresh]);
end
pmsk = ts > thresh(2);
pmsk = msk2rstr(pmsk,ts,1);
nmsk = ts < thresh(1);
nmsk = msk2rstr(nmsk,ts,0);
nisi = diff(find(nmsk));
pisi = diff(find(pmsk));
ncv = std(nisi)/mean(nisi);
pcv = std(pisi)/mean(pisi);
nrate = mean(nisi)/sr;
prate = mean(pisi)/sr;
if crit2aply(pcv,prate) || crit2aply(ncv,nrate)
    hb = 1;
else
    hb = 0;
end

function h = crit2aply(cv,rate)

if cv<.5 && rate>.5 && rate <2
    h = 1;
elseif cv<1 && rate>.8 && rate <1.9
    h = 1;
elseif cv<1.5 && rate>1 && rate <1.7
    h = 1;
else
    h = 0;
end

function msk = msk2rstr(msk,ts,pos)

smpls = size(msk,1);
msk = col([msk;zeros(1,size(ts,2))]);
ts = col([ts;zeros(1,size(ts,2))]);
[s,e] = enpoints2find(msk);
if isempty(s)
    return
end
mx = max(e-s+1);
inds = round(linspacen(s,e,mx));
vals = ts(inds);
if ~pos
    [~,inds2] = min(vals);
elseif pos == 1
    [~,inds2] = max(vals);
elseif pos == 2
    [~,inds2] = max(abs(vals));
end
inds2 = sub2ind(size(vals),inds2,1:size(vals,2));
inds = inds(inds2);
msk = msk*0;
msk(inds) = 1;
msk = reshape(msk,[smpls+1 length(msk)/(smpls+1)]);
msk(end,:) = '';

function [s,e] = enpoints2find(msk)
%msk is assumed to be a column binary vector
dm = diff(msk);
e = find(dm==-1);
s = find(dm==1)+1;
if msk(1)
    s = [1;s];
end
if msk(end)
    e(end+1) = length(msk);
end

function y = linspacen(d1, d2, n)
%LINSPACEN Linearly spaced vector.
%   LINSPACEN(X1, X2) generates a row vector of 100 linearly
%   equally spaced points between X1 and X2.
%
%   LINSPACEN(X1, X2, N) generates N points between X1 and X2.
%   For N < 2, LINSPACE returns X2.
%
%   X1, X2 can also be column vectors in which case the output will 
%   be a matrix of spaced columns

if nargin == 2
    n = 100;
end

l1 = length(d1);
l2 = length(d2);
if l1 < l2
    d2(l1+1:end) = '';
elseif l2 < l1
    d1(l2+1:end) = '';
end

spacer = (0:n-2);
step = (d2-d1)/(n-1);
y = [d1(:,ones(1,n-1))+step*spacer d2]';