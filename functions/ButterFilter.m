function y = ButterFilter(x, Fc1, Fc2)
%BUTTERFILTERMU Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 9.4 and DSP System Toolbox 9.6.
% Generated on: 25-Jul-2020 02:00:31

% Butterworth Bandpass filter designed using FDESIGN.BANDPASS.

% All frequency values are in Hz.
Fs = 256;  % Sampling Frequency
N   = 4;   % Order

% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.bandpass('N,F3dB1,F3dB2', N, Fc1, Fc2, Fs);
Hd = design(h, 'butter');
y = filter(Hd, x);
% [EOF]
