clear; close all; clc;

%% Set up environment

%Fs = 40E6 / 2^6;
Fs = 65E6 / 2^10;
Ts = 1/Fs;

%% Import log data

logfile = fopen('.\logs\CounterCheck\Auto\Slow\log63kHz.log');
M = textscan(logfile,'%s');
fclose(logfile);

dataBin = hexToBinaryVector(M{1,1});
clear M;
    data = bi2de(dataBin, 'left-msb');
clear dataBin;

%%

counter = 0;
faults = 0;
for i = 1:length(data)-1,
    if ((data(i+1) - data(i)) ~= 1),
        counter = counter + 1;
        faults(counter) = i;
    end
end

test = (data == 65535);

    
%% Raw Data

x_axis = (0:1:length(data)-1) * Ts;
y_raw = data;

%% Plot Raw Data

figure;
hold on;
plot(x_axis, y_raw, '-r');
plot(x_axis(test), y_raw(test), '*b');
xlabel('T (s)');
ylabel('Count');
title('Counter', 'fontweight', 'bold');
hold off;
