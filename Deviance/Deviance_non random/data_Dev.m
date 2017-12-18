%% Checking Data deveation from normal distribution
clear

data_paths = {'E:\DOC\Data from Jaco\VS';'E:\DOC\Data from Jaco\MCS';...
    'E:\DOC\Data from Jaco\EMCS';'E:\DOC\Data from Jaco\CTRL'};
mac_data_paths = {'/Users/admin/Desktop/DACOBO_h/VS';'/Users/admin/Desktop/DACOBO_h/EMCS';...
    '/Users/admin/Desktop/DACOBO_h/MCS';'/Users/admin/Desktop/DACOBO_h/CTRL'};

conds = {'VS';'MCS';'EMCS';'CTRL'};
subconds = {'LSGS';'LSGD';'LDGS';'LDGD'};
thresh = 3;

for i = length(conds):-1:1                                                     % over conditions
    cd(data_paths{i})                                                       % changes conditions
    %     cd(mac_data_paths{i})                                                    % changes conditions
    [Dev_all.(sprintf(conds{i})) , SE2.(sprintf(conds{i})) ] = Deviance_non_random(subconds, thresh);
end

%% prep for plotting

% transferring dev values to full matrix
for i = length(conds):-1:1
    y(i,:) = cell2mat(struct2cell(Dev_all.(sprintf(conds{i}))));
end

% transferring SE values to full matrix
for i = length(conds):-1:1
    for ii = length(subconds):-1:1
        SE_full(i,ii) = SE2.(sprintf(conds{i})).(sprintf(subconds{ii}));
    end
end

%% Plotting

y_lim = max(max(y));
figure()
for i = length(y):-1:1
    subplot(1,4,i)
    temp = y(i,:);
    temp_se = SE_full(i,:);
    bar(temp) %,'FaceColors',colors) %,'FaceColor','flat')
    ylim([0 y_lim+.5])
    title(sprintf(' %s - Deviation from normal distribution', conds{i}))
    set(gca,'xticklabel',subconds)
    ylim([0 y_lim+.5])
    ylabel(sprintf('%% of Events above %g STD', thresh))
    hold on
    errorbar(temp,temp_se,'r.')
end
