% ROOT LOCUS Examples: 1st-, 2nd- (e.g., JBK) & 3rd- (e.g., Thermoreg) order plants
% Sensor in one case, and then beginning P, I, PI & PID controllers
% Designed with example code for overplotting different models, and
% for generating all of impulse, step, and pulse-train inputs. For HW4 Prob 4
clear all;
hold off;

% Gplant:
sys_1   = tf([1],[0.3 1]);         % tf for 1st #1
sys_1b  = tf([1],[0.15 1]);        % tf for 1st #2
sys_2o  = tf([1],[0.1 2 7.5]);     % tf for 2nd, OD JBK
sys_2c  = tf([1],[0.1 2 10]);      % tf for 2nd, CD JBK
sys_2u  = tf([1],[0.1 2 20]);      % tf for 2nd, UD JBK
sys_3a  = zpk([],[-4 -2.5 -1],1);  % tf for Tamb to Tcore (poles -4,-2.5,-1)
sys_3m  = zpk([-1.5],[-4 -2.5 -1],0.6); % tf for Hmusc to Tcore (now also zero @-1.5)

% Gsensor, Gcontrollers:           % CAN CHANGE!  (these gains are very low)
sys_sp  = tf([0.5 1],[0.1 1]);     % Sensor (e.g., spindle)
sys_cp  = tf([1],[1]);             % P: Kp = 1
sys_ci  = tf([1],[1 0]);           % I: Ki = 1 (pole at 0)
sys_cc  = tf([1 3],[1 0]);         % PI: Default has zero -3;
kpid = 1;
sys_pid = kpid*tf([1 8 12],[1 0]); % PID:   Default has zeros at -2,-6, pole@0
sys_pid2= kpid*tf([1 3 2],[1 0]);  % PID2: Default has zeros at -1,-2, pole@0
sys_pid3= kpid*tf([1 15 50],[1 0]);  % PID2: Default has zeros at -5,-10, pole@0

%Gloop: Getting LTI Gloop models (with default low gains)
sys1_cp  = sys_1*sys_cp;          % start of Gloops for 1st-order plants
sys1_ci  = sys_1*sys_ci;
sys1_cc  = sys_1*sys_cc;
sys1_cc1 = sys_1b*sys_cc;
sys2o_cp = sys_2o*sys_cp;         % start of Gloops for 3 2nd-order plants (OD, UD, CD)
sys2o_ci = sys_2o*sys_ci;
sys2o_cc = sys_2o*sys_cc;
sys2o_pid= sys_2o*sys_pid;
sys2o_pid2= sys_2o*sys_pid2;
sys2o_pid3= sys_2o*sys_pid3;
sys2u_cp = sys_2u*sys_cp;
sys2u_ci = sys_2u*sys_ci;
sys2u_cc = sys_2u*sys_cc;
sys2u_cps = sys_2c*sys_cp*sys_sp;
sys2u_cis = sys_2c*sys_ci*sys_sp;
sys2u_ccs = sys_2c*sys_cc*sys_sp;
sys3a_cp = sys_3a*sys_cp;         % start of Gloops for 2 3rd-order plants (In: Tamb, Hmusc) 
sys3a_ci = sys_3a*sys_ci;
sys3a_cc = sys_3a*sys_cc;
sys3a_pid= sys_3a*sys_pid;
sys3a_pid2= sys_3a*sys_pid2;
sys3a_pid3= sys_3a*sys_pid3;
sys3m_cp = sys_3m*sys_cp;
sys3m_ci = sys_3m*sys_ci;
sys3m_cc = sys_3m*sys_cc;
sys3m_pid = sys_3m*sys_pid;
sys3m_pid2 = sys_3m*sys_pid2;
sys3m_pid3 = sys_3m*sys_pid3;

% Root Locus Plots:
P = pzoptions; P.XLabel.String = 'Re'; P.YLabel.String = 'Im'; % P.grid = 'on';
P.XLim = {[-20  5] };  P.XLimMode = 'manual';
P.YLim = {[-15 15]};  P.YLimMode = 'manual';
k1 = [0.1 0.5 1.0 5 10 50];   % these are collection of gains that can be adjusted, and added (after P)

figure(1); set(1,'Color',[1 1 1]);   % 1st-Order Plant Plots (P, I, PI)
P.XLim = {[-8 4]}; P.XLimMode = 'manual';
P.YLim = {[-6 6]};  P.YLimMode = 'manual';
subplot(2,4,1); P.title.String = '1st, Kp'; rlocusplot(sys1_cp,P); 
subplot(2,4,2); P.title.String = '1st, Ki'; rlocusplot(sys1_ci,P); 
subplot(2,4,3); P.title.String = '1st, Kc'; rlocusplot(sys1_cc,P); 
subplot(2,4,4); P.title.String = '1st, Kc, tau/2'; rlocusplot(sys1_cc1,P); 
subplot(2,4,5); step(sys1_cp/(1+sys1_cp)); grid on;
subplot(2,4,6); step(sys1_ci/(1+sys1_ci)); grid on;
subplot(2,4,7); step(sys1_cc/(1+sys1_cc)); grid on;
subplot(2,4,8); step(sys1_cc1/(1+sys1_cc1)); grid on;

