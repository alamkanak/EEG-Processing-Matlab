
%% Import FieldTrip toolbox
restoredefaultpath
addpath /home/raquib/Documents/MATLAB/fieldtrip-20191025
addpath /home/raquib/Documents/MATLAB/eeglab2019_0
ft_defaults

%%
fileList = dir("/home/raquib/Desktop/workspaces/mep-classification/data/original/*/*/eeg/SP 110RMT*/clean-prestimulus.set");

%%
for k = 30:length(fileList)
    file = fileList(k);
    segments = regexp(file.folder, '/', 'split');
    subject = segments{8};
    session = segments{9};
    take = segments{11};
    ['Transforming EEG of ' subject '/' session '/' take]
    
    filename = [file.folder '/' file.name]
    
    % Preprocessing.
    cfg = []
    cfg.datafile = filename
    cfg.headerfile = filename
    cfg.lpfilter = 'yes'
    cfg.lpfreq = 100
    cfg.lpfiltord = 4
    cfg.bsfilter = 'yes'
    cfg.bsfreq = [48 52]
    cfg.bsfiltord = 4
    cfg.reref = 'yes'
    cfg.refchannel = 'Cz'
    cfg.demean = 'yes'
    cfg.baselinewindow = [-1 0]
    cfg.detrend = 'yes'
    [data] = ft_preprocessing(cfg)
    
    % Inspect visually.
    cfg = []
    cfg.viewmode = 'vertical'
    cfg = ft_databrowser(cfg, data)
    
    % Reject artifact.
%     cfg = []
%     data = ft_rejectartifact(cfg, data)
% 
%     % Hjorth transformation.
%     neighbours(1).label = 'C3';
%     neighbours(1).neighblabel = {'FC1', 'CP1', 'FC5', 'CP5'};
%     neighbours(2).label = 'C4';
%     neighbours(2).neighblabel = {'FC2', 'CP2', 'FC6', 'CP6'};
%     cfg = []
%     cfg.method = 'hjorth'
%     cfg.elec = data.hdr.elec
%     cfg.trials = 'all'
%     cfg.feedback = 'gui'
%     cfg.neighbours = neighbours
%     dt2 = ft_scalpcurrentdensity(cfg, data)
%     
%     % Save file.
%     filename = [file.folder '/07-ft-hjorth-raw.mat']
%     ft_write_data(filename, dt2, 'dataformat', 'matlab')
    break
end
