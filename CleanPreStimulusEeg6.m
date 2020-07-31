function EEG = CleanPreStimulusEeg6(filePath, lowPassCutOff)
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    [EEG] = pop_loadeep_v4(filePath);
    endTime = 0 % in milliseconds

    % Remember channels to use later when interpolating bad channels
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, 1);

    % Channel locations
    EEG = pop_chanedit(EEG, 'load', {'/home/raquib/Dropbox (Sydney Uni)/Sydney Research/TMS EEG/TESA/VoltageMaps/newlocation2.ced' 'filetype' 'autodetect'},'changefield',{64 'datachan' 0},'changefield',{64 'datachan' 1});

    % Reject channels
    EEG = pop_rejchan(EEG, 'elec', [1:size(EEG.data, 1)], 'threshold', 5,'norm', 'on', 'measure', 'kurt');

    % Epoch data
    EEG = pop_epoch( EEG, {  '1'  }, [-1  1], 'newname', 'EEProbe continuous data epochs', 'epochinfo', 'yes');
    EEG = pop_rmbase( EEG, [-1000 -5]);
    
    % Save "before" plot.
    figure
    pop_timtopo(EEG, [-1000 endTime-1], [NaN], 'Before ICA #1');
    [path, ~, ~] = fileparts(filePath);
    saveas(gcf, strcat(path, '/', '06-before.png'))
    
    % Remove TMS Pulse Artefact + Reinterprolate for better Resampling
    EEG = pop_tesa_removedata( EEG, [-2 400] );
    EEG = pop_constant_data( EEG, [-2, 400] );

    % Resample
    EEG = pop_resample( EEG, 2048);
     
    % Fast ICA #2
    EEG = pop_tesa_fastica( EEG, 'approach', 'symm', 'g', 'tanh', 'stabilization', 'off' );
    EEG = pop_tesa_compselect( EEG,'compCheck','on','comps', 15, 'figSize', 'medium', 'plotTimeX', [-1000 endTime-2],'plotFreqX',[1 100],'tmsMuscle','off','tmsMuscleThresh',8,'tmsMuscleWin',[11 30],'tmsMuscleFeedback','off','blink','on','blinkThresh',2.5,'blinkElecs',{'Fp1','Fp2'},'blinkFeedback','off','move','on','moveThresh',2,'moveElecs',{'F7','F8'},'moveFeedback','off','muscle','on','muscleThresh',0.6,'muscleFreqWin',[30 100],'muscleFeedback','off','elecNoise','on','elecNoiseThresh',4,'elecNoiseFeedback','off');

    % Interpolate missing/bad channels
    EEG = pop_interp(EEG, ALLEEG(1).chanlocs, 'spherical');

    % Rereference to average.
    EEG = pop_reref(EEG, []);
    
    % Save image file.
    figure
    pop_timtopo(EEG, [-1000 endTime-1], [NaN], 'Final')
    saveas(gcf, strcat(path, '/', '06-after.png'))
    
    % Plot stacked channels.
    pop_eegplot( EEG, 1, 1, 1);
end