clear;
close all;

pressure_mmHg = 20:20:440;
reading_uV = [ 0 20 40 60 80 100 120 135 150 165 180 190 200 210 220 225 230 235 237 239 240 240];

%% A: plot the data
pressure2 = pressure_mmHg(1,1:10);
reading2 = reading_uV(1,1:10);
coeff = polyfit(pressure2,reading2,1);
fittedX = linspace(min(pressure_mmHg), max(pressure_mmHg),22);
fittedY = polyval(coeff, fittedX);

figure(1);
plot(pressure_mmHg, reading_uV, '', fittedX, fittedY, '')
title("Pressure Transducer Calibration Test");
xlabel("Pressure (mmHg)");
ylabel("Reading (uV)");

%% B: determine the offset (y-intercept)
fittedX2 = linspace(0, max(pressure_mmHg));
fittedY2 = polyval(coeff, fittedX2);
offset = fittedY2(1);

figure(2)
plot(fittedX2, fittedY2);
axis([0 300 -50 250]);
title("Calibration Linear Fit");
xlabel("Pressure (mmHg)");
ylabel("Reading (uV)");

%% C: determine the sensitivity (with linearity, it's the slope)
p = polyfit(pressure2,reading2,1);
slope = p(1);

%% D: average error in range 200-300mmHg
for i=10:15
    difference(i-9) = (fittedY(i)-reading_uV(i));
end
avgDiff = mean(difference);