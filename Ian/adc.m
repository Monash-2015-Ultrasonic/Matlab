clear; close all; clc;

%%

%log = importdata('log1.log');

logfile = fopen('log1.log');
M = textscan(logfile,'%s');
fclose(logfile);

data = cell2mat(M{1,1});
clear M;
data_int = hex2dec(data(:,2:4));
clear data;

%%

x_axis = 1:1:length(data_int);
y_axis = data_int ./ 4096 * 5;

%%

plot(x_axis, y_axis, '-r');
xlabel('T (s)');
ylabel('Voltage (v)');
