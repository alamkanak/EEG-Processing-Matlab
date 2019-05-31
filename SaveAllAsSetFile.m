% root = "/Users/alam/Desktop/TMSEEG-Data/Recordings SET/";
root = "";
fileList = dir("/Users/alam/Desktop/TMSEEG-Data/Recordings SP Only/*/*/*/SP 110RMT*/*.cnt");
for k = 1:length(fileList)
    file = fileList(k);
    segments = regexp(file.folder, '/', 'split');
    subject = segments{7};
    session = segments{8};
    take = segments{10};
    [EEG] = pop_loadeep_v4([file.folder '/' file.name]);
    path = char(strjoin([root subject "/" session "/" take "/"], ''));
    mkdir(path)
    EEG = pop_saveset(EEG, 'filename', 'eeg.set', 'filepath', path);
end