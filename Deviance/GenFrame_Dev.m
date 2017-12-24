%% Checking Data deveation from normal distribution
clear
profile on

data_paths = {'E:\DOC\Data from Jaco\VS';'E:\DOC\Data from Jaco\MCS';...
    'E:\DOC\Data from Jaco\EMCS';'E:\DOC\Data from Jaco\CTRL'};
mac_data_paths = {'/Users/admin/Desktop/DACOBO_h/VS';'/Users/admin/Desktop/DACOBO_h/EMCS';...
    '/Users/admin/Desktop/DACOBO_h/MCS';'/Users/admin/Desktop/DACOBO_h/CTRL'};

conds = {'VS';'MCS';'EMCS';'CTRL'};
subconds = {'LSGS';'LSGD';'LDGS';'LDGD'};
thresh = 3;

for i = length(conds):-1:1                                                     % over conditions
    cd(data_paths{i})                                                       % changes conditions
%         cd(mac_data_paths{i})                                                    % changes conditions
    [Dev_all(i,:) , SE(i,:) ] = Deviance(conds{i}, subconds, thresh);
end


%% plotting

y_lim = 1.1*max(max(Dev_all));                                              % setting and uniforming y axis limit. just wanted 1.1 times the max value, to give some space

% Opt(1)
bar(Dev_all)
hold on
errorbar(Dev_all,SE,'r.')
ylim([0 y_lim])
title(sprintf(' %s - Deviation from normal distribution', conds{i}))
set(gca,'xticklabel',subconds)
ylim([0 y_lim])
ylabel(sprintf('%% of Events above %g STD', thresh))



% Opt (2)
figure()
for i = length(Dev_all):-1:1
    subplot(1,4,i)
    temp_y = Dev_all(i,:);
    temp_se = SE(i,:);
%     colors = lines(length(temp_y));
    bar(temp_y);
    ylim([0 y_lim])
    title(sprintf(' %s - Deviation from normal distribution', conds{i}))
    set(gca,'xticklabel',subconds)
    ylim([0 y_lim])
    ylabel(sprintf('%% of Events above %g STD', thresh))
    hold on
    errorbar(temp_y,temp_se,'r.')
end

p = profile('info');
profile viewer


