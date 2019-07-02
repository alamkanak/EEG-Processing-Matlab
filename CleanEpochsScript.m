path = '/Users/alam/Desktop/VisualStudioWorkspaces/mep-classification/data/original/sub01/exp01/eeg/SP 110RMT r3'
sourceFile = 'Terry_Baedon_2019-02-22_15-26-48.cnt'
EEG = CleanEpochs(strcat(path, '/', sourceFile))
pop_saveset(EEG, 'filename', 'clean.set', 'filepath', path);
