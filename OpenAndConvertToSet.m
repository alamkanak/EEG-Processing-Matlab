%% Load file
[file,path] = uigetfile('/home/raquib/Desktop/workspaces/mep-classification/data/original/*.cnt', 'Select a CNT file to convert to SET');
if isequal(file,0)
   disp('User selected Cancel');
else
    disp(['User selected ', fullfile(path, file)]);
    [EEG] = pop_loadeep_v4([path '/' file]);
    EEG = pop_chanedit(EEG, 'load', {'/home/raquib/Dropbox (Sydney Uni)/Sydney Research/TMS EEG/TESA/VoltageMaps/newlocation2.ced' 'filetype' 'autodetect'},'changefield',{64 'datachan' 0},'changefield',{64 'datachan' 1});
    
    try
        EEG = pop_epoch( EEG, {  '1'  }, [-1  1], 'newname', 'EEProbe continuous data epochs', 'epochinfo', 'yes');
        EEG = pop_rmbase( EEG, [-1000 0]);
        EEG = pop_saveset( EEG, 'filename', 'raw.set', 'filepath', path);
        disp(path);
    catch
        warning('Could not process')
    end
end
