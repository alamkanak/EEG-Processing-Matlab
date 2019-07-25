function EEG = CleanPreStimulusEeg(filePath)
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    [EEG] = pop_loadeep_v4(filePath);

    % Remember channels to use later when interpolating bad channels
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, 1);

    % Reject channels
    EEG = pop_rejchan(EEG, 'elec', [1:size(EEG.data,1)],'threshold',5,'norm','on','measure','kurt');

    % Epoch data
    EEG = pop_epoch( EEG, {  '1'  }, [-1  0], 'newname', 'EEProbe continuous data epochs', 'epochinfo', 'yes');
    EEG = pop_rmbase( EEG, [-1000 0]);

    % Resample
    EEG = pop_resample( EEG, 1000);

    % Remove bad epochs
    EEG = pop_jointprob(EEG,1,[1:size(EEG.data,1)],5,5,0,0);
    EEG = eeg_rejsuperpose( EEG, 1, 1, 1, 1, 1, 1, 1, 1);
    EEG.BadTr = unique([find(EEG.reject.rejjp==1) find(EEG.reject.rejmanual==1)]);
    EEG = pop_rejepoch( EEG, EEG.BadTr, 0);

    % Apply filters
    EEG = pop_tesa_filtbutter( EEG, 1, 40, 4, 'bandpass' );
    EEG = pop_tesa_filtbutter( EEG, 48, 52, 4, 'bandstop' );
    
    % Remove this
    EEG = pop_tesa_fastica( EEG, 'approach', 'symm', 'g', 'tanh', 'stabilization', 'off' );
    EEG = pop_tesa_compselect( EEG,'compCheck','on','comps', 19, 'figSize', 'medium', 'plotTimeX',[-700 -2],'plotFreqX',[1 100],'tmsMuscle','off','tmsMuscleThresh',8,'tmsMuscleWin',[11 30],'tmsMuscleFeedback','off','blink','on','blinkThresh',2.5,'blinkElecs',{'Fp1','Fp2'},'blinkFeedback','off','move','on','moveThresh',2,'moveElecs',{'F7','F8'},'moveFeedback','off','muscle','on','muscleThresh',0.6,'muscleFreqWin',[30 100],'muscleFeedback','off','elecNoise','on','elecNoiseThresh',4,'elecNoiseFeedback','off');

    % Interpolate missing/bad channels
    EEG = pop_interp(EEG, ALLEEG(1).chanlocs, 'spherical');

    % Rereference to average.
    EEG = pop_reref(EEG, []);
end

