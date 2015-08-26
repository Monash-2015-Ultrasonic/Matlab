clear; close all; clc;

%%
f0 = 41.176471E6 / 2^10;        % Signal frequency
Fs = 70E6 / 2^8;                % Sample frequency
Ts = 1/Fs;                      % Sample time

[t_filter x_filter] = make_filter('rising_edge_impulse_response.mat', Ts, f0);

fileID = fopen('imp_response_FPGA.txt', 'w');

%% V1 FIR Filter
for i = 1:length(x_filter)-1,
    fprintf(fileID, '%g\n', x_filter(i));
end
fprintf(fileID, '%g\n', x_filter(1));

%% V2 Filter
% for i = length(x_filter):-1:2,
%     fprintf(fileID, '%g, ', x_filter(i));
% end
% fprintf(fileID, '%g', x_filter(1));

%%
fclose(fileID);