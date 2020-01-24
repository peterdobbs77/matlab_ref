function [sys,x0,str,ts] = mj_sim_elb_f17(t,x,u,flag) 
% BIEN 33100 - LINEAR MUSCLE-JOINT-APPARATUS MODEL(S): MJMOD
% Function Layout:
% mjmod()      -> overall muscle-joint-apparatus model
% - mparms     -> gets muscle-joint parameters (linear case)
% - flin       -> gets state representation for linearized model
% - do_plots   -> does plotting 
% clear;  clf;  hold off;
%====================================================================
  persistent y_all; persistent x_all; persistent u_all; persistent t_all;
  persistent nn;   persistent i1_all; persistent i3_all; persistent nsamp;
  persistent A; persistent B; persistent C; persistent D; persistent Ao;
  persistent kp1; persistent kp2; persistent Jp;  persistent fmax;
  persistent Cpos; persistent Dpos; persistent vnl;
 
  switch flag,
     
    case 0,    % Initialization, for Simulink and M-J Model
      sizes = simsizes;                               % These 5 for Simulink
      sizes.NumContStates  = 6;  sizes.NumDiscStates  = 0;
      sizes.NumOutputs     = 3;  sizes.NumInputs      = 3;
      sizes.DirFeedthrough = 1;  sizes.NumSampleTimes = 1;
      sys = simsizes(sizes);  str = [];  ts  = [0 0]; % m-by-2 t_sample (per, off)
     
      [fmax,Ks,Bh,tc,rm,Kp,Bp,Jp,kp1,kp2] = mparms() ;     % Getting linearized params
      [A,B,C,D] = flin(fmax,Ks,Bh,tc,rm,Kp,Bp,Jp); % Getting A,B,C,D  
      Ao = A;
      x0 = zeros(6,1);        % 6 states, zero for now
      nn = 0;  i1_all = 0;  i3_all = 0;  nsamp = 3;  % save all, but sample
      t_all = [0; 0]; x_all = [x0';x0']; u_all = zeros(2,3); y_all = zeros(1,3);
      %figure; 
      sys_mj_ss = ss(A,B,C,D);                % SS model, for other use
      %sys_mj_tf = tf(sys_mj_ss);             % tf model 
      %sys_mj_zp = zpk(sys_mj_ss);            % zpk model
    case 1,      % d_states
      if nn == 0
        x0 = -inv(A)*B*u;     % Getting init states at t=0x0 = zeros(2,1);
      end 
      A(3,:) = (1.5*(x(3)/fmax.l)+0.5)*Ao(3,:);  % mild bilinear flexor SE spring 
      A(4,:) = (1.5*(x(4)/fmax.r)+0.5)*Ao(4,:);  % mild bilinear extensor SE spring
      %display(A(3,1),fmax.l)
      sys = A*x + B*u ; %'?   % this is then used for numerical integration
      if x(5,1) >= 0          % nonlinear addition for joint PE
         sys(6,1) = sys(6,1) - (kp1.l*(exp(kp2.l*(abs(x(5,1)))-1.0)))/Jp;
      else
         sys(6,1) = sys(6,1) + (kp1.r*(exp(kp2.r*(abs(x(5,1)))-1.0)))/Jp;
      end
      vnl = sys(6,1);
      if i1_all == 0
         t_all = [t_all; t]; u_all = [u_all; u'];  x_all = [x_all; x'];
         i1_all = -1*nsamp;  % default of 3, for using ode3 (3 calls/delt)
      end
      i1_all = i1_all + 1;
      
    case 3,      % outputs
        nn = nn + 1;
        sys = C*x + D*u;  % sys(3) = vnl;
        if i3_all == 0
          y_all = [y_all; sys'];  i3_all = -1*nsamp;
        end
         i3_all = i3_all + 1;
       
    case { 2, 4 },
       sys = [];
    case 9,      % last call
       sys = [];
       %sys_mj_ss1 = ss(A,B,Cpos,Dpos)     % take off ";" to print
       sys_mj_ss1 = ss(A,B,C(2,:),D(1,:));     % take off ";" to print
       do_plots(t_all,u_all,x_all,y_all);
       %bode(sys_mj_ss1)

    otherwise
       DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));
  end 
 end
 
%======================================================================
function [fmax,Ks,Bh,tc,rm,Kp,Bp,Jp,kp1,kp2] = mparms() 
% 1. We assume a "moment-angle" form for muscle force generation,
%    The model includes a simple CE with a dashpot (B) in series with a 
%    SE spring (Ks).  There is also a passive plant (Kp, Bp, Jp) 
%    There are no bicausal motor or apparatus dynamics here, just a torque
% 2. Default linearized muscle-joint properties are for a "typical"
%    70 Kg male.  Typical female is about 80% of fmax values.     
%  Linearized Muscle, for Elbow:
   fmax.l = 60.;  fmax.r = 50.; % ELBOW max musc "force" in Nm for F-E
   Bh.l = 2.0;  Bh.r = 1.5;  % ELBOW Defaults- CAN CHANGE! (range ~0.2-5, <1 if low)
   Ks.l = 120.;  Ks.r = 80.; % ELBOW SE K's, in Nm/rad
   tc_act = 0.025;  tc_deact = 0.045;  tc_ave = (tc_act + tc_deact)/2.0;
   tc.l  = tc_ave; tc.r = tc_ave;  % Linear: ELBOW ave time const
