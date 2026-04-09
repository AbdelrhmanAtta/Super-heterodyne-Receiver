clear; clc; close all;
modulator; 

% Define the two offsets to test
offsets = [1000, 100]; % 1 kHz and 0.1 kHz
offset_names = {'1kHz', '0.1kHz'};

for j = 1:length(offsets)
    current_offset = offsets(j);
    fprintf('--- Running Task 5 with Offset: %g Hz ---\n', current_offset);
    
    % Local Oscillator with Error
    Flo_err = (100e3 - 15e3) + current_offset; 

    % 1. RF Filter (Tuned to BBC at 100 kHz)
    [b_rf, a_rf] = cheby2(6, 60, [88e3 112e3]/(Fs_new/2), 'bandpass');
    rf_out = filter(b_rf, a_rf, FDM_signal);

    % 2. Mixing with the Error
    mixed_if = rf_out .* cos(2 * pi * Flo_err * t);
    
    % 3. IF Filter
    [b_if, a_if] = cheby2(6, 60, [7e3 23e3]/(Fs_new/2), 'bandpass');
    if_out = filter(b_if, a_if, mixed_if);

    % 4. Baseband Demodulation (Synchronous detection at 15kHz)
    mixed_bb = if_out .* cos(2 * pi * 15e3 * t);
    [b_lp, a_lp] = cheby2(6, 60, 10e3/(Fs_new/2), 'low');
    bb_out = filter(b_lp, a_lp, mixed_bb);

    % 5. Recovery & Normalization
    final_audio = resample(bb_out, 1, interp_factor);
    if max(abs(final_audio)) > 1e-6
        final_audio = final_audio / max(abs(final_audio));
    end

    % --- PLOT & PLAY ---
    plots(bb_out, Fs_new, ['Task 5: Final Baseband (Shifted by ', offset_names{j}, ')']);
    
    fprintf('Playing BBC with %s offset...\n', offset_names{j});
    sound(final_audio * 0.8, Fs_orig);
    
    % Wait for audio to finish before next offset
    pause(length(final_audio)/Fs_orig + 2);
end