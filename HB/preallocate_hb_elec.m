function [hb_elec] = preallocate_hb_elec(subconds , nchan)
% preallocating structure, every subject anew
for k = length(subconds):-1:1                                               
    hb_elec(nchan).(sprintf(subconds{k})) = [];
end