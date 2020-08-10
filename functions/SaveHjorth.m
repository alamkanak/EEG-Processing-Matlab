function [hjorth] = SaveHjorth(eegPath, outputPath)
    cfg = [];
    cfg.datafile = eegPath;
    cfg.headerfile = eegPath;
    [data] = ft_preprocessing(cfg);
    neighbours(1).label = 'C3';
    neighbours(1).neighblabel = {'FC1', 'CP1', 'FC5', 'CP5'};
    neighbours(2).label = 'C4';
    neighbours(2).neighblabel = {'FC2', 'CP2', 'FC6', 'CP6'};
    cfg = [];
    cfg.method = 'hjorth';
    cfg.elec = data.hdr.elec;
    cfg.trials = 'all';
    cfg.feedback = 'gui';
    cfg.neighbours = neighbours;
    hjorth = ft_scalpcurrentdensity(cfg, data);
    ft_write_data(outputPath, hjorth, 'dataformat', 'matlab');
end