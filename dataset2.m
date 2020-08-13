restoredefaultpath
addpath /home/raquib/Documents/MATLAB/fieldtrip-20191025
addpath /home/raquib/Documents/MATLAB/eeglab2019_0
addpath /home/raquib/Documents/MATLAB/FastICA_25
ft_defaults

%%
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
output_root = "/home/raquib/Desktop/workspaces/mep-classification/data/dataset2/";
subs = dir("/home/raquib/Desktop/workspaces/mep-classification/data/dataset2/original/*/");
for k = 1:length(subs)
    sub = subs(k);
    subcode = regexp(sub, '/', 'split');
    subcode = subcode{5};
    fileList = dir(strcat(sub, '*.csv'));
    for l = 1:length(fileList)
        file = fileList(l);
        segments = regexp(file.folder, '/', 'split');
        subject = segments{5};
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
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, l-1,'gui','off');
    end     
    
    EEG = eeg_checkset( EEG );
    EEG = pop_mergeset( ALLEEG, [1:length(fileList)], 0);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, length(fileList)+1, 'gui','off');   
    
    % Set channel labels
    channels = {'AF1', 'AF2', 'AF7', 'AF8', 'AFZ', 'C1', 'C2', 'C3', 'C4', 'C5', 'C6', 'CP1', 'CP2', 'CP3', 'CP4', 'CP5', 'CP6', 'CPZ', 'CZ', 'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'FC1', 'FC2', 'FC3', 'FC4', 'FC5', 'FC6', 'FCZ', 'FP1', 'FP2', 'FPZ', 'FT7', 'FT8', 'FZ', 'O1', 'O2', 'OZ', 'P1', 'P2', 'P3', 'P4', 'P5', 'P6', 'P7', 'P8', 'PO1', 'PO2', 'PO7', 'PO8', 'POZ', 'PZ', 'T7', 'T8', 'TP7', 'TP8', 'X', 'Y', 'nd'};
    for n = 1:size(data,1)
       EEG.chanlocs(n).label = channels{n};
    end
    EEG = eeg_checkset( EEG );

    % Read channel locations
    EEG = pop_chanedit(EEG, 'lookup','/Users/alam/Documents/MATLAB/eeglab14_1_2b/plugins/dipfit2.3/standard_BEM/elec/standard_1020.elc');
    EEG = eeg_checkset( EEG );
    
    % Epoch
    EEG = eeg_regepochs( EEG, 'recurrence', 1);
    EEG = eeg_checkset( EEG );
    
    % Save file
    pop_saveset(EEG, 'filename', strcat(subcode, '.set'), 'filepath', strcat(output_root, 'raw'));

    % Convert to hjorth
    SaveHjorth(strcat(output_root, 'raw', subcode, '.set'), strcat('/home/raquib/Desktop/workspaces/mep-classification/data/dataset2/raw-hjorth/', subcode, '.mat'));
    
    % Clean EEG by running ADJUST.
    EEG = pop_runica(EEG, 'icatype', 'runica', 'extended', 1);
    EEG = eeg_checkset( EEG );
    EEG = pop_ADJUST_interface(EEG, 'report.txt');
    EEG = eeg_checkset( EEG );
    rejected = textread('report.txt', '%s', 'delimiter', '\n');
    rejected = rejected{45};
    rejected = split(rejected, '  ');
    rejected = cellfun(@str2num, rejected');
    EEG = pop_subcomp( EEG, rejected, 0);
    pop_saveset(EEG, 'filename', strcat(subcode, '.set'), 'filepath', strcat(output_root, 'clean'));
    
    % Cleaned Hjorth.
    SaveHjorth(strcat(output_root, 'clean', subcode, '.set'), strcat('/home/raquib/Desktop/workspaces/mep-classification/data/dataset2/clean-hjorth/', subcode, '.mat'));
end
print('Done');

