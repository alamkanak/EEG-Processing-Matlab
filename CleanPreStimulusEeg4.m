function EEG = CleanPreStimulusEeg2(filePath, lowPassCutOff)
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    [EEG] = pop_loadeep_v4(filePath);
    endTime = -20 % in milliseconds

    % Remember channels to use later when interpolating bad channels
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, 1);

    % Channel locations
    EEG = pop_chanedit(EEG, 'load', {'/home/raquib/Dropbox (Sydney Uni)/Sydney Research/TMS EEG/TESA/VoltageMaps/newlocation2.ced' 'filetype' 'autodetect'},'changefield',{64 'datachan' 0},'changefield',{64 'datachan' 1});

    % Reject channels
    EEG = pop_rejchan(EEG, 'elec', [1:size(EEG.data, 1)], 'threshold', 5,'norm', 'on', 'measure', 'kurt');

    % Epoch data
    EEG = pop_epoch( EEG, {  '1'  }, [-1  endTime/1000], 'newname', 'EEProbe continuous data epochs', 'epochinfo', 'yes');
    EEG = pop_rmbase( EEG, [-1000 endTime-1]);
    
    % Save "before" plot.
    figure
    pop_timtopo(EEG, [-1000 endTime-1], [NaN]);
    [path, ~, ~] = fileparts(filePath);
    saveas(gcf, strcat(path, '/', 'before.png'))

    % Resample
    EEG = pop_resample( EEG, 2048);

    % Remove bad epochs
%     try
%         EEG = pop_jointprob(EEG, 1, [1:size(EEG.data,1)], 5, 5, 0, 0);
%         EEG = eeg_rejsuperpose( EEG, 1, 1, 1, 1, 1, 1, 1, 1);
%         EEG.BadTr = unique([find(EEG.reject.rejjp==1) find(EEG.reject.rejmanual==1)]);
%         EEG = pop_rejepoch( EEG, EEG.BadTr, 0);
%     catch
%         uiwait(msgbox('Could not remove bad epochs', 'Warning', 'warn'));
%     end
    
    % Fast ICA #1
    % EEG = pop_tesa_fastica( EEG, 'approach', 'symm', 'g', 'tanh', 'stabilization', 'off' );
    % EEG = pop_tesa_compselect( EEG, 'compCheck', 'on', 'comps', 9, 'figSize', 'medium','plotTimeX',[-800 endTime-2],'plotFreqX',[1 100],'tmsMuscle','off','tmsMuscleThresh',8,'tmsMuscleWin',[11 30],'tmsMuscleFeedback','off','blink','off','blinkThresh',2.5,'blinkElecs',{'Fp1','Fp2'},'blinkFeedback','off','move','off','moveThresh',2,'moveElecs',{'F7','F8'},'moveFeedback','off','muscle','off','muscleThresh',0.6,'muscleFreqWin',[30 100],'muscleFeedback','off','elecNoise','off','elecNoiseThresh',4,'elecNoiseFeedback','off' );

    % Apply filters
    % EEG = pop_tesa_filtbutter( EEG, 1, 100, 4, 'bandpass' );
    EEG = pop_tesa_filtbutter( EEG, 1, lowPassCutOff, 4, 'bandpass' );
    EEG = pop_tesa_filtbutter( EEG, 48, 52, 4, 'bandstop' );
    
    % Fast ICA #2
    EEG = pop_tesa_fastica( EEG, 'approach', 'symm', 'g', 'tanh', 'stabilization', 'off' );
    EEG = pop_tesa_compselect( EEG,'compCheck','on','comps', 15, 'figSize', 'medium', 'plotTimeX', [-800 endTime-2],'plotFreqX',[1 100],'tmsMuscle','off','tmsMuscleThresh',8,'tmsMuscleWin',[11 30],'tmsMuscleFeedback','off','blink','on','blinkThresh',2.5,'blinkElecs',{'Fp1','Fp2'},'blinkFeedback','off','move','on','moveThresh',2,'moveElecs',{'F7','F8'},'moveFeedback','off','muscle','on','muscleThresh',0.6,'muscleFreqWin',[30 100],'muscleFeedback','off','elecNoise','on','elecNoiseThresh',4,'elecNoiseFeedback','off');

    % Interpolate missing/bad channels
    EEG = pop_interp(EEG, ALLEEG(1).chanlocs, 'spherical');

    % Rereference to average.
    EEG = pop_reref(EEG, []);
    
    % Save image file.
    figure
    pop_timtopo(EEG, [-1000 endTime-1], [NaN])
    saveas(gcf, strcat(path, '/', 'after.png'))
end

