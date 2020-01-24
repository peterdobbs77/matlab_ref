% Example program for laser photothermal heating with a CW laser source,
% and a tumor like inclusion with enhanced absorption.
% 
  
%Excitation Diffusion equation:


 
%%
% $-\nabla \cdot {D_x\nabla}u + k_x u = S_x$
 
%%
% $2\gamma n\cdot{D_x\nabla}u + u = 0$

 %Equivalent PDE toolbox notation:
 
 %%
 % $-\nabla \cdot (c \nabla u) +au = f$
   
 
 %%
 % $n \cdot (c \nabla u) +qu = g$
 
 % Penne equation
 %%
 % $\rho c_p \frac{\partial{T}}{\partial{t}} - \nabla \cdot (k \nabla T) + h c_{blood} (T - T_a) = Q_{laser}$
 %% 
 %Equivalent PDE toolbox notation
 %%
 % $d \frac{\partial u}{\partial t}-\nabla \cdot (c \nabla u) +au = f$

close all
clearvars

mu_a = 0.02; %cm^-1
mu_sp = 10; %cm^-1
gamma = 1.89;   % Bounday factor based on refractive index mismatch

%Template using the new MATLAB PDE Toolbox workflow
model1 = createpde(2);


%create and visualize geometry
rect1 = [3;4;0;10;10;0;0;0;5;5];

geom1 = decsg(rect1);


%Assign geometries to models
geometryFromEdges(model1,geom1);

%Visualize geometries and note the edge and face labels
figure;pdegplot(model1,'Edgelabels','on','Subdomainlabels','on');axis image;box off;title('Geometry: with inclusion')

% Apply boundary conditions

applyBoundaryCondition(model1,'neumann','edge',[1,2,3,4],'q',1/(2*gamma)*[1,0,0,0],'g',[0;0]); % only for the fluence component for diffusion equation,

% Apply dirichlet condition on temperature for Penne equation
applyBoundaryCondition(model1,'dirichlet','edge',[1,2,4],'u',[0;37]);

applyBoundaryCondition(model1,'dirichlet','edge',3,'u',[0;37]);

%Initial condition
setInitialConditions(model1,[0;37]); % temperature is 37 degree when laser turned on.


% Now specify the system of coupled diffusion and Penne equations

% Specify source location and PDE coefficients

specifyCoefficients(model1,'m',0,'d',@dFun,'c',@cFun,'a',@aFun,'f',@fFun);

generateMesh(model1,'Hmax',0.1);
result1 = solvepde(model1,0:1:20);


