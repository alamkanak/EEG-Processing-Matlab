%%
addpath('/Users/alam/Documents/MATLAB/fieldtrip-20200607')
addpath('functions/')
addpath('/Users/alam/Documents/MATLAB/eeglab14_1_2b_edited')

%%
fileList = dir("data/dataset3/original/*.bdf");
for k = 1:length(fileList)
    file = fileList(k);
    eeglab

    %% Raw EEG.
    EEG = pop_biosig(strcat(file.folder, '/', file.name));
    EEG = eeg_checkset( EEG );
    EEG = eeg_regepochs( EEG, 'recurrence', 1);
    EEG = eeg_checkset( EEG );
    EEG = pop_chanedit(EEG, 'lookup', '/Users/alam/Documents/MATLAB/eeglab14_1_2b/plugins/dipfit2.3/standard_BESA/standard-10-5-cap385.elp','load',{'data/dataset3/locations/EEG_Cat_Locs.ced' 'filetype' 'autodetect'});
    EEG = eeg_checkset( EEG );
    
    % Select 32 channels.
    EEG = pop_select( EEG,'channel',{'C3' 'C4' 'CP3' 'CP4' 'CPZ' 'CZ' 'F3' 'F4' 'F7' 'F8' 'FC3' 'FC4' 'FCZ' 'FP1' 'FP2' 'FT7' 'FT8' 'FZ' 'O1' 'O2' 'OZ' 'P3' 'P4' 'P7' 'P8' 'PZ' 'T7' 'T8' 'TP7' 'TP8'});
    EEG = eeg_checkset( EEG );
    
    % Filter
    EEG = pop_eegfiltnew(EEG, 2, 80, [], 0, 0, 0);
    
    % Save raw
    EEGData = EEG.data;
    save(strcat('data/dataset3/raw/', file.name(1:end-4), '.mat'), 'EEGData');
    pop_saveset(EEG, 'filename', strcat(file.name(1:end-4), '.set'), 'filepath', 'data/dataset3/raw');

    %% Raw Hjorth.
    SaveHjorth(strcat('data/dataset3/raw/', file.name(1:end-4), '.set'), strcat('data/dataset3/raw-hjorth/', file.name(1:end-4), '.mat'));

    %% Clean EEG by running ICA.
    EEG = pop_runica(EEG, 'icatype', 'runica', 'extended', 1);
    EEG = eeg_checkset( EEG );
    EEG = pop_ADJUST_interface( EEG, 'report.txt' );
    EEG = eeg_checkset( EEG );
    rejected = textread('report.txt', '%s', 'delimiter', '\n');    
    rejected = rejected{length(rejected)-1};
    if ~isempty(rejected)
        rejected = split(rejected, '  ');
        rejected = cellfun(@str2num, rejected');
        EEG = pop_subcomp( EEG, rejected, 0);
    end
    
    %% Clean raw.
    EEGData = EEG.data;
    save(strcat('data/dataset3/clean/', file.name(1:end-4), '.mat'), 'EEGData');
    pop_saveset(EEG, 'filename', strcat(file.name(1:end-4), '.set'), 'filepath', 'data/dataset3/clean');

    %%
    % Clean Hjorth.
    SaveHjorth(strcat('data/dataset3/clean/', file.name(1:end-4), '.set'), strcat('data/dataset3/clean-hjorth/', file.name(1:end-4), '.mat'));
end