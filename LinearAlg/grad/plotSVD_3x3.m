%TODO: should eventually create a check for if the input matrix is 2x2
function plotSVD_3x3(A) %Like A=[3,0;0,-2];
    %% plot starting V on unit circle
    % make unit circle
    theta = 0:0.01:2*pi;
    [x,y,z] = sphere;

    figure;
    ax1 = subplot(2,1,1); hold on;
    lightGrey = 0.8*[1 1 1]; % It looks better if the lines are lighter
    surface(x,y,z,'FaceColor', 'none','EdgeColor',lightGrey)
    % plot components
    [U,S,V] = svd(A); 
    plot3([0 V(1,1)],[0 V(2,1)],[0 V(3,1)])
    plot3([0 V(1,2)],[0 V(2,2)],[0 V(3,2)])
    plot3([0 V(1,3)],[0 V(2,3)],[0 V(3,3)])
    hold off;
    legend({'unit circle','v_1','v_2','v_3'})

    %% plot resulting ellipse
    subplot(2,1,2); hold on;
    % components
    AV=U*S;
    plot3([0 AV(1,1)],[0 AV(2,1)],[0 AV(3,1)])
    plot3([0 AV(1,2)],[0 AV(2,2)],[0 AV(3,2)])
    plot3([0 AV(1,3)],[0 AV(2,3)],[0 AV(3,3)])
    ellipsoid(0,0,0,(sum(AV(:,1).^2))^(1/2),(sum(AV(:,1).^2))^(1/2),(sum(AV(:,1).^2))^(1/2))
    legend({'ellipse','\sigma_1 u_1','\sigma_2 u_2','\sigma_3 u_3'})
    hold off;