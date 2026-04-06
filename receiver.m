% receiver.m

% 1. RF Stage (Pre-selection)
[b_rf, a_rf] = butter(6, [85e3 115e3]/(Fs_new/2), 'bandpass'); 
rf_output = filter(b_rf, a_rf, FDM_signal);

% 2. IF Stage (Mixing and Filtering)
% THIS IS THE MISSING LINE:
mixed_if = rf_output .* cos(2 * pi * Flo * t); 

[b_if, a_if] = butter(6, [10e3 20e3]/(Fs_new/2), 'bandpass');
if_output = filter(b_if, a_if, mixed_if);

% 3. Baseband Stage (Final Demodulation)
mixed_bb = if_output .* cos(2 * pi * Fif * t);
[b_lp, a_lp] = butter(6, 10e3/(Fs_new/2), 'low');
final_upsampled = filter(b_lp, a_lp, mixed_bb);

% 4. Final Output
final_audio = resample(final_upsampled, 1, interp_factor);