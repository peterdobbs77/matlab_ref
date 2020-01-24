%TODO: should eventually create a check for if the input matrix is 2x2
function plotSVD_2x2(A) %Like A=[3,0;0,-2];
    %% plot starting V on unit circle
    % make unit circle
    theta = 0:0.01:2*pi;
    x = cos(theta);
    y = sin(theta);

    figure;
    ax1 = subplot(2,1,1); hold on;
    plot(x,y); % plot unit circle
    % plot components
    [U,S,V] = svd(A,'econ'); 
    plot([0 V(1,1)],[0 V(2,1)])
    plot([0 V(1,2)],[0 V(2,2)])
    hold off;
    legend({'unit circle','v_1','v_2'})

    %% plot resulting ellipse
    % calculate the radii
    sphere = [x;y];
    AS = A*sphere;
    ax2 = subplot(2,1,2); hold on;
    plot(AS(1,:),AS(2,:)) % plot ellipse
    % components
    AV=U*S;
    plot([0 AV(1,2)],[0 AV(2,2)]) %first primary semiaxis
    plot([0 AV(1,1)],[0 AV(2,1)]) %second primary semiaxis
    legend({'ellipse','\sigma_1 u_1','\sigma_2 u_2'})
    hold off;

    linkaxes([ax1, ax2],'x');