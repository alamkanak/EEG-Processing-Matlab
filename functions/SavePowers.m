function [] = SavePowers(EEGData, OutputPath)
    sz = size(EEGData);
    sz = sz(end);
    powers = zeros(sz,4);
    for j=1:sz
        [theta, mu, beta, gamma] = GetPowers(EEGData(13:13, :, j));
        powers(j, :) = [theta, mu, beta, gamma];
    end
    data_cells=num2cell(powers);
    output_matrix= [{'theta', 'mu', 'beta', 'gamma'}; data_cells];
    output_matrix = cell2table(output_matrix);
    writetable(output_matrix, OutputPath);
end

