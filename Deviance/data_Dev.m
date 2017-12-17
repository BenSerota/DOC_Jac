%% Checking Data deveation from normal distribution
clear

data_paths = {'E:\DOC\Data from Jaco\VS';'E:\DOC\Data from Jaco\MCS';...
    'E:\DOC\Data from Jaco\EMCS';'E:\DOC\Data from Jaco\CTRL'}; 
conds = {'VS';'MCS';'EMCS';'CTRL'};
subconds = {'LSGS';'LSGD';'LDGS';'LDGD'};
for i = 1:length(conds)                                                     % over conditions
   [Dev_all.(sprintf(conds{i})) , subjects_chosen.(sprintf(conds{i})), sizes(i)] = Deviance(data_paths{i} conds subconds);
   SE = std();
end

%% Plotting deviation differences between conditions (VS,MCS, etc...) and subdata(LSGS/LSGD etc...)
for i = 1:length(conds)
    y(i,:) = cell2mat(struct2cell(Dev_all.(sprintf(conds{i}))));
end
bar(y)
title('Deviation from normal distribution')
set(gca,'xticklabel',conds)
ylabel('% Deviance')
legend(subconds,'location','nw')


stderror(i,j) = std( data ) / sqrt( length( data ));
hold on
bar(1:3,mean_velocity)
errorbar(1:3,mean_velocity,std_velocity,'.')