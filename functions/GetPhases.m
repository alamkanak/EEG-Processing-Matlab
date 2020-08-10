function [theta, mu, beta, gamma] = GetPhases(EEGData)
    theta = GetPhase(EEGData, 3.5, 8);
    mu = GetPhase(EEGData, 8, 12);
    beta = GetPhase(EEGData, 13, 30);
    gamma = GetPhase(EEGData, 30, 80);
end

