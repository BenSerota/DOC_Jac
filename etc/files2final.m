% files to final
clear
clc
start_ben
profile on

DOC_basic
new_out = {'E:\DOC\Data_Jaco_prep\newprep\VS';'E:\DOC\Data_Jaco_prep\newprep\MCS';...
    'E:\DOC\Data_Jaco_prep\newprep\EMCS';'E:\DOC\Data_Jaco_prep\newprep\CTR'};

for i = length(conds)-1:-1:1                                                 % over conditions
    cd(out_paths{i})                                                       % changes conditions
    load(sprintf('%s_names',conds{i}))
    names = sortn(names);
    for ii = 1:length(names)
        cd(out_paths{i})
        name = names{ii};
        %loading:
        %ica_w
        load(sprintf('icaW_subj_%s',name))
        %ica_sph
        load(sprintf('icaSph_subj_%s',name))
        %data_cont
        load(sprintf('prepro_subj_%s',name))
        
        try
            for j = length(subconds):-1:1
                final.(sprintf(subconds{j})).w = ICA_weights.(sprintf(subconds{j}));
                final.(sprintf(subconds{j})).sph = ICA_spheres.(sprintf(subconds{j}));
                final.(sprintf(subconds{j})).data = DATA_cont.(sprintf(subconds{j}));
            end
        catch
            Fucked_up_stuff = [Fucked_up_stuff ; name];
        end
        name = name(1:end-4);
        cd(new_out{i})
        save(sprintf('%s_prep', name),'final')
    end
end

p = profile('info');
profile viewer