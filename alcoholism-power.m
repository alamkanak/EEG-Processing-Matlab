
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
root = "/home/raquib/Desktop/workspaces/mep-classification/data/alcoholism-02-for-matlab/";
fileList = dir("/home/raquib/Desktop/workspaces/mep-classification/data/alcoholism-02-for-matlab/*/*.csv");
for k = 1:length(fileList)
    file = fileList(k);
    segments = regexp(file.folder, '/', 'split');
    subject = segments{9};
    trial = segments{10};
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
    EEG=pop_chanedit(EEG, 'lookup','/Users/alam/Documents/MATLAB/eeglab14_1_2b/plugins/dipfit2.3/standard_BESA/standard-10-5-cap385.elp','load',{'/Users/alam/Dropbox (Sydney Uni)/Sydney Research/TMS EEG/TESA/VoltageMaps/newlocation-alcohol.ced' 'filetype' 'autodetect'});
    EEG = eeg_checkset( EEG );
    
    % Save file
    pop_saveset(EEG, 'filename', 'eeg.set', 'filepath', file.folder);

    % Convert to hjorth
    filename = [file.folder '/eeg.set'];
    cfg = [];
    cfg.datafile = filename;
    cfg.headerfile = filename;
    [data] = ft_preprocessing(cfg)
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
    filename = [file.folder 'hjorth.mat']
    ft_write_data(filename, dt2, 'dataformat', 'matlab') 
end

%%
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
data = csvread('/Users/alam/Downloads/trial-1.csv', 1, 1);
data = data';

%%
EEG = pop_importdata('dataformat','array','nbchan',0,'data','data','srate',256,'pnts',0,'xmin',0);
EEG = eeg_checkset( EEG );

%%
channels = {'C3', 'FC1', 'CP1', 'FC5', 'CP5', 'C4', 'FC2', 'CP2', 'FC6', 'CP6'};
for n = 1:size(data,1)
   EEG.chanlocs(n).label = channels{n};
end
EEG = eeg_checkset( EEG );

%%
EEG=pop_chanedit(EEG, 'lookup','/Users/alam/Documents/MATLAB/eeglab14_1_2b/plugins/dipfit2.3/standard_BESA/standard-10-5-cap385.elp','load',{'/Users/alam/Dropbox (Sydney Uni)/Sydney Research/TMS EEG/TESA/VoltageMaps/newlocation-alcohol.ced' 'filetype' 'autodetect'});
EEG = eeg_checkset( EEG );

%%
pop_saveset(EEG, 'filename', 'clean.set');