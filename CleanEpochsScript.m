% path = '/home/raquib/Desktop/workspaces/mep-classification/data/original/sub05/exp01/eeg/SP 110RMT r3'
% sourceFile = 'Gallaty_Lynette_2018-12-14_12-26-18.cnt'

[file,path] = uigetfile('/home/raquib/Desktop/workspaces/mep-classification/data/original/*.cnt', 'Select a CNT file');
if isequal(file,0)
   disp('User selected Cancel');
else
    disp(['User selected ', fullfile(path, file)]);
    EEG = CleanEpochs(strcat(path, '/', file))
    pop_saveset(EEG, 'filename', 'clean.set', 'filepath', path);
end
