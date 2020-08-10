function [phases] = SaveHjorthPhases(hjorth, OutputPath)
    sz = size(hjorth.trial);
    sz = sz(end);
    phases = zeros(sz,4);
    for j=1:sz
        EEGData = hjorth.trial{j};
        EEGData = EEGData(1, :);
        [theta, mu, beta, gamma] = GetPhases(EEGData);
        phases(j, :) = [theta, mu, beta, gamma];
    end
    data_cells=num2cell(phases);
    output_matrix= [{'theta', 'mu', 'beta', 'gamma'}; data_cells];
    output_matrix = cell2table(output_matrix);
    writetable(output_matrix, OutputPath)
end

