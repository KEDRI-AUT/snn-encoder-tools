function [  ] = myfft( signal,name,Fs )
%MYFFT Plot results of an FFT
%   Performs FFT and plots results on new figure.

fftlen=length(signal);
Y = fft(signal);
P2 = abs(Y/fftlen);
P1 = P2(1:floor(fftlen/2)+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(floor(fftlen/2)))/fftlen;

plot(f(2:end),P1(2:end)) 
title(['Single-Sided Amplitude Spectrum of ',name])
xlabel('f (Hz)')
ylabel('|P1(f)|')

end

