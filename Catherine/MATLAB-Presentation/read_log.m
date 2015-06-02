function [t x]=read_log(filename,Ts)

% [t x]=read_log(filename,Ts)
% reads hex data from capture log
% Inputs
% filename: name of capture log file (.log)
% Ts: sample time
% Return values
% t: time vector
% x: values in log

data_file=fopen(filename); % Open file

[num_data count]=fscanf(data_file,'%x',inf); % Read hex values

N=length(num_data);

x=num_data';
t=(0:N-1)*Ts;
