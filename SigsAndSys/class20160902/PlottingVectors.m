% Vectors and Plotting
clear

t = 0:0.001:10;
sine_1 = sin(10.*pi.*t);
plot(t,sine_1);

sine_1 = sin(t);
sine_10 = sin(t.*10.*pi);
sine_100 = sin(t.*100.*pi);

plot(t,sine_1+sine_10+sine_100)

% hold on; plot(t,sin_1,'r')  // overlays plot
% hold off                    // releases plot