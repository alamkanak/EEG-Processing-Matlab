function [hjorth] = SaveHjorth(eegPath, outputPath)
    cfg = [];
    cfg.datafile = eegPath;
    cfg.headerfile = eegPath;
    [data] = ft_preprocessing(cfg);
    neighbours(1).label = 'C3';
    neighbours(1).neighblabel = {'FCz', 'CPz', 'FT7', 'TP7'};
    neighbours(2).label = 'C4';
    neighbours(2).neighblabel = {'FCz', 'CPz', 'FT8', 'TP8'};
    cfg = [];
    cfg.method = 'hjorth';
    cfg.elec = data.hdr.elec;
    cfg.trials = 'all';
    cfg.feedback = 'gui';
    cfg.neighbours = neighbours;
    hjorth = ft_scalpcurrentdensity(cfg, data);
    ft_write_data(outputPath, hjorth, 'dataformat', 'matlab');
end