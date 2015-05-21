clear; close all; clc;

%% Set up environment

Fs = 312.5E3;
Ts = 1/Fs;

%% Import log data

logfile = fopen('.\logs\CounterCheck\Auto\logAutoADCtest.log');
M = textscan(logfile,'%s');
fclose(logfile);

dataBin = hexToBinaryVector(M{1,1});
clear M;
if (size(dataBin) > 12),
    data = bi2de(dataBin(:, end-11:end), 'left-msb');
else
    data = bi2de(dataBin, 'left-msb');
end
%clear dataBin;

%% Raw Data

x_axis = (0:1:length(data)-1) * Ts;
y_raw = data;

%% Plot Raw Data

figure;
plot(x_axis, y_raw, '-r');
xlabel('T (s)');
ylabel('Count');
title('Counter', 'fontweight', 'bold');


