% modulator.m
config; 
try
    [audio1, Fs_orig] = audioread(file1);
    [audio2, ~] = audioread(file2);
catch
    error('FILES NOT FOUND! Check the /audios folder.');
end

% Use mono (column 1) and match lengths
m1 = audio1(:,1); 
m2 = audio2(:,1); 
maxL = max(length(m1), length(m2));
m1 = [m1; zeros(maxL - length(m1), 1)];
m2 = [m2; zeros(maxL - length(m2), 1)];

% Interpolate to 441kHz
m1_int = interp(m1, interp_factor);
m2_int = interp(m2, interp_factor);
Fs_new = Fs_orig * interp_factor; 

t = (0:length(m1_int)-1)' / Fs_new;

% Frequency Division Multiplexing
s1 = m1_int .* cos(2 * pi * F1 * t);
s2 = m2_int .* cos(2 * pi * F2 * t);
FDM_signal = s1 + s2;

fprintf('Modulator: Success. Fs = %d Hz\n', Fs_new);