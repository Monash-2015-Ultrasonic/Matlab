% Distance detection

close all
clear all
clc

v=343; % Speed of sound
f0=40e3; % Signal frequency
threshold=0.5; % Noise threshold

logname='logBurstInlineBPF10cm.log'; % Name of signal capture log ('logname.log')
fs=625e3; % Sample frequency
Ts=1/fs; % Sample time

[t_signal x_signal]=read_log(logname,Ts);

figure
plot(t_signal,x_signal);
title('ADC output');
xlabel('t')
ylabel('ADC output');

filtername='impulse_response.mat'; % Name of matched filter impulse response file ('filtername.mat')

[t_filter x_filter]=make_filter(filtername,Ts,f0);

x_signal=process_log(x_signal,x_filter);

subplot_handle=figure;
subplot(2,2,1);
plot(t_signal,x_signal);
title('Received signal with DC component removed');
xlabel('t');
ylabel('x(t)');

figure
plot(t_signal,x_signal);
title('Received signal after removal of DC component and normalisation');
xlabel('t');
ylabel('x(t)');

figure(subplot_handle)
subplot(2,2,2);
plot(t_filter,x_filter);
title('Matched filter impulse response');
xlabel('t');
ylabel('h(t)');

figure
plot(t_filter,x_filter);
title('Matched filter impulse response');
xlabel('t');
ylabel('h(t)');

x_matched=matched_filter(x_filter,x_signal);
t_matched=Ts*(0:length(x_matched)-1);
t_matched=t_matched+t_signal(1)-t_filter(end);

figure(subplot_handle)
subplot(2,2,3)
plot(t_matched,x_matched);
title('Matched filter output');
xlabel('t');
ylabel('y(t)');

figure
plot(t_matched,x_matched);
title('Matched filter output');
xlabel('t');
ylabel('y(t)');

N=fs/f0; % Number of samples per period
[peaks x_amplitude]=window_max(x_matched,N,threshold);

t_detected=t_matched(peaks==1);

% Match impulse response with itself
h_match=matched_filter(x_filter,x_filter);
t_hm=Ts*(0:length(h_match)-1);
t_hm=t_hm+t_filter(1)-t_filter(end);
[h_peaks h_amplitude]=window_max(h_match,N,threshold);
t_h_peaks=t_hm(h_peaks==1);
t_shift=t_h_peaks(1)-t_filter(1);

L=v*(t_detected(1)-t_shift);

figure
plot(t_matched,x_amplitude,t_detected,x_amplitude(peaks==1),'o');
title('Amplitude of matched filter response');
legend('Amplitude',['Incoming signal detected: Measured distance = ' num2str(L) ' m'],'Location','SouthOutside');
xlabel('t');
ylabel('Amplitude');

figure(subplot_handle)
subplot(2,2,4)
plot(t_matched,x_amplitude,t_detected,x_amplitude(peaks==1),'o');
title('Amplitude of matched filter response');
legend('Amplitude',['Incoming signal detected: Measured distance = ' num2str(L) ' m'],'Location','SouthOutside');
xlabel('t');
ylabel('Amplitude');

