restoredefaultpath
addpath('/Users/alam/Documents/MATLAB/fieldtrip-20200607')
addpath('functions/')
addpath('/Users/alam/Documents/MATLAB/eeglab14_1_2b_edited')
ft_defaults

%%
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
output_root = 'data/dataset2/';
subs = dir('data/dataset2/parsed-156/c*');
for k = 1:length(subs)
    sub = subs(k);
    sub = strcat(sub.folder, '/', sub.name);
    subcode = regexp(sub, '/', 'split');
    subcode = subcode{end};
    
    % Ignore alcoholic subjects
    if strcmp(subcode(4), 'a')
       continue 
    end
    fileList = dir(strcat(sub, '/*.csv'));

    % Delete previous subject files
    delList = dir(strcat(output_root, 'set-trials/*.set'));
    for l = 1:length(delList)
      file = delList(l);
      delete(strcat(file.folder, '/', file.name));
    end
    
    % Save trial number info
    f = cell2table(struct2cell(fileList)');
    writetable(f, strcat(output_root, 'raw/trialnum-', subcode, '.csv'));

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

        % Channel locations
        channels = {'AF1', 'AF2', 'AF7', 'AF8', 'AFZ', 'C1', 'C2', 'C3', 'C4', 'C5', 'C6', 'CP1', 'CP2', 'CP3', 'CP4', 'CP5', 'CP6', 'CPZ', 'CZ', 'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'FC1', 'FC2', 'FC3', 'FC4', 'FC5', 'FC6', 'FCZ', 'FP1', 'FP2', 'FPZ', 'FT7', 'FT8', 'FZ', 'O1', 'O2', 'OZ', 'P1', 'P2', 'P3', 'P4', 'P5', 'P6', 'P7', 'P8', 'PO1', 'PO2', 'PO7', 'PO8', 'POZ', 'PZ', 'T7', 'T8', 'TP7', 'TP8', 'X', 'Y', 'nd'};
        for n = 1:size(data,1)
           EEG.chanlocs(n).labels = channels{n};
           EEG.chanlocs(n).type = 'EEG';
        end
        EEG = pop_chanedit(EEG, 'lookup','/Users/alam/Documents/MATLAB/eeglab14_1_2b/plugins/dipfit2.3/standard_BEM/elec/standard_1020.elc');

        % Save raw file
        pop_saveset(EEG, 'filename', strcat(subcode, '-', num2str(trial), '.set'), 'filepath', strcat(output_root, 'set-trials'));
    end

    % Concatenate trials
    fileList = dir(strcat(output_root, 'set-trials/*.set'));
    file = fileList(1);
    EEG = pop_loadset('filename', file.name, 'filepath', file.folder);
    for l = 2:length(fileList)
      file = fileList(l);
      EEG2 = pop_loadset('filename', file.name, 'filepath', file.folder);
      EEG = pop_mergeset(EEG, EEG2);
    end
    EEG = pop_epoch( EEG, {'boundary'}, [-0.9 0], 'newname', 'EEProbe continuous data epochs', 'epochinfo', 'yes');

    % Select 32 channels.
    EEG = pop_select( EEG,'channel',{'C3' 'C4' 'CP3' 'CP4' 'CPZ' 'CZ' 'F3' 'F4' 'F7' 'F8' 'FC3' 'FC4' 'FCZ' 'FP1' 'FP2' 'FT7' 'FT8' 'FZ' 'O1' 'O2' 'OZ' 'P3' 'P4' 'P7' 'P8' 'PZ' 'T7' 'T8' 'TP7' 'TP8'});
    EEG = eeg_checkset( EEG );
    
    % High pass filter
    EEG = pop_eegfiltnew(EEG, 2, 80, [], 0, 0, 0);

    % Raw
    EEGData = EEG.data;
    save(strcat(output_root, 'raw/', subcode, '.mat'), 'EEGData');
    pop_saveset(EEG, 'filename', strcat(subcode, '.set'), 'filepath', strcat(output_root, 'raw'));

    % Raw hjorth
    SaveHjorth(strcat(output_root, 'raw/', subcode, '.set'), strcat(output_root, 'raw-hjorth/', subcode, '.mat'));

    % Clean EEG by running ADJUST
    EEG = pop_runica(EEG, 'icatype', 'runica', 'extended', 1);
    EEG = eeg_checkset( EEG );
    EEG = pop_ADJUST_interface(EEG, 'report.txt');
    EEG = eeg_checkset( EEG );
    rejected = textread('report.txt', '%s', 'delimiter', '\n');
    rejected = rejected{length(rejected)-1};
    if ~isempty(rejected)
        rejected = split(rejected, '  ');
        rejected = cellfun(@str2num, rejected');
        EEG = pop_subcomp( EEG, rejected, 0);
    end

    % Clean raw
    pop_saveset(EEG, 'filename', strcat(subcode, '.set'), 'filepath', strcat(output_root, 'clean'));
    EEGData = EEG.data;
    save(strcat(output_root, 'clean/', subcode, '.mat'), 'EEGData');

    % Clean Hjorth.
    SaveHjorth(strcat(output_root, 'clean/', subcode, '.set'), strcat(output_root, 'clean-hjorth/', subcode, '.mat'));
end
print('Done');
