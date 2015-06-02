function x_out=matched_filter(x_filter,x_signal)

% x_response=matched_filter(x_filter,x_signal)
% Applies matched filtering to signal vector
% Inputs
% x_filter: matched filter impulse response
% x_signal: signal vector
% Return values
% x_out: filter output

x_out=zeros(1,length(x_signal)+length(x_filter)); % Initialise x_out
x_filter=x_filter(end:-1:1); % Time reflect impulse response

for k=1:length(x_out)
    
    % Matching window
    s1=max(1,k-length(x_filter)+1);
    s2=min(length(x_signal),k);
    f1=max(1,length(x_filter)-k+1);
    f2=min(length(x_filter),length(x_signal)+length(x_filter)-k);
    
    x_out(k)=sum(x_filter(f1:f2).*x_signal(s1:s2)); % Convolution
    
end