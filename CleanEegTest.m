
% Load file
% filePath = '/Users/alam/Desktop/TMSEEG-Data/Recordings/02 SP Only/BaedonTerry/MNDTMSEEG2019022TB/EEG/SP 110RMT r1/Terry_Baedon_2019-02-22_14-53-19.cnt'
filePath = '/Users/alam/Desktop/TMSEEG-Data/Recordings/02 SP Only/BaedonTerry/MNDTMSEEG2019022TB/EEG/SP 110RMT r2/Terry_Baedon_2019-02-22_15-20-07.cnt'
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
[EEG] = pop_loadeep_v4(filePath);

% Find pulse, epoch, resample and remove bad data
% Find TMS pulse
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, 1);

% Channel Rejection
EEG = pop_rejchan(EEG, 'elec', [1:size(EEG.data,1)],'threshold',5,'norm','on','measure','kurt');

% Epoch Data
EEG = pop_epoch( EEG, {  '1'  }, [-1  1], 'newname', 'EEProbe continuous data epochs', 'epochinfo', 'yes');
EEG = pop_rmbase( EEG, [-1000  1000]);

% Remove TMS Pulse Artefact + Reinterprolate for better Resampling
EEG = pop_tesa_removedata( EEG, [-2 10] );
EEG = pop_tesa_interpdata( EEG, 'cubic', [1 1] );

% EEG Resample
EEG = pop_resample( EEG, 1000);

% Remove Bad Trials
EEG = pop_jointprob(EEG,1,[1:size(EEG.data,1)],5,5,0,0);
% EEG = pop_jointprob(EEG,1,[1:63] ,5,5,0,0,0,[],0);
EEG = eeg_rejsuperpose( EEG, 1, 1, 1, 1, 1, 1, 1, 1);
EEG.BadTr = unique([find(EEG.reject.rejjp==1) find(EEG.reject.rejmanual==1)]);
EEG = pop_rejepoch( EEG, EEG.BadTr ,0);
% EEG = pop_rejepoch( EEG, [3 4 6 25 26] ,0);

% ICA component Removal First Pass
% Preparation for FastICA First Pass
% Remove TMS Pulse Artefact + Replace with Constant Amp. Data
EEG = pop_tesa_removedata( EEG, [-2 10] );
EEG = pop_tesa_fastica( EEG, 'approach', 'symm', 'g', 'tanh', 'stabilization', 'off' );

% ICA Component Selection
EEG = pop_tesa_compselect( EEG,'compCheck','on','comps',9,'figSize','small','plotTimeX',[-200 500],'plotFreqX',[1 100],'tmsMuscle','on','tmsMuscleThresh',8,'tmsMuscleWin',[11 30],'tmsMuscleFeedback','off','blink','off','blinkThresh',2.5,'blinkElecs',{'Fp1','Fp2'},'blinkFeedback','off','move','off','moveThresh',2,'moveElecs',{'F7','F8'},'moveFeedback','off','muscle','off','muscleThresh',0.6,'muscleFreqWin',[30 100],'muscleFeedback','off','elecNoise','off','elecNoiseThresh',4,'elecNoiseFeedback','off' );

% Remove TMS Pulse Artefact + Interprolate for Bandpass filter
EEG = pop_tesa_removedata( EEG, [-2 15] );
EEG = pop_tesa_interpdata( EEG, 'cubic', [5 5] );
EEG = pop_tesa_filtbutter( EEG, 1, 100, 4, 'bandpass' );
EEG = pop_tesa_filtbutter( EEG, 48, 52, 4, 'bandstop' );

% ICA component Removal Second Pass
% Preparation for FastICA Second Pass
% Remove TMS Pulse Artefact + Replace with Constant Amp. Data
EEG = pop_tesa_removedata( EEG, [-2 15] );
EEG = pop_tesa_fastica( EEG, 'approach', 'symm', 'g', 'tanh', 'stabilization', 'off' );
EEG = pop_tesa_compselect( EEG,'compCheck','on','comps',19,'figSize','small','plotTimeX',[-200 500],'plotFreqX',[1 100],'tmsMuscle','on','tmsMuscleThresh',8,'tmsMuscleWin',[11 30],'tmsMuscleFeedback','off','blink','on','blinkThresh',2.5,'blinkElecs',{'Fp1','Fp2'},'blinkFeedback','off','move','on','moveThresh',2,'moveElecs',{'F7','F8'},'moveFeedback','off','muscle','on','muscleThresh',0.6,'muscleFreqWin',[30 100],'muscleFeedback','off','elecNoise','on','elecNoiseThresh',4,'elecNoiseFeedback','off' );

% Interpolate Missing Data
EEG = pop_tesa_interpdata( EEG, 'linear', [5 5] );

% Interpolate Missing (Bad) Channels
EEG = pop_interp(EEG, ALLEEG(1).chanlocs, 'spherical');

% Rereference to Average
EEG = pop_reref( EEG, []);

% TEP Analysis and Outputs
% Extracting TEPs + Regions of Interest
EEG = pop_tesa_tepextract( EEG, 'ROI', 'elecs', {'Fp1','AF3','AF7','F1','F3','F5','F7','FC1','FC3', 'FC5'}, 'tepName', 'LtDLPFC' );
EEG = pop_tesa_tepextract( EEG, 'ROI', 'elecs', {'Fp2','AF4','AF8','F2','F4','F6','F8','FC2','FC4', 'FC6'}, 'tepName', 'RtDLPFC' );
EEG = pop_tesa_tepextract( EEG, 'ROI', 'elecs', {'FC5','FC1','C3','CP5','CP1','FC3','C5','C1','CP3'}, 'tepName', 'LtM1' );
EEG = pop_tesa_tepextract( EEG, 'ROI', 'elecs', {'FC6','FC2','C4','CP6','CP2','FC4','C6','C2','CP4'}, 'tepName', 'RtM1' );
EEG = pop_tesa_tepextract( EEG, 'ROI', 'elecs', {'Fz','FCz','z','F1','FC1','C1','C2','FC2','F2'}, 'tepName', 'Central' );
EEG = pop_tesa_tepextract( EEG, 'ROI', 'elecs', {'Cz'}, 'tepName', 'Cz' );
EEG = pop_tesa_tepextract( EEG, 'GMFA');

% Peak Analysis
EEG = pop_tesa_peakanalysis( EEG, 'ROI', 'positive', [13 30 60 190], [11 15;25 35;45 75;170 210], 'method', 'largest', 'samples', 5 );
EEG = pop_tesa_peakanalysis( EEG, 'ROI', 'negative', [7 18 44 100 280], [5 9;15 21;35 53;85 115;250 310], 'method', 'largest', 'samples', 5 );
EEG = pop_tesa_peakanalysis( EEG, 'GMFA', 'positive', [30 60 180], [20 40;45 75;170 210], 'method', 'largest', 'samples', 5 );