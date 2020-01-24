% SIMPLE MACRO-MODEL OF THE HUMAN THERMOREGULATION SYSTEM (J. Winters)
% BIEN 3310 HW#3: to change any of 4 inputs see lines 45-48, init at 34-35 
% Default: mild (morning) exercise from 1 to 2 hrs (line 47), sweat from 
%    1.25 to 2:25 hrs (line 46), in cold (0 deg) from 7 to 9 hrs (line 45)
% At end is code for grid of Bode plots, and for getting SISO sub-models
clear;  clf;  hold off 
%==========================================================================
%  PARAMETERS:
%    Skin:         Muscle:         Core:
   Rs  = .1  ;   Rsm =  .05 ;    Rmc =  .02 ;      % R's in degC/(kcal/hr)
   Cs  =  8  ;   Cm  =  30  ;    Cc  =  22  ;      % C's in kcal/degC
   Rc  = .05  ;   Rcs = Rs + Rc;                   % adding in clothing

%==========================================================================
%  STATE EQUATIONS:
                                                               % A is 3 x 3
   A = [ -((1/Rcs)+(1/Rsm))/Cs     1/(Cs*Rsm)         0      ; % skin 
          1/(Cm*Rsm)     -((1/Rsm)+(1/Rmc))/Cm   1/(Cm*Rmc)  ; % muscle
            0                     1/(Cc*Rmc)    -1/(Cc*Rmc) ]; % core   

   B = [  1/(Cs*Rcs)  1/Cs      0       0      ;               % B is 3 x 4
            0          0       1/Cm     0      ;
            0          0        0      1/Cc ]  ;
%          Pamb       Fswt     Fmusc    Fcore (metab)          (inputs)
        
%  OUTPUT EQUATIONS:  (Note:  T_skin, T_core, H_sm-leaving)
   C = [ 1  0  0 ;  0  0  1 ;  -1/Rsm 1/Rsm 0 ] ;              % C is 3 x 3
   D = zeros(3,4) ;                                            % D is 3 x 4

   sys = ss(A,B,C,D);    % state space LTI model
%==========================================================================
%  INITIAL INPUTS & INITIALIZATION (by setting dx/dt=0, and solving for x):
%       Amb Temp  Sweating (-) Muscle  Core
   u0 = [  22.0 ;    -0.0 ;    5.0  ;  60.0 ]; % ===> USER: init in (Temp in degC)
   x0 = -inv(A)*B*u0          ;                % init states, given u0
   y0 =  C*x0 + D*u0          ;                % steady outputs, if u0 

   delt = .02 ;  tmax = 12    ;                % ===> USER: delt & tmax, in hours
   t = [0 : delt : tmax ]     ;                % Time vector
   u = ones(length(t),1)*u0'  ;                % Default: init inputs 
   freq = 1/24.0              ;                % Default: freq once/day

%==========================================================================
% Getting INPUT SEQUENCE: (can switch levels and/or add sinusoid)
 ton(1)= 1.  ; toff(1)= 4.;   Unew(1)= -15.;   Usin(1)= 0.0; % ==> Pamb (Tambient, +-5 degC for day vs night)
 ton(2)= 1.25; toff(2)= 4.25; Unew(2)= -50.;  Usin(2)= 0.0; % ==> Fswt (sweat rate)
 ton(3)= 1.0 ; toff(3)= 4.0 ; Unew(3)= 500.;  Usin(3)= 0.0; % ==> Fmus (muscle rate)
 ton(4)= 10.;  toff(4)= 10.5; Unew(4)= 100.;  Usin(4)= 0.0; % ==> Fcor (core rate)

 for ii = 1 : 4
    if ton(ii) < tmax
       if ton(ii) < toff(ii)
         tswon  = length([0 : delt : ton(ii)] ) ; 
         tswoff = length([0 : delt : toff(ii)]) ;
         u(tswon:(tswoff-1),ii) = Unew(ii)*ones(tswoff-tswon,1) ; % new magn
       end
    end    
    for i = 1 : length(t)
       tt = i*delt ; 
       u(i,ii) = u(i,ii) + Usin(ii)*sin(2*pi*freq*tt) ; % sinusoid input 
    end
 end
  %========================================================================
%  LET'S DO IT:  (simulation run)
   [y,x] = lsim(A,B,C,D,u,t,x0) ;       % Simulation run, using lsim

%    ode23('ftemp',[0:delt:tmax],x0)    % if nonlinear
%    y = C*x + D*u
%======================================================================+===
%  PLOTTING:   Temperatures in top plot, flows in bottom
   subplot(2,1,1);  plot(t,x);  hold on; plot(t,u(:,1));  % 3 states, ambient
     title('SIMULATED HUMAN THERMOREGULATION SYSTEM BEHAVIOR:')
     xlabel('Time (Hrs)');  ylabel('Temperature (deg C)')
     axis([0 12 -10 50]);
   subplot(2,1,2);  plot(t,u(:,2:4));         % 3 "heat rate" inputs
     hold on; plot(t,y(:,3));                   % output of rate leaving body
     xlabel('Time (Hrs)');  ylabel('Heat Flow (Kcal/Hr)')
%==========================================================================
%  Other stuff:
%  EXAMPLES FOR MIMO & SISO Transfer Function Extraction:
   sys_tf = tf(sys);                  % gives transfer matrix
   sys_tf(2,3);                       % gives tf from musc to core
%  FOR SISO REPRESENTATIONS, ANOTHER WAY (e.g., for SISOTOOL use)
   Bsiso1 = [ 1/(Cs*Rcs); 0 ; 0] ;    % if Pambient is input to "Process"
   Bsiso2 = [ 0 ; 1/Cm ; 0]  ;        % if Fmuscle is input to "Process"
   Csiso = [0 0 1 ] ;                 % assuming Pcore is output
   Dsiso = 0 ;
   sysss1 = ss(A,Bsiso1,Csiso,Dsiso); % SS for Pambient as input, Tcore out  
   systf1 = tf(sysss1) ;              % TF for Pambient as input, Tcore out
   syszp1 = zpk(systf1);              % ZPK version ...
