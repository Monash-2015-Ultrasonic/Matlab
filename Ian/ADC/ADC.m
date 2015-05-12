clear; close all; clc;

%% Set up environment

Fs = 312.5E3*2;
Ts = 1/Fs;
fsig1 = 39.0625E3;

%% Import log data

logfile = fopen('capture.log');
M = textscan(logfile,'%s');
fclose(logfile);

data = hex2dec(M{1,1});
clear M;
        
%% Raw Data

x_axis = (0:1:length(data)-1) * Ts;
y_raw = data ./ 4096 * 5;

%% Plot Raw Data

figure;
plot(x_axis, y_raw, '-r');
xlabel('T (s)');
ylabel('Voltage (V)');
title('Raw Signal', 'fontweight', 'bold');

%% Signal conditioning - Remove DC Bias

a = [1 , -0.99]; b = [1,-1];
data_cond = filtfilt(b, a, data);

%figure;
%freqz(xcorr(b,b),xcorr(a,a));
%title('DC LPF', 'fontweight', 'bold');

%% Plot conditioned data

y_cond = data_cond ./ 4096 * 5;

figure;
plot(x_axis, y_cond, '-r');
title('Conditioned Signal', 'fontweight', 'bold');
xlabel('T (s)');
ylabel('Voltage (V)');

%% FFT

NFFT = 2^nextpow2(length(y_cond));

% Single-sided Amplitude Spectrum:
% Y = fft(data_cond, NFFT) / length(data_cond);
% f = Fs/2 * linspace(0,1,NFFT/2+1);
% 
% figure;
% plot(f, 2*abs(Y(1:NFFT/2+1)));
% title('Single-sided Amplitude Spectrum of Raw Signal', 'fontweight', 'bold');
% xlabel('Frequency (Hz)');
% ylabel('|Y(f)|');

% Single-sided PSD:
X = fft(y_cond, NFFT);	 	 
Px = X .* conj(X) / (NFFT*length(y_cond)); %Power of each freq components	 	 
fVals = Fs * (0:NFFT/2-1) / NFFT;	 	 
figure;
plot(fVals,Px(1:NFFT/2),'-*r','LineSmoothing','on','LineWidth',1);	 	 
title('One Sided Power Spectral Density', 'fontweight', 'bold');	 	 
xlabel('Frequency (Hz)')	 	 
ylabel('PSD');

%% Bandpass f1 +- 1kHz

fn1 = [fsig1 - 2E3, fsig1 + 2E3] / Fs;
Wn1 = 2*pi*fn1;
[B1, A1] = butter(1,Wn1 );
figure;
freqz(B1,A1);
title('Transfer Function of 39.0625kHz Bandpass Filter', 'fontweight', 'bold');
dataOut1 = filter(B1,A1,y_cond);

figure;
plot(x_axis, dataOut1);
title('39.0625kHz Bandpassed Signal', 'fontweight', 'bold');
