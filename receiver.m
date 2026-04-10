%% receiver.m
stations = [F1, F2]; 
names = {'BBC Arabic', 'Quran Palestine'};

for i = 1:length(stations)
    fc = stations(i);
    
    %% RF Stage
    % Select the specific station and reject the rest
    [b_rf, a_rf] = cheby2(6, 60, [fc-12e3, fc+12e3]/(Fs_new/2), 'bandpass');
    rf_out = filter(b_rf, a_rf, FDM_signal);
    
    %% IF Stage
    % Shift the signal to 15kHz using a High-Side Local Oscillator
    Flo = fc + Fif; 
    mixed_if = rf_out .* cos(2 * pi * Flo * t);
    
    % Use a sharp bandpass filter to keep only the 15kHz intermediate signal
    [b_if, a_if] = cheby2(6, 60, [Fif-8e3, Fif+8e3]/(Fs_new/2), 'bandpass');
    if_out = filter(b_if, a_if, mixed_if);
    
    %% BB Stage
    % Bring the signal down to 0Hz and remove high-frequency noise
    mixed_bb = if_out .* cos(2 * pi * Fif * t);
    [b_lp, a_lp] = cheby2(6, 60, 10e3/(Fs_new/2), 'low');
    bb_out = filter(b_lp, a_lp, mixed_bb);
    
    % Downsample and normalize volume for final playback
    final_audio = resample(bb_out, 1, interp_factor);
    final_audio = final_audio / max(abs(final_audio));
    
    %% Plots & Audios
    plots(m1_int, Fs_new, [names{i}, ': Original']);
    plots(FDM_signal, Fs_new, [names{i}, ': FDM']);
    plots(rf_out, Fs_new, [names{i}, ': RF']);
    plots(if_out, Fs_new, [names{i}, ': IF']);
    plots(bb_out, Fs_new, [names{i}, ': Baseband']);
    sound(final_audio * 0.8, Fs_orig); 
    pause(length(final_audio)/Fs_orig + 1);
end