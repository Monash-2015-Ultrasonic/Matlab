clear; close all; clc;

%% Set up environment

Fs = 40E6 / 2^6;
Ts = 1/Fs;
fsig = 40E6 / 2^10;
tsig = 1/fsig;

%% Import log data

logfile = fopen('./logs/System/Burst/625kHz/BPF/logBurstInlineBPF10cm.log');
M = textscan(logfile,'%s');
fclose(logfile);
clear logfile;

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
x_axis = x_axis';
y_raw = data ./ 4096 * 5;

figure;
plot(x_axis, y_raw, '-r');
xlabel('T (s)');
ylabel('Voltage (V)');
title('Raw Signal', 'fontweight', 'bold');

clear data;

%% Sliding FFT

ttemplate = 0:Ts:tsig;
Qtemplate = cos(2*pi*fsig*ttemplate);
Itemplate = -sin(2*pi*fsig*ttemplate);

figure;
subplot(211);
plot(ttemplate, Qtemplate);
title('Quadrature');

subplot(212);
plot(ttemplate, Itemplate);
title('Inphase');

% Integrate & Dump

j = 1;
x = [];
y = [];
window = 100;
for i = 1:window:length(y_raw),
    x(j) = sum(y_raw(i:i+window) * Qtemplate) * Ts;
    y(j) = sum(y_raw(i:i+window) * Itemplate) * Ts;
    j = j + 1;
end
    





