%%
% path = '/home/raquib/Desktop/workspaces/mep-classification/data/original/sub05/exp01/eeg/SP 110RMT r3'
% sourceFile = 'Gallaty_Lynette_2018-12-14_12-26-18.cnt'
restoredefaultpath
addpath /home/raquib/Documents/MATLAB/fieldtrip-20191025
addpath /home/raquib/Documents/MATLAB/eeglab2019_0
addpath /home/raquib/Documents/MATLAB/FastICA_25
ft_defaults

%%
fileList = dir("/home/raquib/Desktop/workspaces/mep-classification/data/original/*/*/eeg/*/raw.set");
for k = 1:length(fileList)
    file = fileList(k);
    disp(strcat(num2str(k), '/', num2str(length(fileList))))

    filename = strcat(file.folder, '/', file.name);
    cfg = [];
    cfg.datafile = filename;
    cfg.headerfile = filename;
    [data] = ft_preprocessing(cfg);
    neighbours(1).label = 'C3';
    neighbours(1).neighblabel = {'FC1', 'CP1', 'FC5', 'CP5'};
    neighbours(2).label = 'C4';
    neighbours(2).neighblabel = {'FC2', 'CP2', 'FC6', 'CP6'};
    cfg = [];
    cfg.method = 'hjorth';
    cfg.elec = data.hdr.elec;
    cfg.trials = 'all';
    cfg.feedback = 'gui';
    cfg.neighbours = neighbours;
    dt2 = ft_scalpcurrentdensity(cfg, data);
    filename = strcat(file.folder, '/010-raw-hjorth.mat');
    ft_write_data(filename, dt2, 'dataformat', 'matlab')
end
