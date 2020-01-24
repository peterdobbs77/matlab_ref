%  SIMPLE MACRO-MODEL OF THE HUMAN CIRCULATORY SYSTEM
%  BIEN 3310 STUDENTS: See "USER:" (e.g., line 147-152 to change inputs)
%                      Also see lines 49-51 to change an R values
% Observations:
% 1. MACRO SERIES ANALYSIS TO SCOPE OUT R's:
%   a. A typical arterial BP is a little over 100 mmHg (say 105),
%      and in Vena Cava it's under 10 mmHg (perhaps 5); let's say, then,
%      that we want a pressure drop of 100 mmHg across system. Assuming
%      a blood flow of 5 l/min, the Total Peripheral Resistance (TPR) 
%      becomes 20 mmHg-min/l -- we need design model so that we get this.
%   b. We want to distribute the drop about like it is in the body. 
%      Let's figure out what we want, then determine a suitable geometry to
%      get there.  From parallel considerations, we also want at least 4 
%      "regions" (e.g., brain-heart, muscles, internal organs, skin), and 
%      thus at least 4 lumped arterioles (to distribute blood to organs).
%      R_l-art:  About 5% (or so) drop occurs 
%        across the large-med arteries, i.e. let R_l-art_eq = 1 mmHg-min/l
%        (as we'll see for a flow source, we'll put this in right R).
%      R_arterioles:  We want most of our pressure drop here, over 60%, 
%        i.e. let R_a_eq = 12 mmHg-min/l, or R_a_i_ave = 48 mmHg-min/l. 
%      R_caps: Let's have 20% of our pressure drop here, i.e. 
%        4 mmHg-min/l total, or 16 per cap bed, perhaps less.
%      R_veins: Let's have 5% here, i.e. 1 mmHg-min/l equiv, or 4 each.
%      R_vc:    We want only about 5% drop here, i.e. 1 mmHg-min/l.
%  2. Getting Vessel Geometry:  We now know what we want, so now let's
%      work backwards to solve for an appropriate vessel length,
%      given the desired R's and an assumed vessel diameter.  Once we 
%      have these lengths, we can determine the volume, and by using 
%      our assumed relative compliance (1%Vol/mmHg), we can estimate C's.
%  3.  We use Bond Graphs to get the state variables, and the state eqs.
%      (We assume a "bifurcation" pressure, and lump series R's at cap's.)
%  4.  Notice that our outputs include the port variables that were not
%      the inputs, i.e. P_valve and F_vena-cava; the latter approximates
%      the Cardiac Output, the former (and well as Pa) gives the standard
%      "blood pressure" we've all had measured.  We're also getting the
%      pressures and flows across the 4 capilary beds -- look at this! 
%  5.  We'll overplot all blood pressures (states, P_valve, average across
%      cap beds), and all blood flows (outflow, capillary bed flows).
%  6.  Make sure to label graphs and describe what they mean in detail!
%========================================================================== 
   clear
   clf
   hold off
%=========================================================================
%  Desired Resistances (function of task): 
%  Heart could be with brain (e.g., hemorrhage) or musc (e.g., exercise)
%  Some default values (based on "series" comments, but to overplot OK)   
%            brain       int-org    skel-musc   skin-fat
   Ra = 1;   R1 = 75;    R2 = 40;   R3 = 50;    R4 = 60;  % ave ~48 for arts
            R1C = 16;   R2C = 11;  R3C = 13;   R4C = 15;  % ave ~15 for caps
   Rv = .5;  R5 = 8;     R6 = 5;    R7 = 6;     R8 = 7;   % ave ~6 for veins
