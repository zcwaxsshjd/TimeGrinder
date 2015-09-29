% load B1FS.mat;
y=Data.EMG_Ch1;
   Fs=2410; 
   L=length(Data.EMG_Ch1);
   NFFT = 2^nextpow2(L); % Next power of 2 from length of y
   Y = fft(y,NFFT)/L;
   f = Fs/2*linspace(0,1,NFFT/2+1);
   % Plot single-sided amplitude spectrum.
    figure
    plot(f,2*abs(Y(1:NFFT/2+1))) 
    grid on;
    title('Single-Sided Amplitude Spectrum of y(t)')
    xlabel('Frequency (Hz)')
    ylabel('|Y(f)|')

