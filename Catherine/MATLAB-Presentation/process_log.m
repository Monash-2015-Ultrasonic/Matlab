function x_signal=process_log(x_log,x_filter)

% x_out=process_log(x_in)
% Removes DC component and normalises log data
% Input
% x_in: vector of x values from log
% x_filter: impulse response of matched filter
% Return values
% x_out: vector of processed x values

% Remove DC component
x_dc=sum(x_log)/length(x_log);
x_signal=x_log-x_dc;

x_signal=max(abs(x_filter))/2^12*x_signal; % Normalise with respect to impulse response