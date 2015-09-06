clear; close all; clc;

%%

f0 = 41.176471E6 / 2^10;        % Signal frequency
Fs = 70E6 / 2^8;                % Sample frequency
Ts = 1/Fs;                      % Sample time

%%
filter_file_org = 'new_new_filter.mat';

data = importdata(filter_file_org);
tt = data.tt;
xx = data.xx;

take = floor(length(tt) / 6.25);

tt = tt(1:take);
xx = xx(1:take);

filter_file_mod = 'mod_new_filter.mat';
save(filter_file_mod, 'tt', 'xx');

%%
figure;
plot(tt,xx);
title('Impulse Response', 'fontweight', 'bold');
xlabel('Time');

clear data;

[t_filter x_filter] = make_filter(filter_file_mod, Ts, f0);

%%
fileID = fopen('imp_response_FPGA.txt', 'w');

str = input('Time-reverse the impulse response? Y or N ', 's');
if (str == 'Y' || str == 'y'),
    %% V1 FIR Filter
    for i = length(x_filter):-1:2,
        fprintf(fileID, '%g\n', x_filter(i));
    end
    fprintf(fileID, '%g\n', x_filter(1));

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
%%

close all;

data = importdata('imp_response_FPGA.txt');
plot(data);