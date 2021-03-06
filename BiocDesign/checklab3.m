t = [0 0.5 2 5 7 9 11.5];
YOR100C=[-0.018621 0.869818 0.764636 0.596988 0.530299 0.293448 0.322478];
YDR374C=[-0.112239 0.767523 1.058926 1.177056 1.325282 1.166776 1.235062];
YPR192W=[-0.074966 -0.084184 0.604604 0.637530 0.337362 0.457506 0.260335];
YNL013C=[-0.030251 0.180811 0.328084 0.578693 0.797746 0.722888 0.828530];
YLR227C=[-0.085932 -0.132579 0.126957 0.668929 0.961072 0.869898 0.852649];
YDR403W=[0.035035 -0.050849 0.050204 0.046828 0.780994 1.299603 1.698991];
YKL050C=[-0.101773 0.200015 0.080895 0.219517 0.170059 0.843177 0.617446];

figure(1);
plot(t,YOR100C); hold on;
plot(t,YDR374C); hold on;
plot(t,YPR192W); hold on;
plot(t,YNL013C); hold on;
plot(t,YLR227C); hold on;
plot(t,YDR403W); hold on;
plot(t,YKL050C); hold on;
hold off;
title('Comparison of Log Ratios');
ylabel('Log Ratio');
xlabel('Time (hours)');
axis([0 12 -0.25 2.01]);
labels={'YOR100C (Metabolic)','YDR374C (Early I)','YPR192W (Early II)','YNL013C (Early-Mid)','YLR227C (Middle)','YDR403W (Mid-Late)','YKL050C (Late)'};
legend(labels, 'Location','northwest');