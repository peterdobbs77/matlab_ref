%% DiffusionPDE_3D.m
%    Peter Dobbs
%    BIEN 4931
%    Final Coding Project
%
%    Images a system which is decreasing in temperature from 350 K.
%    
%
%%

close all
clear

%Template using the new MATLAB PDE Toolbox workflow
model = createpde();
importGeometry(model,'part.STL');
figure;pdegplot(model,'FaceAlpha',0.9);title('Geometry');view(150,15);

% Apply boundary conditions: Generalized Neumann or Robin Boundary
% conditions at external boundaries
gfun = @(region,state)-state.u.^3*1e-6;
applyBoundaryCondition(model,'neumann','Face',1:model.Geometry.NumFaces,'g',gfun);

% Specify source location and PDE coefficients
specifyCoefficients(model,'m',0,'d',1,'c',1,'a',3,'f',0);
% setting f=0 makes the solution very simple

%Initial, constant temperature of 350
setInitialConditions(model,350);

% generate mesh
generateMesh(model);
tlist = 0:20;
%solve
result = solvepde(model,tlist);

figure;pdeplot3D(model,'ColorMapData',result.NodalSolution(:,19))
title('Temperature Reading at Time = 19');
view(150,15);

%%visualize location of likely probe damage
    %not finished, because unsure how to proceed
    
%%End of DiffusionPDE_3D.m