%  Joint-Forearm  & ELBOW Apparatus:  (here for elbow)
   Kp = 4.0   ;   % ELBOW passive joint elasticity, in Nm/rad
   Bp = 2.0   ;   % ELBOW passive joint viscosity, in Nms/rad
   Jp  = 0.06 ;   % ELBOW forearm inertia, in kg-m^2, or Nms^2/rad
   kpsh.l = 5.0;  kpxm.l = 75.0/57.296;  % dimensionless shape, +angle at jmax (deg)
   kpsh.r = 5.0;  kpxm.r = 75.0/57.296;  % dimensionless shape, -angle at jfmax
   kp1.l = fmax.l/(exp(kpsh.l-1.0)); kp2.l = kpsh.l/kpxm.l;  
   kp1.r = fmax.r/(exp(kpsh.r-1.0)); kp2.r = kpsh.r/kpxm.r;  
%  TF's:
   rm.l = 1.0 ; % rl  = .04 ; % max flexor moment, i.e. (mom arm)*Fmax_f
   rm.r = 1.0 ; % rr = .03 ;  % max extensor moment, i.e. (mom arm)*Fmax_e

end

%======================================================================== %=======================================================================
 function [A,B,C,D] = flin(fmax,Ks,Bh,tc,rm,Kp,Bp,Jp)
 % A Matrix:
 %      Act.l  Act.r  Fm.l   Fm.r   Mkp    Vj      
  A = [-1/tc.l   0      0      0     0      0     ;   % 1st-order activ left
        0   -1/tc.r     0      0     0      0     ;   % 1st-order active rgt
   fmax.l*Ks.l/Bh.l 0  -Ks.l/Bh.l  0  0  -rm.l*Ks.l ; % left musc F
        0 fmax.r*Ks.r/Bh.r 0 -Ks.r/Bh.r 0   rm.r*Ks.r ; % right musc F (-)
        0      0      0      0     0        1     ;    % joint angle (rad)
        0      0   rm.l/Jp -rm.r/Jp -Kp/Jp -1/(Jp*Bp)]  ;   % eq of motion
 % B Matrix:
  B = [ 1/tc.l  0   0  ;    % activation to left muscle, given norm in
         0  1/tc.r  0  ;    % activation to right muscle, given norm in
         0       0       0  ;
         0       0       0  ;
         0       0       0  ;
         0       0     1/Jp ];  % ext moment in to velocity state
%==================================================================
% C & D Matrices for OUTPUT EQUATIONS:
C = [    0   0   rm.l -rm.r  0   0  ; % active musc torque 
         0   0   0      0    1   0  ;    % joint position
         0   0   0      0    0   1 ] ;    % joint velocity
D = [zeros(3,3)] ;
       
Cpos = [  0   0   0   0 -1/Kp  0 ];    % joint position
Dpos = [0 0 0];
end

%==================================================================
%  PLOTTING:
 function [] = do_plots(tt,uu,xx,yy) 
  global RefPos; %global TorqueDist;
  tmax = 20.;                  % tmax - might change
  PosRef = [RefPos(1) RefPos]; %DesPos.signals.dimensions
  figure(2); set(2,'Color',[1 1 1]);
   subplot(3,1,1); hold on;   % Desired Angle, Joint Angle (OUTPUT)
      plot(tt,yy(:,2),'LineWidth',2); hold on;
      plot(tt,PosRef); 
      ylabel('Jnt Ang (r)')
      axis([0,tmax,-1.5,1.5]); set(gca,'Fontsize',8);

   subplot(3,1,2); hold on;     % Disturbance (Torque)
      %TorqVal = [0 TorqueDist]; % length(TorqueVal)
      plot(tt,zeros(length(tt)),tt,uu(:,3),'-',tt,yy(:,1),'--');
      ylabel('Ext & Musc Torque, (Nm)')
      axis([0,tmax,-20,20]); set(gca,'Fontsize',8); 
      
   subplot(3,1,3); hold on;    % Uneuro (PLANT INPUT), Xactivation
      plot(tt,uu(:,1),'r-', tt,-uu(:,2),'r-');   % neuro in - PLANT INPUTS 1 & 2 
      plot(tt,xx(:,1),'b--', tt,-xx(:,2),'b--'); % activ - STATES 1 & 2
      plot(tt,zeros(length(tt)));  ylabel('Nin, Xactiv')
      axis([0,tmax,-1,1]);  set(gca,'Fontsize',8); 
 
% PLOT SUBSET OF THESE, YOU PICK BEST FOR EACH OF CASES 1-4
   %subplot(4,1,4); hold on;    % Moments: Musc & Joint (INTERNAL STATES, SIGNALS)
      %plot(tt,xx(:,3)); plot(tt,-xx(:,4)); % Antag muscle pulls (STATES 3 & 4)
      %plot(tt,yy(:,1),'LineWidth', 2); % Active Muscle Torque (Flex-Exten - OUTPUT 1)
      %plot(tt,xx(:,5),'-.');           % Passive Joint Moment (Kp * STATE 5)
      %plot(tt,uu(:,3),'--');           % Mext - INPUT 3
      %plot(tt,zeros(length(tt)));  ylabel('Mom (Nm)')
      %axis([0,tmax,-30,30]);  set(gca,'Fontsize',8); 
            
   %subplot(4,1,4); hold on;     
      %plot(tt,yy(:,1),'g-');           % Active Muscle Torque (Flex-Exten - OUTPUT 1)
      %plot(tt,yy(:,3),'r-');           % Joint Velocity (rad/sec), OUTPUT 3 & STATE 6
      %plot(tt,zeros(length(tt)),'-');  % Line at 0
      %xlabel('Time (sec)'); ylabel('Out1,3 (Nm, r/s)')
      %axis([0,tmax,-5,5]); set(gca,'Fontsize',8);
 
 end