%            (R#C = .5R#_ario + R#_cap + .5*R#_ven)

%  Hint: default flows ~ 20% in ht-br, 35% int-or, 25% musc, 20% skin-fat
%  Hint: default flows ~ 15% in br, 35% int-or, 30% musc-ht, 20% skin-fat
%  Hint: smaller thin people ~ lower cadiac output, less flow to fat

%  Assumed/Required Geometry:  (vessel radius, length)
%  r_l-a = 1 cm; r_ario =.1 mm; r_cap = 10 um;  r_ven =.1 mm; r_vc = 1 cm 
%  L_l-a =62 cm; L_ario = 3 mm; L_cap =  1 mm;  L_ven = 3 mm; L_vc =62 cm 
%  n_caps = 2.7 million in each bed

%  Compliances: (note: had to scale these some to get good behavior, while
%                maintaining the known relative compliance between regions)
   Ca = .04 ;  Cb = .03 ;  Cv = .2  ;  Cw = .2  ;   % large art, veins
   C1 = .01 ;  C2 = .01 ;  C3 = .01 ;  C4 = .01 ;   % arterioles, 4 paths
   C5 = .05 ;  C6 = .05 ;  C7 = .05 ;  C8 = .05 ;   % venules, 4 paths

%=========================================================================

%  STATE EQUATIONS:

%  A is a 12 x 12:
   CRb = ((1/Ra) + (1/R1) + (1/R2) + (1/R3) + (1/R4))/Cb ; % element 2,2
   CRw = ((1/Rv) + (1/R5) + (1/R6) + (1/R7) + (1/R8))/Cw ; % element 11,11

%  |  Artery  |<--  Arterioles   -->|<--  Small Veins -->| Bif & Vein |
%  |  Pa  Pb  |  P1   P2   P3   P4  |  P5   P6   P7  P8  |  Pw    Pv  | 
A = [
   -1/(Ca*Ra)  1/(Ca*Ra)  0   0   0   0   0   0   0   0   0   0       ; %Pa 
   1/(Cb*Ra) -CRb 1/(Cb*R1) 1/(Cb*R2) 1/(Cb*R3) 1/(Cb*R4) 0 0 0 0 0 0 ; %Pb
    0  1/(C1*R1) -(1/R1+1/R1C)/C1 0  0  0  1/(C1*R1C) 0  0  0  0  0   ; %P1   
    0  1/(C2*R2)  0 -(1/R2+1/R2C)/C2 0  0  0  1/(C2*R2C) 0  0  0  0   ; %P2   
    0  1/(C3*R3)  0  0 -(1/R3+1/R3C)/C3 0  0  0  1/(C3*R3C) 0  0  0   ; %P3 
    0  1/(C4*R4)  0  0  0 -(1/R4+1/R4C)/C4 0  0  0  1/(C4*R4C) 0  0   ; %P4 
    0  0  1/(C5*R1C) 0  0  0  -(1/R5+1/R1C)/C5 0  0  0  1/(C5*R5) 0   ; %P5
    0  0  0  1/(C6*R2C) 0  0  0  -(1/R6+1/R2C)/C6 0  0  1/(C6*R6) 0   ; %P6
    0  0  0  0  1/(C7*R3C) 0  0  0  -(1/R7+1/R3C)/C7 0  1/(C7*R7) 0   ; %P7
    0  0  0  0  0  1/(C8*R4C) 0  0  0  -(1/R8+1/R4C)/C8 1/(C8*R8) 0   ; %P8
   0 0 0 0 0 0 1/(Cw*R5) 1/(Cw*R6) 1/(Cw*R7) 1/(Cw*R8) -CRw 1/(Cw*Rv) ; %Pw 
    0  0  0  0  0  0               0  0  0  0    1/(Cv*Rv)  -2/(Cv*Rv)];%Pv

%  B is a 12 x 2:  
   B = [1/Ca 0;  0 0;  0 0;  0 0;  0 0;  0 0;           % flow in (from LV)
           0 0;  0 0;  0 0;  0 0;  0 0; 0 1/(Cv*Rv) ] ; % pres out (VC dump)

%  OUTPUT EQUATIONS:
%  Let's assume 4 (or 8, or 12) Outputs:  
%      1. pressure at inport (p_1), 2&3. bifurcation pressures, 
%      4. flow out (f_106)
%    5-8. capillary pressures (weights: 40% P_art, 60% P_ven due to bias)
%   9-12. capillary bed flows (these are good to estimate!) 
%     Pa Pb P1 P2 P3 P4 P5 P6 P7 P8 Pw Pv;  C is a 4x12 or 6x12 or 12x12 (default)
C = [ 1  0  0  0  0  0  0  0  0  0  0  0 ;  % valve-aorta pressure
      0  1  0  0  0  0  0  0  0  0  0  0 ;  % artery bifurcation
      0  0  0  0  0  0  0  0  0  0  1  0 ;  % vein befurcation
      0  0  0  0  0  0  0  0  0  0  0 1/Rv; % ]; % flow out (into heart)
      0  0 .4  0  0  0 .6  0  0  0  0  0 ;  % ~cap pressure: brain (or brain-heart
      0  0  0 .4  0  0  0 .6  0  0  0  0 ;  % ~cap pressure: intern organs
      0  0  0  0 .4  0  0  0 .6  0  0  0 ;  % ~cap pressure: muscle (or musculoskeletal)
      0  0  0  0  0 .4  0  0  0 .6  0  0 ;  % ~cap pressure: skin-fat
      0  0 1/R1C 0 0 0 -1/R1C 0 0 0 0  0 ;  % cap bed flow: brain (or brain-heart)
      0  0  0 1/R2C 0 0 0 -1/R2C 0 0 0 0 ;  % cap bed flow: intern organs
      0  0  0 0 1/R3C 0 0 0 -1/R3C 0 0 0 ;  % cap bed flow: muscle (or musuloskel)
      0  0  0 0 0 1/R4C 0 0 0 -1/R4C 0 0 ]; % cap bed flow: skin-fat

%  D is a 4 x 2 (or 12 x 2):
   D = [ Ra 0;  0 0;  0 0;  0 -1/Rv;  0 0;  0 0;  
          0 0;  0 0;  0 0;      0 0;  0 0;  0 0 ] ;
   sys = ss(A,B,C,D);  
   sys_tf = tf(sys);
%=======================================================================
%  Some SISO TF Models (for HW#3):
   Bsiso  = [ 1/Ca ; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0 ];  % 1st input, flow in
   Csiso1 = [ 1  0  0  0  0  0  0  0  0  0  0  0 ];      % aortic pressure
   Csiso2 = [ 0  0  0  0  0  0  0  0  0  0  0 1/Rv ];    % flow in VC, ~card out
   Csiso3 = [ 0  0 1/R1C 0 0 0 -1/R1C 0 0 0 0  0 ] ;     % cap brain flow 
   Dsiso1 = [ Ra ] ;  Dsiso2 = [ 0 ] ;  Dsiso3 = [ 0] ;  % direct path
   sys_ssc1 = ss(A,Bsiso,Csiso1,Dsiso1);  % SS for Pambient as input, Tcore out  
   sys_tfc1 = tf(sys_ssc1) ;              % TF for Pambient as input, Tcore out
   sys_zpc1 = zpk(sys_tfc1);              % ZPK version ...
   sys_ssc2 = ss(A,Bsiso,Csiso2,Dsiso2);  % SS for Fmusc as input, Tcore out
   sys_tfc2 = tf(sys_ssc2) ;              % TF for Fmusc as input, Tcore out
   sys_zpc2 = zpk(sys_ssc2);              % ZPK version ...
   sys_ssc3 = ss(A,Bsiso,Csiso3,Dsiso3);  % SS for Fmusc as input, Tcore out
   sys_tfc3 = tf(sys_ssc3) ;              % TF for Fmusc as input, Tcore out
   sys_zpc3 = zpk(sys_ssc3);              % ZPK version ...
%=======================================================================
%  Let's INITIALIZE by setting dx/dt = 0, and solving for x:
   u0 = [4.5 ;  4]     ; % initial inputs at t=0: 1. flow in; 2. P_Vena-Cava 
   x0 = -inv(A)*B*u0 ; % initial states for system, given u0
   y0 = C*x0 + D*u0  ; % steady outputs if these inputs remain steady

%  Getting INPUT SEQUENCE:
%  Notes: Let's start with an assumption of a heart rate of 60 beats/min, 
%    or freq = 1 Hz, and a default Cardiac Output of ~5 l/min. 
%    This code, with tsw, allows you to shift this drive from the heart
%    once (if you want), thus allowing 2 sequential simulations
   delt  = 0.01 ;  tmax = 10.0 ;    % ===> USER: might change tmax (in sec)
   t = [0 : delt : tmax ] ;         % time vector for simulation
   freq  = 1.2;  card_out  = 5 ;    % ===> USER: Cardio-Drive #1
   tsw = tmax/2 ;                   % ===> USER: for 2 drives, e.g. tsw = tmax/2
   freq2 = 2.2;  card_out2 =  15;     % ===> USER: Cardio-Drive #2 (if using)
   u_pres_vc = 5.0;                 % ==> USER: Vena Cava "dumping" P_input, mmHg
%  Using above to obtain driving inputs  
   u = zeros(length(t),2) ;          % init to right size, all to zero
   sq2 = sqrt(2) ;
   for i = 1:length(t)
     tt = i*delt ;
     if tt < tsw
        u(i,1) = card_out ;          % ~ave inflow (Cardiac Out)
        u(i,1) = u(i,1)*2*sq2*sin(2*pi*freq*tt);% 1/2 sine: "stroke volume" flow from heart
     else 
        u(i,1) = card_out2 ;         % ~ave inflow (~Card Out, 2nd half if using)
        u(i,1) = u(i,1)*2*sq2*sin(2*pi*freq2*(tt-tsw));% 1/2 sine2: flow from heart (if using)
     end
     if u(i,1) < 0       
        u(i,1) = 0 ;                 % 1-way, no back-flow (valve)
     end
     u(i,2) = u_pres_vc ;            % Vena Cava "dumping" P_input, mmHg
  end

%=======================================================================
%  SIMULATION RUN:

   [y,x] = lsim(A,B,C,D,u,t,x0) ;  % needed to provide all 7!

%=======================================================================
%  PLOTTING:  Pressures on left plots, flows on right plots
   subplot(2,2,1);  plot(t,x);  hold on; grid on;     % Plot 12 States (Pressures)
   title('CIRCULATORY SYSTEM STATES:')               
   xlabel('Time (sec)');  ylabel('Blood Pressure (mmHg)')
   axis([0 tmax 0 200]);

   subplot(2,2,2);  plot(t,u(:,1)); hold on; grid on;     
   plot(t,y(:,4));   hold on;        % I/O Flows (Fin to aorta, Fout at vena cava)
   xlabel('Time (sec)');  ylabel('Blood I/O Flow (l/min)')

   subplot(2,2,3);  hold on;  plot(t,y(:,1));  
   hold on;  plot(t,y(:,5:8)); hold on; grid on;
   plot(t,u(:,2)); hold on;          % I/O Pressures (Pout for aorta, low Pin for vena cava
   axis([0 tmax 0 200]);
   title('CIRC SYSTEM PRESSURE I/O, Caps:')
   xlabel('Time (sec)');  ylabel('Blood Pressure (mmHg)')

   subplot(2,2,4); hold on; plot(t,y(:,9:12)); hold on; grid on;   % Output of 4 Blood Caps
   xlabel('Time (sec)');  ylabel('Blood Caps Flow (l/min)')

%=======================================================================
% Hints for human exercise. Start with a "macro-analysis":  dP = TPR*CO.
% Normally during exercise the blood pressure raises only moderately.
% Thus to keep it about the same, if CO (Cardiac Output) was to double,
% the TRP (Total Peripheral Resistance) should be roughly cut in half,
% primarily by lowering the R for muscles (i.e. opening these vessels
% up).  The blood flow to the brain-heart can increase some, but not
% much; thus its associated R may need to increase.  The R to the
% internal organs can also increase (unless you just ate).  The R to 
% the skin is, of course, temperature sensitive -- could be higher or
% lower.  