clear; close all; clc;

%% Set up environment

Fs = 40E6 / 2^6;
Ts = 1/Fs;
fsig = 40E6 / 2^10;
tsig = 1/fsig;

%% Import log data

%logfile = fopen('./logs/System/Burst/625kHz/BPF/logBurstInlineBPF10cm.log');
logfile = fopen('./logs/System/Burst/625kHz/BPF/logBurstReflectorBPF75mm.log');
%logfile = fopen('./logs/System/Burst/625kHz/BPF/Working/Reflector/logBurstReflectorBPF5cm.log');
%logfile = fopen('./logs/System/Burst/625kHz/BPF/logBurstReflectorBPF25mm.log');
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
correction = 1;

x_axis = (0:1:length(data)-(1+correction)) * Ts;
x_axis = x_axis';
y_raw = data(1+correction:end) ./ 4096 * 5;

clear data;

%% Sliding FFT

ttemplate = 0:Ts:32*tsig;
Itemplate = cos(2*pi*fsig*ttemplate);
Qtemplate = -sin(2*pi*fsig*ttemplate);

% figure;
% subplot(211);
% plot(ttemplate, Qtemplate);
% title('Quadrature');
% 
% subplot(212);
% plot(ttemplate, Itemplate);
% title('Inphase');

% Integrate & Dump

% j = 1;
% x = [];
% y = [];
% window = 100;
% i = 1:window:length(y_raw)-(window);
% for n = i,
%     x(j) = sum(sum(y_raw(n:n+window) * Qtemplate * Ts));
%     y(j) = sum(sum(y_raw(n:n+window) * Itemplate * Ts));
%     j = j + 1;
% end
%     
% cor = x.^2 + y.^2;
% corsq = (cor.^2)';
% 
% match = (corsq > 0.995*max(corsq));
% 
% figure;
% plot(i, corsq, '-b', i(match), corsq(match) ,'*r');
% 
% %%
% 
% matchplot = i(match);
% 
% figure;
% hold on;
% plot(x_axis, y_raw, '-b');
% %plot(x_axis, y_raw, '-r', x_axis(401:401+50), y_raw(401:401+50), '-b', x_axis(9601:9601+50), y_raw(9601:9601+50), '-b');
% for n = 1:length(i(match)),
%     plot(x_axis(matchplot(n):matchplot(n)+window), y_raw(matchplot(n):matchplot(n)+window), '-r');
% end
% xlabel('T (s)');
% ylabel('Voltage (V)');
% title('Raw Signal', 'fontweight', 'bold');
% 
% %% 
% 
% delta = 147.2E-6;
% d = [];
% for n = 1:length(i(match)),
%     d(n) = ((x_axis(matchplot(n)) - (n-1)*14.6944E-3) - delta) * 343;
% end

%%

%fcBP = [10E3 48E3] / (Fs/2);
fcBP = [fsig-5E3, fsig+5E3] / (Fs/2);
[B, A] = butter(1, fcBP);

Qtemplate_cond = filter(B, A, Qtemplate)';
Itemplate_cond = filter(B, A, Itemplate)';

% figure;
% subplot(211);
% plot(Qtemplate_cond);
% subplot(212);
% plot(Itemplate_cond);

Qtemplate_cond = flipud(Qtemplate_cond);
Itemplate_cond = flipud(Itemplate_cond);

y_Qmatch = filter(Qtemplate_cond, 1, y_raw);
y_Imatch = filter(Itemplate_cond, 1, y_raw);

y_Qmatch = y_Qmatch / max(y_Qmatch);
y_Imatch = y_Imatch / max(y_Imatch);

thresh = 0.9;

Qmatches = (y_Qmatch >= thresh);
Imatches = (y_Imatch >= thresh);

figure;
hold on;
subplot(211);
hold on;
title('Raw Signal', 'fontweight', 'bold');
plot(x_axis, y_raw, '-b', x_axis(Qmatches), y_raw(Qmatches), 'or');
subplot(212);
hold on;
title('Matched Filter - Quadrature');
plot(x_axis, y_Qmatch, '-b', x_axis(Qmatches), y_Qmatch(Qmatches), 'or');

figure;
hold on;
subplot(211);
hold on;
title('Raw Signal', 'fontweight', 'bold');
plot(x_axis, y_raw, '-b', x_axis(Imatches), y_raw(Imatches), 'or');
subplot(212);
hold on;
title('Matched Filter - Inphase');
plot(x_axis, y_Imatch, '-b', x_axis(Imatches), y_Imatch(Imatches), 'or');

