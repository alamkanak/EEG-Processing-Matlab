root = "/home/raquib/Desktop/workspaces/mep-classification/data/original/";

% root = "";
fileList = dir("/home/raquib/Desktop/workspaces/mep-classification/data/original/*/*/eeg/*/*.cnt");
for k = 1:length(fileList)
    file = fileList(k);
    segments = regexp(file.folder, '/', 'split');
    subject = segments{9};
    session = segments{10};
    take = segments{12};
    [EEG] = pop_loadeep_v4([file.folder '/' file.name]);
    
    % Load channel locations.
    EEG = pop_chanedit(EEG, 'load', {'/home/raquib/Dropbox (Sydney Uni)/Sydney Research/TMS EEG/TESA/VoltageMaps/newlocation2.ced' 'filetype' 'autodetect'},'changefield',{64 'datachan' 0},'changefield',{64 'datachan' 1});
    
    % Epoch dataset.
    try
        EEG = pop_epoch( EEG, {  '1'  }, [-1  1], 'newname', 'EEProbe continuous data epochs', 'epochinfo', 'yes');
        EEG = pop_rmbase( EEG, [-1000 0]);

        path = char(strjoin([root subject "/" session "/eeg/" take "/"], ''));
        % fileName = [file.name(1:end-3) 'set']
        fileName = 'raw.set';
        EEG = pop_saveset(EEG, 'filename', fileName, 'filepath', path);
    catch
        warning(['Could not process ' file.folder])
    end
end
fileList