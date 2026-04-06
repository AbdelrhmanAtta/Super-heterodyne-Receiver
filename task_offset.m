clear; clc; close all;
modulator; 

% --- RECEIVER WITH 1 kHz OFFSET ---
offset = 1000; % 1 kHz Error
Flo_err = (100e3 - 15e3) + offset; % 86 kHz instead of 85 kHz

% RF Filter is ON (Tuned to BBC at 100 kHz)
[b_rf, a_rf] = cheby2(6, 60, [88e3 112e3]/(Fs_new/2), 'bandpass');
rf_out = filter(b_rf, a_rf, FDM_signal);

% Mix with the Offset Error
mixed_if = rf_out .* cos(2 * pi * Flo_err * t);
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
plots(bb_out, Fs_new, 'Task 5: Final Baseband (Shifted by 1kHz)');
fprintf('Playing BBC with 1 kHz tuning offset error...\n');
sound(final_audio * 0.8, Fs_orig);