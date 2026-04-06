% main.m
clear; clc; close all;
modulator; 

stations = [F1, F2]; 
names = {'BBC_Arabic', 'Quran_Palestine'};

for i = 1:length(stations)
    fc = stations(i);
    fprintf('--- Tuning to %s (%d kHz) ---\n', names{i}, fc/1000);
    
    % --- RECEIVER STAGES ---
    % 1. RF Stage (Tuning)
    [b_rf, a_rf] = cheby2(6, 60, [fc-12e3, fc+12e3]/(Fs_new/2), 'bandpass');
    rf_out = filter(b_rf, a_rf, FDM_signal);
    
    % 2. Mixer and IF Stage (Move to 15kHz)
    Flo_local = fc - Fif; 
    mixed_if = rf_out .* cos(2 * pi * Flo_local * t);
    
    % 3. IF Filter
    [b_if, a_if] = cheby2(6, 60, [Fif-8e3, Fif+8e3]/(Fs_new/2), 'bandpass');
    if_out = filter(b_if, a_if, mixed_if);
    
    % 4. Demodulation to Baseband (Move to 0Hz)
    mixed_bb = if_out .* cos(2 * pi * Fif * t);
    [b_lp, a_lp] = cheby2(6, 60, 10e3/(Fs_new/2), 'low');
    bb_out = filter(b_lp, a_lp, mixed_bb);
    
    % 5. Recovery & Normalization
    final_audio = resample(bb_out, 1, interp_factor);
    if max(abs(final_audio)) > 1e-6
        final_audio = final_audio / max(abs(final_audio));
    end
    
    % --- THE 5 PLOTS SEQUENCE ---
    % Plot 1: Original Message (from modulator.m)
    plots(m1_int, Fs_new, [names{i} ': 1. Original Message Spectrum']);
    
    % Plot 2: Full FDM Spectrum (from modulator.m)
    plots(FDM_signal, Fs_new, [names{i} ': 2. FDM Spectrum (Airwaves)']);
    
    % Plot 3: RF Filtered Signal (Selected Station)
    plots(rf_out, Fs_new, [names{i} ': 3. RF Output (Selected)']);
    
    % Plot 4: IF Signal (Shifted to 15kHz)
    plots(if_out, Fs_new, [names{i} ': 4. IF Output (at 15kHz)']);
    
    % Plot 5: Final Demodulated Signal (Back at 0Hz)
    plots(bb_out, Fs_new, [names{i} ': 5. Final Baseband Output']);
    
    drawnow; % Force all 5 windows to open
    
    % --- PLAYBACK ---
    fprintf('Playing %s...\n', names{i});
    sound(final_audio * 0.8, Fs_orig); 
    pause(length(final_audio)/Fs_orig + 2);
end