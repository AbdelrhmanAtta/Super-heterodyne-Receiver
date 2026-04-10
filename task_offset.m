%% task_offset.m
% Define the frequency errors (swapped to run 100Hz then 1000Hz)
offsets = [100, 1000]; 
labels = {'0.1kHz', '1kHz'};

for j = 1:length(offsets)
    %% RF Stage
    % Standard tuning for the BBC station at 100kHz
    [b_rf, a_rf] = cheby2(6, 60, [88e3 112e3]/(Fs_new/2), 'bandpass');
    rf_out = filter(b_rf, a_rf, FDM_signal);

    %% IF Stage
    % Adding the offset to the local oscillator
    Flo_err = (100e3 + 15e3) + offsets(j); 

    % Mixing with an incorrect frequency moves the signal slightly off-center from 15kHz
    mixed_if = rf_out .* cos(2 * pi * Flo_err * t);
    [b_if, a_if] = cheby2(6, 60, [7e3 23e3]/(Fs_new/2), 'bandpass');
    if_out = filter(b_if, a_if, mixed_if);

    %% BB Stage
    % Demodulate back to baseband
    mixed_bb = if_out .* cos(2 * pi * 15e3 * t);
    [b_lp, a_lp] = cheby2(6, 60, 10e3/(Fs_new/2), 'low');
    bb_out = filter(b_lp, a_lp, mixed_bb);

    % Recover audio and normalize for playback
    final_audio = resample(bb_out, 1, interp_factor);
    final_audio = final_audio / max(abs(final_audio));

    %% Plots & Audios
    plots(bb_out, Fs_new, ['Task 5: Offset ', labels{j}]);
    sound(final_audio * 0.8, Fs_orig);
    pause(length(final_audio)/Fs_orig + 1);
end