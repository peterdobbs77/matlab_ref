%BIEN 3310 - Course Project: Movement Profiles and Disturbances Generation
function [DesPos, TorqueDist] = mj_SigGen_f17(caseNum)
% RUN FIRST: [DesPos, TorqueDist, PropDrift] = BIEN3310_Proj_f13_SigGen(caseNum) ;
% Input: caseNum - specifies which of the 3 test profiles to generate
%   1 = Bandlimited tracking only (no disturbance)
%   2 = Low frequency bandlimited tracking with pulse torque distrubances
%   3 = Step tracking and stabilization
%
% Output: Separate structures containing desired position (DesPos),
%   torque disturbance (TorqueDist) and proprioceptive drift (PropDrift).
%   RefPos replicates the desired position 
%   information in a matrix format for inclusion into the plant model.
%   Structure form, e.g.,
%     DesPos.time            - sampled time points
%     DesPos.Signals.values  - signal values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global RefPos; %global DesPos;  global TorqueDist

T = 20;                   % Signal duration (sec)
dt = 0.005;               % Sampling interval (sec)
IndPerSec = floor(1/dt);  % Number of indices per second
t = [0:dt:T]';

PosDispDeg = 20;          % Position displacement (deg)
TorqueAmp = 6;            % Torque Amplitude (N-m)

switch caseNum
  case 1   %Bandlimited position tracking, sequence generation (rad)
    rms=PosDispDeg*pi/180;  %Desired RMS ampl of temporal signal (rad}
    f_low = 0.4;              %low freq limit of bandlimited signal (Hz)
    f_high= 1.2;              %high freq limit of bandlimited signal (Hz)
    bandwidth = [f_low f_high]*2*pi; %radian frequency
    [pos,Amps] = genSignal(T,dt,rms,bandwidth,0);
    torquedist = zeros(1,length(t));
    torquedist((length(t)-2000):length(t)) = 6.0; 
              
  case 2  %Low frequency tracking with random pulse torques
    % Sequence generation for bandlimited position signal (rad):
    rms=PosDispDeg*pi/180;  %Desired RMS amplitude of temporal signal (signal units) {angular position: rad}
    f_low = 0.2;      %low frquency limit of bandlimited signal (Hz)
    f_high= 0.8;      %high frequency limit of bandlimited signal (Hz)
    bandwidth = [f_low f_high]*2*pi; %radian frequency
    [pos,Amps] = genSignal(T,dt,rms,bandwidth,0);
    % Sequence generation for pseudo-random torque pulse sequence (N-m)
    torquedist = zeros(1,length(t));
    n=1;
    while n < length(t)
      tqOnset = n+10+floor(IndPerSec*(5*rand));   %Select a pulse onset (within 5 sec of previous pulse)
      tqOffset = tqOnset+10+floor(IndPerSec*3*rand); %Select a pulse offset (interval [0,3] sec)
      if tqOffset < length(t)
         torquedist(tqOnset:tqOffset) = TorqueAmp*2*(rand-0.5);   %Randomly select torque amplitude from [-TorqueAmp, TorqueAmp]
      else
         torquedist(tqOnset:length(t)) = TorqueAmp*2*(rand-0.5);
      end
      n = tqOffset;   
    end
   
  case 3 %Step tracking and stabilization 
    % Fixed sequence of step shifts in "desired position" 
    % Step displacements have min amplitude of 10 deg & duration of 1 sec
    Displacement = [20 -60 40 50 -80 30];  % deg rel to current pos
    stepOnset    = [1   3   7  11  14  16];   % sec 
    OnsetInd = floor(stepOnset./dt);       % sample index of step onset
    pos = zeros(1,length(t));
    n = OnsetInd(1);
    for j = 1: length(stepOnset)-1   %Set position displacmenet in rad
      pos(n+1:OnsetInd(j+1)) = pos(n) + Displacement(j)*pi/180; 
      n = OnsetInd(j+1);
    end
    pos(n+1:end) = pos(n) + Displacement(end)*pi/180;
    %Add torque pulses at 4 sec and opposite at 8 sec 
    torquedist = zeros(1,length(t));
    tqOnset = floor([4/dt 8/dt 18/dt]);
    tqDuration = floor(2.0/dt);
    torquedist(tqOnset(1):tqOnset(1)+tqDuration) = -8;   %N-m
    torquedist(tqOnset(2):tqOnset(2)+tqDuration) = 6;    %N-m
    torquedist(tqOnset(3):tqOnset(3)+tqDuration) = 6;    %N-m
        
  otherwise
    error('Case specified outside range (1-3)')
