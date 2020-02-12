function PlotSvdGivenA(M)

    [U,S,V] = svd(M,'econ'); %requires that a 2x2 matrix M is already declared
    
    figure
    hold on;
    
    theta = linspace(0,2*pi,360);
    plot(cos(theta),sin(theta));
    
    plot([0 V(1,1)],[0 V(2,1)])
    plot([0 V(1,2)],[0 V(2,2)])
    
    legend({'unit circle','v_1','v_2'})
    hold off;
    
    figure; hold on;
    longRadius = S(:,1) .* U(:,1);
    longRadius = longRadius';
    plot([0 longRadius(1)],[0 longRadius(2)])
    
    shortRadius = S(:,2) .* U(:,2);
    shortRadius = shortRadius';
    plot([0 shortRadius(1)],[0 shortRadius(2)])
    
    plot([0 U(1,1)],[0 U(2,1)])
    plot([0 U(1,2)],[0 U(2,2)])
    
    legend({'\sigma_1 u_1','\sigma_2 u_2','u_1','u_2'})
    
    hold off;

end
