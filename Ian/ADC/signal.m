clear; close all; clc;

%%

Fs = 312.5E3;
Ts = 1/Fs;
fsig1 = 40E3;
fsig2 = 2*fsig1;

%%

logfile = fopen('log4.log');
M = textscan(logfile,'%s');
fclose(logfile);

data_hex = cell2mat(M{1,1});
clear M;
data_int = hex2dec(data_hex);
clear data_hex;

%%

x_axis = (0:1:length(data_int)-1) * Ts;
y_axis = data_int ./ 4096 * 5;

%%

plot(x_axis, y_axis, '-r');
xlabel('T (s)');
ylabel('Voltage (v)');

%%

NFFT = 2^nextpow2(length(data_int));
Y = fft(data_int, NFFT) / length(data_int);
f = Fs/2 * linspace(0,1,NFFT/2+1);

figure;
plot(f, 2*abs(Y(1:NFFT/2+1)));
title('Single-sided Amplitude Spectrum of y(t)');
xlabel('Frequency (Hz)');
ylabel('|Y(f)|');

%%

fn1 = [fsig1 - 1E3, fsig1 + 1E3] / Fs;
Wn1 = fn1;
[B1, A1] = butter(8,Wn1 );
figure;
freqz(B1,A1);
dataOut1 = filter(B1,A1,data_int);

figure;
plot(x_axis, dataOut1);

%%

fn2 = [fsig2 - 1E3, fsig2 + 1E3] / Fs;
Wn2 = fn2;
[B2, A2] = butter(8,Wn2 );
figure;
freqz(B2,A2);
dataOut2 = filter(B2,A2,data_int);

figure;
plot(x_axis, dataOut2);