figure(2); set(2,'Color',[1 1 1]);   % 2nd-Order Plant Plots (P, I, PI, pls sensor)
P.XLim = {[-25 5]}; P.XLimMode = 'manual';
P.YLim = {[-15 15]};  P.YLimMode = 'manual';
subplot(3,3,1); P.title.String = '2nd, OD, Kp'; rlocusplot(sys2o_cp,P);   % ,k1
subplot(3,3,2); P.title.String = '2nd, OD, Ki'; rlocusplot(sys2o_ci,P); % ,k1
subplot(3,3,3); P.title.String = '2nd, OD, Kc-PI'; rlocusplot(sys2o_cc,P); % ,k1
subplot(3,3,4); P.title.String = '2nd, UD, Kp'; rlocusplot(sys2u_cp,P); 
subplot(3,3,5); P.title.String = '2nd, UD, Ki'; rlocusplot(sys2u_ci,P);
subplot(3,3,6); P.title.String = '2nd, UD, Kc-PI'; rlocusplot(sys2u_cc,P); 
subplot(3,3,7); P.title.String = '2nd, CD, Kp-sp'; rlocusplot(sys2u_cps,P);
subplot(3,3,8); P.title.String = '2nd, CD, Ki-sp'; rlocusplot(sys2u_cis,P);
subplot(3,3,9); P.title.String = '2nd, CD, Kc-sp'; rlocusplot(sys2u_ccs,P);

figure(3); set(3,'Color',[1 1 1]);   % P,I,PI Plant Plots
P.XLim = {[-8 2]}; P.XLimMode = 'manual';
P.YLim = {[-4 4]};  P.YLimMode = 'manual';
subplot(2,3,1); P.title.String = '3rd, Ta->Tc, Kp'; rlocusplot(sys3a_cp,P); 
subplot(2,3,2); P.title.String = '3rd, Ta->Tc, Ki'; rlocusplot(sys3a_ci,P); 
subplot(2,3,3); P.title.String = '3rd, Ta->Tc, Kc'; rlocusplot(sys3a_cc,P); 
subplot(2,3,4); P.title.String = '3rd, Hm->Tc, Kp'; rlocusplot(sys3m_cp,P);
subplot(2,3,5); P.title.String = '3rd, Hm->Tc, Ki'; rlocusplot(sys3m_ci,P);
subplot(2,3,6); P.title.String = '3rd, Hm->Tc, Kc'; rlocusplot(sys3m_cc,P);

figure(4); set(4,'Color',[1 1 1]);   % PID 3rd-order Plant Plots
P.XLim = {[-8 2]}; P.XLimMode = 'manual';
P.YLim = {[-4 4]};  P.YLimMode = 'manual';
subplot(2,2,1); P.title.String = '3rd, Ta->Tc,PID'; rlocusplot(sys3a_pid,P); 
subplot(2,2,2); P.title.String = '3rd, Ta->Tc,PID2'; rlocusplot(sys3a_pid2,P); 
subplot(2,2,3); P.title.String = '3rd, Hm->Tc,PID'; rlocusplot(sys3m_pid,P);
subplot(2,2,4); P.title.String = '3rd, Hm->Tc,PID2'; rlocusplot(sys3m_pid2,P);  

figure(5); set(5,'Color',[1 1 1]);   % PID 2nd-order Plant Plots
P.XLim = {[-20 5]}; P.XLimMode = 'manual';
P.YLim = {[-15 15]};  P.YLimMode = 'manual';
subplot(2,3,1); P.title.String = '2nd, OD, PID'; rlocusplot(sys2o_pid,P); % ,k1
subplot(2,3,2); P.title.String = '2nd, OD, PID2'; rlocusplot(sys2o_pid2,P); % ,k1
subplot(2,3,3); P.title.String = '2nd, OD, PID3'; rlocusplot(sys2o_pid3,P); % ,k1

tmax = 0.3;  t = 0 : .001 : tmax;  % time vector for step response
for kpid = 1 : 3 : 16  % step response runs for a collection of RL "free parameter" gains
    [Wn1,zeta1,P1] = damp(kpid*sys3m_pid);  %sgrid(zeta,Wn)
    [Wn2,zeta2,P2] = damp(kpid*sys3m_pid2); %sgrid(zeta,Wn)
    subplot(2,3,4);  axis([0 tmax 0 1.1]);  grid on;
      y1 = step((kpid*sys2o_pid) /(1+(kpid*sys2o_pid)),t); plot(t,y1);  hold on;
      xlabel('Time'); ylabel('Step Response_{gain sweep}')
    subplot(2,3,5);  axis([0 tmax 0 1.1]);  grid on;
      y2 = step(t,(kpid*sys2o_pid2)/(1+(kpid*sys2o_pid2))); plot(t,y2); hold on;
      xlabel('Time'); ylabel('Step Response')
    subplot(2,3,6);  axis([0 tmax 0 1.1]);  grid on;
      y2 = step(t,(kpid*sys2o_pid2)/(1+(kpid*sys2o_pid2))); plot(t,y2); hold on;
      xlabel('Time'); ylabel('Step Response')

end




