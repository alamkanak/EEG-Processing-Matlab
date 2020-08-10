function [theta, mu, beta, gamma] = GetPowers(EEGData)
    [power, freq] = spectopo(EEGData, 0, 256, 'plot', 'off');
    theta = mean(power(freq >= 3.5 & freq < 8));
    mu = mean(power(freq >= 8 & freq < 12));
    beta = mean(power(freq >= 13 & freq < 30));
    gamma = mean(power(freq >= 30 & freq < 80));
end

