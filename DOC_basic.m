
conds = {'VS';'MCS';'EMCS';'CTR'};
subconds =  {'LSGS';'LSGD';'LDGS';'LDGD'};
Fucked_up_stuff = {};
c = 0;

if ispc
    in_root = 'E:\Ben DOC\Data from Jaco\';
    out_root = 'E:\Ben DOC\Data_Jaco_prep\';
    for i = length(conds):-1:1
        data_paths{i} = sprintf('%s%s',in_root,conds{i});
        out_paths{i} = sprintf('%s%s',out_root,conds{i});
    end
    WS_path = 'C:\Users\BenSerota\Dropbox\Ben Serota\momentary\WS';
    mom_Fig_path = 'C:\Users\BenSerota\Dropbox\Ben Serota\momentary\Figs';
    LZ_rslts = 'C:\Users\BenSerota\Dropbox\Ben Serota\eeg ANALYSES\results\LZC';
    avlnch_rslts = 'C:\Users\BenSerota\Dropbox\Ben Serota\eeg ANALYSES\results\avalanches';
    
elseif ismac
    in_root = '/Users/admin/Desktop/DACOBO_h/origin/';
    out_root = '/Users/admin/Desktop/DACOBO_h/mock/';
    for i = length(conds):-1:1
        data_paths{i} = sprintf('%s%s',in_root,conds{i});
        out_paths{i} = sprintf('%s%s',out_root,conds{i});
    end
        WS_path = '/Users/admin/Dropbox/Ben Serota/momentary';
        LZ_rslts = '/Users/admin/Dropbox/Ben Serota/eeg ANALYSES/results/LZC';
        avlnch_rslts = '/Users/admin/Dropbox/Ben Serota/eeg ANALYSES/results/avalanches';
end

data_paths = data_paths';
out_paths = out_paths';
LZC_nohb_outpath = 'E:\Dropbox\Ben Serota\eeg ANALYSES\LZ\BenLZ\Zhang no HB\results';
