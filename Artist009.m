%%
% x = '456'
% addpath(genpath('/home/raquib/Documents/MATLAB'))
% y='458'

%% 
paths = [
%     "data/original/sub02/exp01/eeg/SP 110RMT r1",
%     "data/original/sub02/exp01/eeg/SP 110RMT r2",
%     "data/original/sub02/exp01/eeg/SP 110RMT r3",
%     "data/original/sub03/exp03/eeg/SP 110RMT r1",
%     "data/original/sub03/exp03/eeg/SP 110RMT r2",
%     "data/original/sub03/exp03/eeg/SP 110RMT r3",
%     "data/original/sub04/exp02/eeg/SP 110RMT r1",
%     "data/original/sub04/exp02/eeg/SP 110RMT r2",
%     "data/original/sub04/exp02/eeg/SP 110RMT r3",
%     "data/original/sub05/exp02/eeg/SP 110RMT r1",
    "data/original/sub05/exp02/eeg/SP 110RMT r2",
    "data/original/sub05/exp02/eeg/SP 110RMT r3",
    "data/original/sub06/exp01/eeg/SP 110RMT r1",
    "data/original/sub06/exp01/eeg/SP 110RMT r2",
    "data/original/sub06/exp01/eeg/SP 110RMT r3",
    "data/original/sub07/exp01/eeg/SP 110RMT r1",
    "data/original/sub07/exp01/eeg/SP 110RMT r2",
    "data/original/sub07/exp01/eeg/SP 110RMT r3",
    "data/original/sub08/exp03/eeg/SP 110RMT r1",
    "data/original/sub08/exp03/eeg/SP 110RMT r2",
    "data/original/sub08/exp03/eeg/SP 110RMT r3",
    "data/original/sub10/exp02/eeg/SP 110RMT r1",
    "data/original/sub10/exp02/eeg/SP 110RMT r2",
    "data/original/sub10/exp02/eeg/SP 110RMT r3",
    "data/original/sub12/exp03/eeg/SP 110RMT r1",
    "data/original/sub12/exp03/eeg/SP 110RMT r2",
    "data/original/sub12/exp03/eeg/SP 110RMT r3",
    "data/original/sub13/exp02/eeg/SP 110RMT r1",
    "data/original/sub13/exp02/eeg/SP 110RMT r2",
    "data/original/sub13/exp02/eeg/SP 110RMT r3",
    "data/original/sub15/exp01/eeg/SP 110RMT r1",
    "data/original/sub15/exp01/eeg/SP 110RMT r2",
    "data/original/sub15/exp01/eeg/SP 110RMT r3",
    "data/original/sub16/exp01/eeg/SP 110RMT r1",
    "data/original/sub16/exp01/eeg/SP 110RMT r2",
    "data/original/sub16/exp01/eeg/SP 110RMT r3",
    "data/original/sub17/exp01/eeg/SP 110RMT r1",
    "data/original/sub17/exp01/eeg/SP 110RMT r2",
    "data/original/sub17/exp01/eeg/SP 110RMT r3",
    "data/original/sub18/exp01/eeg/SP 110RMT r1",
    "data/original/sub18/exp01/eeg/SP 110RMT r2",
    "data/original/sub18/exp01/eeg/SP 110RMT r3",
    "data/original/sub19/exp01/eeg/SP 110RMT r1",
    "data/original/sub19/exp01/eeg/SP 110RMT r2",
    "data/original/sub19/exp01/eeg/SP 110RMT r3",
    "data/original/sub20/exp01/eeg/SP 110RMT r1",
    "data/original/sub20/exp01/eeg/SP 110RMT r2",
    "data/original/sub20/exp01/eeg/SP 110RMT r3",
    "data/original/sub21/exp01/eeg/SP 110RMT r1",
    "data/original/sub21/exp01/eeg/SP 110RMT r2",
    "data/original/sub21/exp01/eeg/SP 110RMT r3",
    "data/original/sub22/exp01/eeg/SP 110RMT r1",
    "data/original/sub22/exp01/eeg/SP 110RMT r2",
    "data/original/sub22/exp01/eeg/SP 110RMT r3"];

%%
for k = 1:length(paths)
    try
        disp(paths(k))
        filelist = dir(strcat('/home/raquib/Desktop/workspaces/mep-classification/', paths(k), '/*.cnt'));
        file = filelist(1);

        [EEG] = pop_loadeep_v4([file.folder '/' file.name]);
        EEG = pop_chanedit(EEG, 'load', {'/home/raquib/Dropbox (Sydney Uni)/Sydney Research/TMS EEG/TESA/VoltageMaps/newlocation2.ced' 'filetype' 'autodetect'},'changefield',{64 'datachan' 0},'changefield',{64 'datachan' 1});

        cfg = [];
        cfg.EventCode = '1';
        cfg.TMSEEGrootFolder = '/home/raquib/Desktop/workspaces/tmseeg-tesa-script/artist-results';
        cfg.plottimes = [15,25,40,60,75,100,150,200,300];
        cfg.TrialEnd = 1000;
        [EEG2, badtrials] = ARTISTMain(EEG, cfg);

        EEG = pop_saveset(EEG2, 'filename', '009-artist-noresample.set', 'filepath', file.folder);
        dlmwrite(strcat(file.folder, '/009-artist-bad-trials-noresample.txt'), badtrials)
    catch
        warning(strcat('Error in ', paths(k)))
        disp('Error')
    end
end

%%
finish = 'fff'