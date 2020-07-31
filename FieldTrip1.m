%%
restoredefaultpath
addpath /home/raquib/Documents/MATLAB/fieldtrip-20191025
% addpath /home/raquib/Documents/MATLAB/eeglab2019_0
ft_defaults


%%
filename = '/home/raquib/Desktop/workspaces/mep-classification/data/original/sub03/exp01/eeg/SP 110RMT r2/raw.set';
hdr = ft_read_header( filename ); 
data = ft_read_data( filename, 'header', hdr); 
events = ft_read_event( filename, 'header', hdr );

%%
cfg = [];
cfg.viewmode = 'vertical';
ft_databrowser(cfg, data);

%%
cfg = []
cfg.channel = 'all'
cfg.chantype = hdr.chantype
cfg.trials = 'all'

cfg.demean = 'yes';
cfg.baselinewindow = [-1 0];
cfg.lpfilter = 'yes';
cfg.lpfreq = 100;

trialdata = ft_preprocessing(cfg, data);

%%
cfg = [];
cfg.dataset = filename;
cfg.channel = 'all';
cfg.preproc.demean = 'yes';
cfg.viewmode = 'vertical';
ft_databrowser(cfg);

%%
cfg = []
cfg.datafile = filename
cfg.headerfile = filename
[data] = ft_preprocessing(cfg)

%%
neighbours(1).label = 'C3';
neighbours(1).neighblabel = {'FC1', 'CP1', 'FC5', 'CP5'};
neighbours(2).label = 'C4';
neighbours(2).neighblabel = {'FC2', 'CP2', 'FC6', 'CP6'};

cfg = []
cfg.method = 'hjorth'
cfg.elec = hdr.elec
cfg.trials = 'all'
cfg.feedback = 'gui'
cfg.neighbours = neighbours
dt2 = ft_scalpcurrentdensity(cfg, data)

%%
cfg = [];
cfg.channel = 'C3';
ft_databrowser(cfg, data)