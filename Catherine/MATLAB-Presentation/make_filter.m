+function [t x]=make_filter(filename,Ts,f0)

% [t x]=make_filter(filename,Ts)
% Generates filter waveform
% Inputs
% filename: name of filter waveform file (.mat)
% Ts: sample time
% f0: signal frequency
% Return values
% t: time vector
% x: values in log

pulse_file=open(filename); % Open file

% Pulse data
tt=pulse_file.tt;
xx=pulse_file.xx;

T_pulse=tt(2)-tt(1);

% Remove DC component
V_DC=sum(xx)/length(xx); 
xx=xx-V_DC;

% Find amplitude
x_max=zeros(size(xx));
T0=1/f0;
N=ceil(T0/T_pulse);

for k=1:length(x_max)
    k1=max(1,k-N);
    x_max(k)=max(xx(k1:k).^2);
end


% Find rising edge
for k=1:length(x_max)
    if x_max(k)>0.95*max(x_max)
        k_end=k;
        break
    end
end

tt=tt(1:k_end);
xx=xx(1:k_end);

% Convert to correct sampling frequency
t=tt(1):Ts:tt(end);
x=zeros(size(t));

j1=1;
j2=1;
for ii=1:length(x)
    for jj=j1:length(tt)
        if tt(jj)>t(ii)
            j1=jj-1;
            j2=jj;
            break
        end
    end
    
    x(ii)=((t(ii)-tt(j1))*xx(j2)+(tt(j2)-t(ii))*xx(j1))/T_pulse; % Linear interpolation
    
end

t=t-t(1); % Set start time to zero
x=x/abs(sqrt(sum(x.*x(end:-1:1)))); % Normalise
