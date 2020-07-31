

root = "/home/raquib/Desktop/workspaces/mep-classification/data/matlab-powers/raw/";
fileList = dir("/home/raquib/Desktop/workspaces/mep-classification/data/original/*/*/eeg/*/06-clean-prestimulus.set");
for k = 1:length(fileList)
    file = fileList(k);
    segments = regexp(file.folder, '/', 'split');
    subject = segments{9};
    session = segments{10};
    take = segments{12};
    EEG = pop_loadset('filename', file.name,'filepath', file.folder);
    
    % channels:points:epochs
    % EEG = pop_select(EEG, 'channel', {'C3'});

    for epoch = 1:EEG.trials
        c3 = spectopo(EEG.data(15, 1:4095, epoch), 0, EEG.srate, 'freqrange', [4 80], 'plot', 'off');        
        c3 = c3(1:100);
        c4 = spectopo(EEG.data(17, 1:4095, epoch), 0, EEG.srate, 'freqrange', [4 80], 'plot', 'off');        
        c4 = c4(1:100);
        power = [c3' c4'];
        newpath = [root subject '/' session '/' take];
        mkdir(fullfile(root, subject, session, take));
        newpath = [newpath '/trial-' num2str(epoch) '.mat'];
        save(strjoin(newpath, ''), 'power');
    end
end