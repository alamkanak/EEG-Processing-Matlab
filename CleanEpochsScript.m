path = '/home/raquib/Desktop/workspaces/mep-classification/data/original/sub03/exp01/eeg/SP 110RMT r1'
sourceFile = 'Brunet_Sarah_2018-11-29_15-41-19.cnt'
EEG = CleanEpochs(strcat(path, '/', sourceFile))
pop_saveset(EEG, 'filename', 'clean.set', 'filepath', path);
