%% task_no_rf.m
% Bypass the RF stage to simulate a receiver with no front-end filter
rf_out = FDM_signal; 

%% IF Stage
% Using a 115kHz Local Oscillator picks up both the 100kHz and 130kHz stations
Flo_high = 115e3; 
mixed_if = rf_out .* cos(2 * pi * Flo_high * t);
[b_if, a_if] = cheby2(6, 60, [7e3 23e3]/(Fs_new/2), 'bandpass');
if_out = filter(b_if, a_if, mixed_if);

%% BB Stage
% Move the overlapping signals down to baseband
mixed_bb = if_out .* cos(2 * pi * 15e3 * t);
[b_lp, a_lp] = cheby2(6, 60, 10e3/(Fs_new/2), 'low');
bb_out = filter(b_lp, a_lp, mixed_bb);

% Reconstruct and normalize the distorted audio
final_audio = resample(bb_out, 1, interp_factor);
final_audio = final_audio / max(abs(final_audio));

%% Plots & Audios
plots(if_out, Fs_new, 'Task 4: High-Side Overlap');
sound(final_audio * 0.8, Fs_orig);
pause(length(final_audio)/Fs_orig + 1);