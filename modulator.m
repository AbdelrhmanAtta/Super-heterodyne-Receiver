%% modulator.m

%% Reading the audio files
try
    [audio1, Fs_orig] = audioread(file1);
    [audio2, ~] = audioread(file2);
catch
    error('Wav files missing');
end

%% Modulation
% Stick to mono by only grabbing the left channel
m1 = audio1(:,1); 
m2 = audio2(:,1); 

% Add silence to the end of the shorter audio so both are perfectly matched
maxL = max(length(m1), length(m2));
m1 = [m1; zeros(maxL - length(m1), 1)];
m2 = [m2; zeros(maxL - length(m2), 1)];

% Speed up the data rate to create enough resolution for high radio frequencies
m1_int = interp(m1, interp_factor);
m2_int = interp(m2, interp_factor);
Fs_new = Fs_orig * interp_factor; 
t = (0:length(m1_int)-1)' / Fs_new;

% Shifting the audio to their carrier frequencies
s1 = m1_int .* cos(2 * pi * F1 * t);
s2 = m2_int .* cos(2 * pi * F2 * t);

% Merge both signals into one (Multiplexing)
FDM_signal = s1 + s2;