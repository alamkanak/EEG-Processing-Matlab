function [phase] = GetPhase(EEGData,Fc1,Fc2)
    phase = ButterFilter(EEGData, Fc1, Fc2);
    phase = hilbert(phase);
    phase = rad2deg(angle(phase));
    phase = phase(end);
end

