clear; close all; clc;

%% Set up environment

Fs = 40E6 / 2^6;
Ts = 1/Fs;
fsig1 = 40E6 / 2^10;

%% Import log data

logfile = fopen('./logs/System/Burst/625kHz/logBurstBPF25mm.log');
%logfile = fopen('./logs/System/Square/625kHz/Burst/logBurst.log');
M = textscan(logfile,'%s');
fclose(logfile);

if (ispc),
    dataBin = hexToBinaryVector(M{1,1});
    if (size(dataBin) > 12),
        data = bi2de(dataBin(:, end-11:end), 'left-msb');
    else
        data = bi2de(dataBin, 'left-msb');
    end
elseif (isunix),
    dataBin = dec2bin(hex2dec(M{1,1}), 16);
    data = bin2dec(dataBin(:, end-11:end));
end
clear M;
clear dataBin;
        
%% Raw Data

x_axis = (0:1:length(data)-1) * Ts;
y_raw = data ./ 4096 * 5;

%% Plot Raw Data

figure;
plot(x_axis, y_raw, '-r');
xlabel('T (s)');
ylabel('Voltage (V)');
title('Raw Signal', 'fontweight', 'bold');

clear y_raw;

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

clear data;
clear data_cond;

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
fVals = Fs/2 * (0:NFFT/2-1) / NFFT;	 	 
figure;
plot(fVals,Px(1:NFFT/2),'-*r','LineSmoothing','on','LineWidth',1);	 	 
title('One Sided Power Spectral Density of Conditioned Signal', 'fontweight', 'bold');	 	 
xlabel('Frequency (Hz)')	 	 
ylabel('PSD');

clear X; 
clear Px;
clear fVals;
%% Bandpass f1 +- 1kHz

fn1 = [fsig1 - 2E3, fsig1 + 2E3] / Fs;
Wn1 = 2*pi*fn1;
[B1, A1] = butter(1,Wn1, 'bandpass');
%figure;
%freqz(B1,A1);
%title('Transfer Function of 39.0625kHz Bandpass Filter', 'fontweight', 'bold');

x_sine = 0:Ts/fsig1:1/fsig1;
y_sine = 2.5*sin(2*pi*fsig1*x_sine) + 2.5;
%figure;
%plot(x_sine, y_sine);

%dataOut1 = filter(B1,A1,y_cond);

y_sine_cond = filter(B1, A1, y_sine);
%figure;
%plot(x_sine, y_sine_cond);

clear x_sine;
clear B1;
clear A1;

%figure;
%plot(x_axis, dataOut1);
%title('39.0625kHz Bandpassed Signal', 'fontweight', 'bold');

%% Matched filter


% % A template is given
% temp = randn(100,1);
% 
% % Create a matched filter based on the template
% b = flipud(temp(:));
% 
% % For testing the matched filter, create a random signal which
% % contains a match for the template at some time index
% x = [randn(200,1); temp(:); randn(300,1)];
% n = 1:length(x);
% 
% % Process the signal with the matched filter
% y = filter(b,1,x);
% 
% % Set a detection threshold (exmaple used is 90% of template)
% thresh = 0.9
% 
% % Compute normalizing factor
% u = temp.'*temp;
% 
% % Find matches
% matches = n(y>thresh*u);
% 
% % Plot the results
% plot(n,y,'b', n(matches), y(matches), 'ro');
% 
% % Print the results to the console
% display(matches);


template = fliplr(y_sine_cond);
y_match = filter(template, 1, y_cond);
y_match = y_match ./ max(y_match);

clear y_cond;
clear y_sine;
clear template;

thresh = 0.9878;
%u = y_sine_cond.'*y_sine_cond;
matches = (y_match >= thresh);
figure;
%plot(x_axis, y_match, '-b', x_axis(matches), y_match(matches), 'or');
plot(x_axis(matches), y_match(matches), 'or', x_axis, y_match, '-b');
