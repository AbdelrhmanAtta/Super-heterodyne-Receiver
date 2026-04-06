function plots(signal, Fs, plotTitle)
    figure('Name', plotTitle);
    N = length(signal);
    sig_fft = fftshift(fft(signal));
    f = linspace(-Fs/2, Fs/2, N);
    plot(f, abs(sig_fft)/N);
    title(plotTitle);
    grid on;
    
    if Fs > 100e3
        xlim([-200e3 200e3]); % Radio frequencies
    else
        xlim([-30e3 30e3]);   % Baseband/IF frequencies
    end
end