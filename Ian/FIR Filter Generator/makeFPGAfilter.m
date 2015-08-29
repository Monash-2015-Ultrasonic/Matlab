clear; close all; clc;

%%

filter_file = 'rising_edge_impulse_response.mat';

data = importdata(filter_file);

figure;
plot(data.t, data.x);
title('Impulse Response', 'fontweight', 'bold');
xlabel('Time');

clear data;

%%
f0 = 41.176471E6 / 2^10;        % Signal frequency
Fs = 70E6 / 2^8;                % Sample frequency
Ts = 1/Fs;                      % Sample time

[t_filter x_filter] = make_filter(filter_file, Ts, f0);

%%
fileID = fopen('imp_response_FPGA.txt', 'w');
fileID2 = fopen('imp_response_FPGA_norm.txt', 'w');

temp = ones(1, length(x_filter));

str = input('Time-reverse the impulse response? Y or N ', 's');
if (str == 'Y' || str == 'y'),
    %% V1 FIR Filter
    for i = length(x_filter):-1:2,
        fprintf(fileID, '%g\n', x_filter(i));
        fprintf(fileID2, '%g\n', temp(i));
    end
    fprintf(fileID, '%g\n', x_filter(1));
    fprintf(fileID2, '%g\n', temp(1));

    %% V2 Filter
    % for i = length(x_filter):-1:2,
    %     fprintf(fileID, '%g, ', x_filter(i));
    % end
    % fprintf(fileID, '%g', x_filter(1));
else
    %% V1 FIR Filter
    for i = 1:length(x_filter)-1,
        fprintf(fileID, '%g\n', x_filter(i));
    end
    fprintf(fileID, '%g\n', x_filter(end));

    %% V2 Filter
    % for i = 1:length(x_filter)-1,
    %     fprintf(fileID, '%g, ', x_filter(i));
    % end
    % fprintf(fileID, '%g', x_filter(end));
end

fclose(fileID);
fclose(fileID2);
%%

close all;

data = importdata('imp_response_FPGA.txt');
plot(data);