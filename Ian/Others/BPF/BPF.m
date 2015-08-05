clear; close all; clc;

%%

Fs = 40E6 / 2^6;
Ts = 1/Fs;
fsig = 40E6 / 2^10;
tsig = 1/fsig;

%%

t = 0: Ts:32*tsig;
y = 2.5*sin(2*pi*fsig*t)+2.5;

%%

fc = [fsig-5E3, fsig+5E3];
fcn = fc / (Fs/2);
[B, A] = butter(2, fcn);

%%freqz(xcorr(B,B), xcorr(A,A));

%%

y_cond = filter(B, A, y);

plot(y_cond);

