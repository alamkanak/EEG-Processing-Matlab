%%
addpath('/Users/alam/Documents/MATLAB/fieldtrip-20200607')
addpath('functions/')
addpath('/Users/alam/Documents/MATLAB/eeglab14_1_2b_edited')

fileList = dir("data/dataset3/clean2/*.set");
output_root = "data/dataset3/clean/";
for k = 1:length(fileList)
    file = fileList(k);
    eeglab
    
    %%
    EEG = pop_loadset('filename', file.name, 'filepath', file.folder);
    EEGData = EEG.data;
    save(strcat(output_root, file.name(1:end-4), '.mat'), 'EEGData');
end