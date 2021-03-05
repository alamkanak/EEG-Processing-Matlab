% EEGLAB history file generated on the 25-Sep-2020
% ------------------------------------------------

EEG.etc.eeglabvers = '14.1.2'; % this tracks which version of EEGLAB is being used, you may ignore it
EEG = pop_loadset('filename','co2a0000433.set','filepath','/Users/alam/Desktop/workspaces/tmseeg-matlab/data/dataset2/raw/');
EEG = eeg_checkset( EEG );
EEG = pop_eegfiltnew(EEG, [],2,424,1,[],1);
EEG = eeg_checkset( EEG );