end

%Create Signal structures (for Simulink):
DesPos.time = t;      DesPos.signals.values = pos';  RefPos = pos;
TorqueDist.time = t;  TorqueDist.signals.values = torquedist';
%PropDrift.time = t;  PropDrift.signals.values = propdrift';

figure(1); set(1,'Color',[1 1 1]);
  subplot(2,1,1), plot(DesPos.time, DesPos.signals.values, 'k', 'LineWidth', 2);
  subplot(2,1,1), title ('Desired Position'), xlabel('Time (s)'), ylabel('Desired Pos (rad)');
  subplot(2,1,2), plot(TorqueDist.time, TorqueDist.signals.values, 'b', 'LineWidth', 2);
  subplot(2,1,2), title ('Torque Disturbance'), xlabel('Time (s)'), ylabel('Torque Disturb (N-m)');
  %subplot(3,1,3), plot(PropDrift.time, PropDrift.signals.values, 'r', 'LineWidth', 2);
  %subplot(3,1,3), title ('Proprioceptive Drift'), xlabel('Time (s)'), ylabel('Prop Drift (rad)');

return

function [S,Amps] = genSignal(T,dt,rms,bandwidth,randomSeed)
% Generates white noise random signal with normal power over specified BW
%-------INPUTS--------
% "bandwidth" is a 1x2 vector containing the low and high frequency cutoff
%   of the random signal (rad/s).
% "randomSeed" contains a seed value for the random number generator to use.
%   A positive fixed seed will result in the same signal being generated for each
%   function call. If randomSeed is set to zero, a new seed is chosen for
%   each call to the function. If randomSeed is negative the existing state
%   of the random number generator is used.
%-------OUTPUTS--------
% "S" is 1xNt vector containing amplitude at each time, where Nt = floor(T/dt) + 1.
% "Amps" is 1xNt vector of complex values containing amplitudes (and phase) 
%        of the fourier coefficients used to create the signal.

N = 2*floor(T/(2*dt))+1;            % Number of samples
domega = 2*pi/T;                    % Frequency stepsize
omega = domega*[0:(N-1)/2];         % Frequency range

N = length(omega);
Amps_pos = zeros(1,N)+i*zeros(1,N); % Zero Fourier coefficients
index = find((abs(omega)<=bandwidth(2))&(abs(omega)>=bandwidth(1))); % Determine indices within BW (i.e., with nonzero coefficients)
num = length(index);
if randomSeed > 0
    randn('state',randomSeed);
elseif randomSeed == 0      % otherwise use current state of random num gen
    randn('state', sum(10000*clock));
end
Amps_pos(index) = (randn(1,num)+i*randn(1,num));  % Assign random coefficients to the bandpass indices

Amps = [Amps_pos,fliplr(conj(Amps_pos(2:end)))];  % Add negative frequency components in FFT cormat (flip and append the complex conjugates)
S = real(ifft(Amps));              % Take inverse FFT to obtain time series of random signal

rmsS = sqrt(sum(S.^2)/length(S));  % Compute rms power for the randomly generated signal
S = S*(rms/rmsS);                  % Scale power of randomly generated signal to value passed to function

Amps = Amps*(rms/rmsS);
