function plots(signal, Fs, plotTitle)
    figure('Name', plotTitle);
    N = length(signal);
    % Change to frequency domain
    sig_fft = fftshift(fft(signal));
    f = linspace(-Fs/2, Fs/2, N);
    
    plot(f, abs(sig_fft)/N);
    title(plotTitle);
    grid on;
    
    % Zoom into the interesting parts
    if Fs > 100e3
        xlim([-200e3 200e3]); 
    else
        xlim([-30e3 30e3]);  
    end

    safeName = strrep(plotTitle, ' ', '_');
    safeName = strrep(safeName, ':', '');
    saveas(gcf, fullfile('./plots', [safeName, '.png']));
end