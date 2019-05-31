root = "Clean";
fileList = dir("/Users/alam/Desktop/TMSEEG-Data/Recordings/02 SP Only/*/*/*/SP 110RMT*/*.cnt");

completed = {
%     ['BaedonTerry' 'SP 110RMT r1'], 
%     ['BaedonTerry' 'SP 110RMT r2'], 
%     ['BaedonTerry' 'SP 110RMT r3'],
%     ['BrunetSarah' 'SP 110RMT r1'], 
%     ['BrunetSarah' 'SP 110RMT r2'], 
%     ['BrunetSarah' 'SP 110RMT r3'], 
%     ['DavidBrown' 'SP 110RMT r1'],
%     ['DavidBrown' 'SP 110RMT r2'],
%     ['DavidBrown' 'SP 110RMT r3']
};

for k = 1:length(fileList)
    file = fileList(k);
    segments = regexp(file.folder, '/', 'split');
    subject = segments{8};
    session = segments{9};
    take = segments{11};
    if ismember([subject take], completed)
        continue
    end
    ['Cleaning EEG of ' subject '/' session '/' take]
    EEG = CleanEeg([file.folder '/' file.name]);
    path = char(strjoin([root '/' subject "/" session "/" take "/"], ''));
    mkdir(path)
    EEG = pop_saveset(EEG, 'filename', 'eeg.set', 'filepath', path);
end