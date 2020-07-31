fileList = dir("/home/raquib/Desktop/workspaces/mep-classification/data/original/*/*/*/SP 110RMT*/05-clean-prestimulus.set");
length(fileList)
for k = 1:length(fileList)
    file = fileList(k);
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    EEG = pop_loadset('filename', 'raw.set','filepath',file.folder);
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    [EEG erpcom] = pop_currentsourcedensity(EEG)
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off'); 
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset( EEG, 'filename', '06-csd-clean.set', 'filepath',file.folder);
end