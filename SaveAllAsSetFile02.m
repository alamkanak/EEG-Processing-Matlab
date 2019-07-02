root = "/home/raquib/Desktop/workspaces/mep_prediction/data/original/";

'/home/raquib/Desktop/workspaces/mep_prediction/data/original/sub01/exp01/eeg/SP 110RMT r1/'

% root = "";
fileList = dir("/home/raquib/Desktop/workspaces/mep_prediction/data/original/*/*/eeg/*/*.cnt");
for k = 1:length(fileList)
    file = fileList(k);
    segments = regexp(file.folder, '/', 'split');
    subject = segments{9};
    session = segments{10};
    take = segments{12};
    [EEG] = pop_loadeep_v4([file.folder '/' file.name]);
    path = char(strjoin([root subject "/" session "/eeg/" take "/"], ''));
    fileName = [file.name(1:end-3) 'set']
    EEG = pop_saveset(EEG, 'filename', fileName, 'filepath', path);
end
fileList