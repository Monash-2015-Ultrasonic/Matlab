clear; close all; clc;

%%

Fs = 40E6 / 2^6;
Ts = 1/Fs;
fsig = 40E6 / 2^10;
tsig = 1/fsig;

%%

t = 0:Ts:2*574*tsig;
y = square(2*pi*fsig*t);
y = 5*y;

y((t > 31*tsig) & (t < 574*tsig)) = 0;
y((t > (575+31)*tsig) & (t < (575+574)*tsig)) = 0;

y(y<0) = 0;

%%
figure;
plot(t,y, '-b');
xlabel('t (s)');
ylabel('V (V)');

%% FFT

NFFT = 2^nextpow2(length(y));

%Single-sided Amplitude Spectrum:
Y = fft(y, NFFT) / length(y);
f = Fs/2 * linspace(0,1,NFFT/2+1);

figure;
plot(f, 2*abs(Y(1:NFFT/2+1)));
title('Single-sided Amplitude Spectrum of Raw Signal', 'fontweight', 'bold');
xlabel('Frequency (Hz)');
ylabel('|Y(f)|');

% Single-sided PSD:
X = fft(y, NFFT);	 	 
Px = X .* conj(X) / (NFFT*length(y)); %Power of each freq components	 	 
fVals = Fs/2 * (0:NFFT/2-1) / NFFT;	 	 
figure;
plot(fVals,Px(1:NFFT/2),'-*r','LineSmoothing','on','LineWidth',1);	 	 
title('One Sided Power Spectral Density of Burst', 'fontweight', 'bold');	 	 
xlabel('Frequency (Hz)')	 	 
ylabel('PSD');
