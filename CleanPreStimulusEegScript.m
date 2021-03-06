%%
% path = '/home/raquib/Desktop/workspaces/mep-classification/data/original/sub05/exp01/eeg/SP 110RMT r3'
% sourceFile = 'Gallaty_Lynette_2018-12-14_12-26-18.cnt'
restoredefaultpath
addpath /home/raquib/Documents/MATLAB/fieldtrip-20191025
addpath /home/raquib/Documents/MATLAB/eeglab2019_0
addpath /home/raquib/Documents/MATLAB/FastICA_25
ft_defaults

%%
[file,path] = uigetfile('/home/raquib/Desktop/workspaces/mep-classification/data/original/*.cnt', 'Select a CNT file');
if isequal(file,0)
   disp('User selected Cancel');
else
    disp(['User selected ', fullfile(path, file)]);
    EEG = CleanPreStimulusEeg6(strcat(path, '/', file), 100);
    
    % Save file.
    pop_saveset(EEG, 'filename', '06-clean-prestimulus.set', 'filepath', path);
    disp(['Saved in ', path]);
    
    % CSD Type #1.
%     [EEG erpcom] = pop_currentsourcedensity(EEG)
%     [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off'); 
%     EEG = eeg_checkset( EEG );
%     EEG = pop_saveset( EEG, 'filename', '06-clean-prestimulus-csd.set', 'filepath', path);
    
    % Hjorth.
    filename = [path '/06-clean-prestimulus.set'];
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
    filename = [path '06-clean-prestimulus-hjorth.mat']
    ft_write_data(filename, dt2, 'dataformat', 'matlab')
end