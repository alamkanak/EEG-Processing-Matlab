% EEGLAB history file generated on the 13-Aug-2020
% ------------------------------------------------
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_importdata('dataformat','array','nbchan',0,'data','data','srate',256,'pnts',0,'xmin',0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off'); 
EEG = pop_importdata('dataformat','array','nbchan',0,'data','data','srate',256,'pnts',0,'xmin',0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off'); 
EEG = pop_importdata('dataformat','array','nbchan',0,'data','data','srate',256,'pnts',0,'xmin',0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'gui','off'); 
EEG = eeg_checkset( EEG );
EEG = pop_mergeset( ALLEEG, [1  2  3], 0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'gui','off');
EEG = eeg_checkset( EEG );
EEG=pop_chanedit(EEG, 'lookup','/home/raquib/Documents/MATLAB/eeglab2019_0/plugins/dipfit/standard_BESA/standard-10-5-cap385.elp','changefield',{1 'labels' 'AF1'},'changefield',{2 'labels' 'AF2'},'changefield',{3 'labels' 'AF7'},'lookup','/home/raquib/Documents/MATLAB/eeglab2019_0/plugins/dipfit/standard_BEM/elec/standard_1020.elc');
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
eeglab redraw;
