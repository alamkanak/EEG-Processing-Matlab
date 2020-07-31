%%
addpath('/Users/alam/Documents/MATLAB/fieldtrip-20200607')
addpath('functions/')
addpath('/Users/alam/Documents/MATLAB/eeglab14_1_2b_edited')

%%
fileList = dir("/Users/alam/Dropbox (Sydney Uni)/Sydney Research/TMS EEG/MATLAB Pipeline/dataset3/original/*.bdf");
% for k = 1:length(fileList)
file = fileList(1);   
eeglab

%%
% Raw EEG.
EEG = pop_biosig(strcat(file.folder, '/', file.name));
EEG = eeg_checkset( EEG );
EEG = eeg_regepochs( EEG, 'recurrence', 2);
EEG = eeg_checkset( EEG );
EEG = pop_chanedit(EEG, 'lookup', '/Users/alam/Documents/MATLAB/eeglab14_1_2b/plugins/dipfit2.3/standard_BESA/standard-10-5-cap385.elp','load',{'/Users/alam/Dropbox (Sydney Uni)/Sydney Research/TMS EEG/MATLAB Pipeline/dataset3/locations/EEG_Cat_Locs.ced' 'filetype' 'autodetect'});
EEG = eeg_checkset( EEG );
pop_saveset(EEG, 'filename', strcat(file.name(1:end-4), '.set'), 'filepath', 'dataset3/raw');

%%
% Raw Hjorth.
SaveHjorth(strcat('dataset3/raw/', file.name(1:end-4), '.set'), strcat('dataset3/raw-hjorth/', file.name(1:end-4), '.mat'));

%%
% Clean EEG by running ICA.
EEG = pop_runica(EEG, 'icatype', 'runica', 'extended', 1);
EEG = eeg_checkset( EEG );
EEG = pop_ADJUST_interface( EEG, 'report.txt' );
EEG = eeg_checkset( EEG );
rejected = textread('report.txt', '%s', 'delimiter', '\n');
rejected = rejected{45};
rejected = split(rejected, '  ');
rejected = cellfun(@str2num, rejected');
EEG = pop_subcomp( EEG, rejected, 0);
pop_saveset(EEG, 'filename', strcat(file.name(1:end-4), '.set'), 'filepath', 'dataset3/clean');

%%
% Clean Hjorth.
SaveHjorth(strcat('dataset3/clean/', file.name(1:end-4), '.set'), strcat('dataset3/clean-hjorth/', file.name(1:end-4), '.mat'));
% end