clear; close all; clc;

%%


f1 = 24E3;
f2 = 40E6 / 2^10;
f3 = 1E6;

t = 0:1/f3/2:400E-6;

y1 = sin(2*pi*f1*t);
y2 = 0.5*sin(2*pi*f2*t + pi/8);
y3 = sin(2*pi*f3*t + pi/4);

y = y1+y2+y3;

figure;
plot(t,y);

%%

Fs = 10E3;
%Ts = 1/Fs;
fsig = 40E6 / 2^10;

fc = [fsig-0.5E3, fsig+0.5E3];
%fcn = fc / (Fs/2);
wc = 2*pi*fc;
[B, A] = butter(1, wc/(2*pi*Fs/2), 's');

%%freqz(xcorr(B,B), xcorr(A,A));

y_cond = filter(B, A, y);

figure;
plot(t,y_cond);

