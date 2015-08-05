clear; close all; clc;

%%

f = 40E3;                               % Hz
Tsample = 1/(40*f);                     % s    

snr = 10*log10(3);                    % dB


%%

vs = 343.59;                            % ms^-1
distance = 0.1;                         % m

time = distance/vs;                     % s
delay = floor(time/Tsample);                   

%% 

Tstop = 1/f * 0.04 * delay;             % s 0.0000625
sim('SignalGen.slx');

%% 

Vpp = 200E-3;                           % V
Vp = 0.5*Vpp;                           % V
Psignal = Vp^2/2;                       % W
