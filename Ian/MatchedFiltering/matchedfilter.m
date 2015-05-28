clear; close all; clc;

%%

% A template is given
temp = randn(100,1)+5;
%x = 0:0.001:2*pi;
%temp = 2.5*sin(x)+2.5;
%temp = temp';

% Create a matched filter based on the template
b = flipud(temp(:));

% For testing the matched filter, create a random signal which
% contains a match for the template at some time index
x = [randn(2000,1); temp(:); randn(30000,1)];
n = 1:length(x);

% Process the signal with the matched filter
y = filter(b,1,x);

% Set a detection threshold (exmaple used is 90% of template)
thresh = 0.5;

% Compute normalizing factor
u = temp.'*temp;

% Find matches
matches = n(y>thresh*u);

% Plot the results
figure;
subplot(2,1,1);
plot(n,x,'-b', n(matches), x(matches), 'ro');
subplot(2,1,2);
plot(n,y,'-b', n(matches), y(matches), 'ro');


% Print the results to the console
%display(matches);
