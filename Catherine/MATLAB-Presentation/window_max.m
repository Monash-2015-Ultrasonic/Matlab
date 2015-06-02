function [peaks x_out]=window_max(x_in,N,threshold)

% x_out=window_max(x_in,N)
% Finds maximum amplitude within a window of length N
% Inputs
% x_in: input signal vector
% N: length of window
% threshold: noise threshold
% Return values
% peaks: vector with ones at global peaks
% x_out: vector of maximum values

% Initialise outputs
x_out=zeros(size(x_in));
peaks=x_out;
N=ceil(N);

for k=1:length(x_out)
    
    k_end=min(k+N-1,length(x_in)); % End of window
    x_out(k)=max(abs(x_in(k:k_end))); % Window maximum
    
    if x_out(k)>threshold
        if k==1
            peaks(k)=1;
        elseif x_out(k)>x_out(k-1) % Positive gradient
            peaks(k-1)=0;
            peaks(k)=1;
        elseif x_out(k)==x_out(k-1) % Zero gradient
            peaks(k)=peaks(k-1);
            peaks(k-1)=0;
        else
            peaks(k)=0;
        end
    end
    
end
        
