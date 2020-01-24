% ch7 plotting
figure(1); set(1,'Color',[1 1 1]);
tmax = 0.5                           % may want to change
t = 0 : 0.001 : 0.5;  %length(outp1);
subplot(2,1,1)                       % Input:         
  plot(t,outp1(:,1),'b','LineWidth',1.5); hold on;   
  winc = [zeros(length(t),1)];       % low line 
  plot(t,winc,'--'); hold on;
  ylabel('Control Action','FontWeight','bold') 
  axis([0 1 -25 25])
subplot(2,1,2)                       % Output:
  plot(t,outp1(:,2),'b','LineWidth',1.5); hold on;   
  %winl = [5.0*ones(1,length(t))];   % line, if desired 
  winh = [1.0*ones(1,length(t))];    % line
  plot(t,winl,'b--',t,winh,'g-');  hold on;
  ylabel('Output','FontWeight','bold')
  axis([0 tmax -2 8])                % change scales as needed
  axis([0 tmax 0 1.2])               % change scales as needed