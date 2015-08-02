clear; close all; clc;

datafile=open('results.mat');

results=datafile.bpfresults;

f=results(:,1);
dB=10*log10(results(:,2)/max(results(:,2)));

%semilogx(f,dB);
%semilogy(f,dB);
hold on;
plot(f,-3,'*r', f,dB,'-b', 3.88e4,-3,'*k', 4.84e4,-3,'*k');
title('Frequency response');
xlabel('Frequency (Hz)');
ylabel('Response (dB)');