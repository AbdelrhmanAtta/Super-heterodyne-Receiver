clear; clc; close all;
modulator; % Loads FDM_signal and t

% --- RECEIVER WITHOUT RF FILTER ---
% Skip the RF filter (Directly use the FDM_signal)
rf_out = FDM_signal; 

% Use High-Side Injection (115 kHz)
% Result: |100 - 115| = 15kHz (BBC) AND |130 - 115| = 15kHz (Quran)
Flo_high = 115e3; 
mixed_if = rf_out .* cos(2 * pi * Flo_high * t);

% IF Filter (15 kHz)
[b_if, a_if] = cheby2(6, 60, [7e3 23e3]/(Fs_new/2), 'bandpass');
if_out = filter(b_if, a_if, mixed_if);

% Baseband Demodulation
mixed_bb = if_out .* cos(2 * pi * 15e3 * t);
[b_lp, a_lp] = cheby2(6, 60, 10e3/(Fs_new/2), 'low');
bb_out = filter(b_lp, a_lp, mixed_bb);

% Recovery & Normalization
final_audio = resample(bb_out, 1, interp_factor);
final_audio = final_audio / max(abs(final_audio));

% --- PLOT & PLAY ---
plots(if_out, Fs_new, 'Task 4: IF Spectrum (Image Overlap at 15kHz)');
fprintf('Playing BBC with Quran Image Interference...\n');
sound(final_audio * 0.8, Fs_orig);