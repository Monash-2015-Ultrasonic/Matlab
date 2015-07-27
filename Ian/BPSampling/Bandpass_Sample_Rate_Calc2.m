% Filename: Bandpass_Sample_Rate_Calc.m
%
%  Calculates acceptable Bandpass Sampling rate ranges 
%  based on an analog (continuous) signal's bandwidth 
%  and center freq.
%
%  Merely define bandwidth "Bw" and center frequency "Fc", in 
%  Hz, near line 22, for the analog bandpass signal and run the 
%  program.  [Example: Bw = 5, Fc = 20.]  Acceptable Fs sample  
%  rate ranges are shown in Figure 1 and displayed in Command window.
%
%  If the User defines a value for the BP sample rate Fs, near 
%  near line 28, then Figure 2 will show the locations of the 
%  positive and negative-freq spectral components after 
%  bandpass sampling.
%
%   Richard Lyons [November 2011]
%******************************************

clear, clc

Bw = 4000; % Analog signal bandwidth in Hz
Fc = 40e6 / (2^10); % Analog signal center freq in Hz

% ##############################################
% Define an Fs sample rate value below

Fs = 50e6 / (2^12); % Selected Fs sample rate in Hz
% ##############################################

disp(' '), disp(['Analog Center Freq = ',num2str(Fc),' Hz.'])
disp(['Analog Bandwidth = ',num2str(Bw),' Hz.']), disp(' ')

% *****************************************************
%  Compute % display the acceptable ranges of BP sample rate 
% *****************************************************
disp('----------------------------------')
disp('Acceptable Fs ranges in Hz:')
No_aliasing = 0;  % Init a warning flag
M = 1; % Initialize a counter

while (2*Fc + Bw)/(M+1) > 2* Bw
   FsMin = (2*Fc + Bw)/(M+1);
   FsMax = (2*Fc - Bw)/M;
   Fs_ranges(M,1) = FsMin;
   Fs_ranges(M,2) = FsMax;
   M = M + 1;
   disp([num2str(FsMin),' -to- ',num2str(FsMax)])
end
disp('----------------------------------')

% *****************************************************
%  Plot the acceptable ranges of BP sample rate 
% *****************************************************
figure(1), clf
title('Acceptable Ranges of Bandpass Sampling Rate')
xlabel('Freq (Hz)')
ylabel('This axis has no meaning')

for K = 1:M-1
   hold on
   plot([Fs_ranges(K,1),Fs_ranges(K,1)],[0.5,1.2],':g');
   plot([Fs_ranges(K,1),Fs_ranges(K,2)],[1,1],'-r','linewidth',4);
   axis([0.8*(2*Bw),1.1*max(Fs_ranges(1,2)), 0.8, 1.55])
end

plot([2*Bw,2*Bw],[0.5,1.2],'-b','linewidth',2);
text(2*Bw,1.45,'Bold red lines show acceptable Fs ranges')
text(2*Bw,1.35,'Blue line = Twice analog signal Bandwidth (2 x Bw)')
text(2*Bw,1.25,'(You can zoom in, if you wish.)')
hold off, grid on, zoom on

% **************************************************************
%  If Fs has been defined, plot spectrum of the sampled signal.  
% **************************************************************
% 
% Check if "Fs" has been defined
disp(' ')
if isempty(strmatch('Fs',who,'exact')) == 1; 
    disp('Fs sampling rate has NOT been defined.')
    % Fs does NOT exist, do nothing further.
else 
	% Fs is defined, plot the spectrum of the sampled signal.
        disp(['Fs defined as ',num2str(Fs),' Hz'])
	
    % To determine intermediate frequency (IF), check integer 
    %      part of "2Fc/Fs" for odd or even
	Temp = floor(2*Fc/Fs);
    if (Temp == 2*floor(Temp/2))
       disp(' '), disp('Pos-freq sampled spectra is not inverted.')
       Freq_IF = Fc -Fs*floor(Fc/Fs); % Computed IF frequency
	else
       disp(' '), disp('Pos-freq sampled spectra is inverted.')
       Freq_IF = Fs*(1 + floor(Fc/Fs)) -Fc; % Computed IF frequency
	end
    disp(' '), disp(['Center of pos-freq sampled spectra = ',num2str(Freq_IF),' Hz.'])

    % Prepare to plot sampled spectral range in Figure 2
    IF_MinFreq = Freq_IF-Bw/2;
    IF_MaxFreq = Freq_IF+Bw/2;
    
	figure(2), clf
	hold on
	plot([IF_MinFreq,IF_MaxFreq],[0.95, 1],'-r','linewidth',4);
	plot([Fs-IF_MaxFreq,Fs-IF_MinFreq],[1, 0.95],'-r','linewidth',4);
	plot([Fs,Fs],[0.5, 1.02],'-b','linewidth',2);
	plot([Fs/2,Fs/2],[0.5, 1.02],':b','linewidth',2);
    plot([IF_MinFreq,IF_MinFreq],[0.5, 0.95],':r');
    plot([IF_MaxFreq,IF_MaxFreq],[0.5, 1],':r');
    plot([Fs-IF_MaxFreq,Fs-IF_MaxFreq],[0.5, 1],':r');
    plot([Fs-IF_MinFreq,Fs-IF_MinFreq],[0.5, 0.95],':r');
    text(0.9*Fs,1.03,['Fs = ',num2str(Fs),' Hz'])
    text(0.8*Fs/2, 1.03,['Fs/2 = ',num2str(Fs/2),' Hz'])
    text(Fs/10,1.07,'(You can zoom in, if you wish.)')
    axis([0,1.2*Fs, 0.8, 1.1])
	
	hold off
	title('Red lines show spectral range of sampled signal')
    xlabel('Freq (Hz)')
	ylabel('This axis has no meaning')
	grid on, zoom on
    
    % ################################################################
    % Check if Fs is NOT in an acceptable freq range (aliasing occurs)
    Aliasing_Flag = 1; % Initialize a flag
    for K = 1:M-1 % Check each individual acceptable Fs range
        if Fs_ranges(K,1)<=Fs & Fs<=Fs_ranges(K,2)% & Fs<=Fs_ranges(K,2)
            % No aliasing will occur
            Aliasing_Flag = Aliasing_Flag -1;
        else, end
    end % End K loop
    if Aliasing_Flag == 1;  % Aliasing will occur
        text(Fs/10, 0.91, 'WARNING! WARNING!')
        text(Fs/10, 0.89, 'Aliasing will occur!')
    else, end
    zoom on
    % ################################################################
end