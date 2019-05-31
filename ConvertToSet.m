%% Load file
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

subject = "BrunetSarah/TMSEEG20181129BS";
experiment = "SP 110RMT r1";

root = "/Users/alam/Desktop/TMSEEG-Data/";
path = root + "Recordings/" + subject + "/EEG/" + experiment + "/";
filename = "Brunet_Sarah_2018-11-29_15-41-19";
[EEG] = pop_loadeep_v4(path + filename + ".cnt");
EEG = pop_saveset( EEG, 'filename', filename + '.set', 'filepath', root + "SET Files/" + subject + "/" + experiment + "/" );