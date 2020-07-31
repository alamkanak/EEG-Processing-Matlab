
restoredefaultpath
addpath /home/raquib/Documents/MATLAB/fieldtrip-20191025
addpath /home/raquib/Documents/MATLAB/eeglab2019_0
addpath /home/raquib/Documents/MATLAB/FastICA_25
ft_defaults

%%
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
root = "/home/raquib/Desktop/workspaces/mep-classification/data/alcoholism-02-for-matlab/";
fileList = dir("/home/raquib/Desktop/workspaces/mep-classification/data/alcoholism-02-for-matlab/*/*.csv");
for k = 1:length(fileList)
    file = fileList(k);
    segments = regexp(file.folder, '/', 'split');
    subject = segments{9};
    trial = file.name;
    trial = regexp(trial, '-', 'split');
    trial = trial{2};
    trial = regexp(trial, '\.', 'split');
    trial = trial{1};
    trial = str2num(trial);
    
    % Read csv file
    data = csvread([file.folder '/' file.name], 1, 1);
    data = data';
    
    % Convert to eeglab
    EEG = pop_importdata('dataformat','array','nbchan',0,'data','data','srate',256,'pnts',0,'xmin',0);
    EEG = eeg_checkset( EEG );
  
    % Set channel labels
    channels = {'C3', 'FC6', 'FC4', 'FC2', 'C6', 'C4', 'C2', 'CP6', 'CP4', 'CP2', 'FC5', 'FC3', 'FC1', 'C5', 'C1', 'CP5', 'CP3', 'CP1'};
    for n = 1:size(data,1)
       EEG.chanlocs(n).label = channels{n};
    end
    EEG = eeg_checkset( EEG );

    % Read channel locations
    EEG=pop_chanedit(EEG, 'lookup','/home/raquib/Documents/eeglab14_1_1b/plugins/dipfit2.3/standard_BESA/standard-10-5-cap385.elp','load',{'/home/raquib/Dropbox (Sydney Uni)/Sydney Research/TMS EEG/TESA/VoltageMaps/newlocation-alcohol.ced' 'filetype' 'autodetect'});
    EEG = eeg_checkset( EEG );
    
    % Save file
    pop_saveset(EEG, 'filename', 'eeg.set', 'filepath', file.folder);

    % Convert to hjorth
    filename = [file.folder '/eeg.set'];
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
    
    % Save mat file
    trial = file.name;
    trial = regexp(trial, '-', 'split');
    trial = trial{2};
    trial = regexp(trial, '\.', 'split');
    trial = trial{1};
    trial = str2num(trial);
    
    filename = file.name;
    filename = regexp(filename, '\.', 'split');
    filename = filename{1};
    filename = [file.folder '/' filename '-hjorth.mat'];
    ft_write_data(filename, dt2, 'dataformat', 'matlab');
end
print('Done');


%%
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
data = csvread('/home/raquib/Desktop/workspaces/mep-classification/data/alcoholism-02-for-matlab/co2a0000369/trial-9.csv', 1, 1);
data = data';

%%
EEG = pop_importdata('dataformat','array','nbchan',0,'data','data','srate',256,'pnts',0,'xmin',0);
EEG = eeg_checkset( EEG );

%%
channels = {'C3', 'FC6', 'FC4', 'FC2', 'C6', 'C4', 'C2', 'CP6', 'CP4', 'CP2', 'FC5', 'FC3', 'FC1', 'C5', 'C1', 'CP5', 'CP3', 'CP1'};
for n = 1:size(data,1)
   EEG.chanlocs(n).label = channels{n};
end
EEG = eeg_checkset( EEG );

%%
EEG=pop_chanedit(EEG, 'lookup','/home/raquib/Documents/eeglab14_1_1b/plugins/dipfit2.3/standard_BESA/standard-10-5-cap385.elp','load',{'/home/raquib/Dropbox (Sydney Uni)/Sydney Research/TMS EEG/TESA/VoltageMaps/newlocation-alcohol.ced' 'filetype' 'autodetect'});
EEG = eeg_checkset( EEG );

%%
pop_saveset(EEG, 'filename', 'clean.set');

%%
filename = '/home/raquib/Desktop/workspaces/mep-classification/data/original/sub06/exp02/eeg/SP 110RMT r1/06-clean-prestimulus.set';
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
