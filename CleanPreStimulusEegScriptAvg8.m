%%
% path = '/home/raquib/Desktop/workspaces/mep-classification/data/original/sub05/exp01/eeg/SP 110RMT r3'
% sourceFile = 'Gallaty_Lynette_2018-12-14_12-26-18.cnt'
restoredefaultpath
addpath /home/raquib/Documents/MATLAB/fieldtrip-20191025
addpath /home/raquib/Documents/MATLAB/eeglab2019_0
addpath /home/raquib/Documents/MATLAB/FastICA_25
ft_defaults

%%
root = "Clean";
fileList = dir("/home/raquib/Desktop/workspaces/mep-classification/data/original/*/*/eeg/*/06-clean-prestimulus.set");

completed = {
%     ['BaedonTerry' 'SP 110RMT r1'], 
%     ['BaedonTerry' 'SP 110RMT r2'], 
%     ['BaedonTerry' 'SP 110RMT r3'],
%     ['BrunetSarah' 'SP 110RMT r1'], 
%     ['BrunetSarah' 'SP 110RMT r2'], 
%     ['BrunetSarah' 'SP 110RMT r3'], 
%     ['DavidBrown' 'SP 110RMT r1'],
%     ['DavidBrown' 'SP 110RMT r2'],
%     ['DavidBrown' 'SP 110RMT r3']
};

for k = 1:length(fileList)
    file = fileList(k);
    filename = [file.folder '/' file.name];
    cfg = [];
    cfg.datafile = filename;
    cfg.headerfile = filename;
    [data] = ft_preprocessing(cfg)


    neighbours(1).label = 'FC5';
    neighbours(1).neighblabel = {'F3', 'C3', 'F7', 'T7'};
    neighbours(2).label = 'FC3';
    neighbours(2).neighblabel = {'F1', 'C1', 'F5', 'C5'};
    neighbours(3).label = 'FC1';
    neighbours(3).neighblabel = {'Fz', 'Cz', 'F3', 'C3'};
    neighbours(4).label = 'C5';
    neighbours(4).neighblabel = {'FC3', 'CP3', 'FT7', 'TP7'};
    neighbours(5).label = 'C3';
    neighbours(5).neighblabel = {'FC1', 'CP1', 'FC5', 'CP5'};
    neighbours(6).label = 'C1';
    neighbours(6).neighblabel = {'FCz', 'CPz', 'FC3', 'CP3'};
    neighbours(7).label = 'CP5';
    neighbours(7).neighblabel = {'C3', 'P3', 'T7', 'P7'};
    neighbours(8).label = 'CP3';
    neighbours(8).neighblabel = {'C1', 'P1', 'C5', 'P5'};
    neighbours(9).label = 'CP1';
    neighbours(9).neighblabel = {'Cz', 'Pz', 'C3', 'P3'};


    neighbours(10).label = 'FC6';
    neighbours(10).neighblabel = {'F4', 'C4', 'F8', 'T8'};
    neighbours(11).label = 'FC4';
    neighbours(11).neighblabel = {'F2', 'C2', 'F6', 'C6'};
    neighbours(12).label = 'FC2';
    neighbours(12).neighblabel = {'Fz', 'Cz', 'F4', 'C4'};
    neighbours(13).label = 'C6';
    neighbours(13).neighblabel = {'FC4', 'CP4', 'FT8', 'TP8'};
    neighbours(14).label = 'C4';
    neighbours(14).neighblabel = {'FC2', 'CP2', 'FC6', 'CP6'};
    neighbours(15).label = 'C2';
    neighbours(15).neighblabel = {'FCz', 'CPz', 'FC4', 'CP4'};
    neighbours(16).label = 'CP6';
    neighbours(16).neighblabel = {'C4', 'P4', 'T8', 'P8'};
    neighbours(17).label = 'CP4';
    neighbours(17).neighblabel = {'C2', 'P2', 'C6', 'P6'};
    neighbours(18).label = 'CP2';
    neighbours(18).neighblabel = {'Cz', 'Pz', 'C4', 'P4'};


    cfg = [];
    cfg.method = 'hjorth';
    cfg.elec = data.hdr.elec;
    cfg.trials = 'all';
    cfg.feedback = 'gui';
    cfg.neighbours = neighbours;
    dt2 = ft_scalpcurrentdensity(cfg, data);
    filename = [file.folder '/' '08-avg-csd.mat']
    ft_write_data(filename, dt2, 'dataformat', 'matlab')
end
