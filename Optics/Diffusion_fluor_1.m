% Example program for solving coupled diffusion equation with constant optical
% properties and a single fluorescent inclusion with MATLAB PDE syntax for elliptic PDEs and generalized
% Neuman boundaries
  
%Excitation and Emission Diffusion equations:


 
%%
% $-\nabla \cdot {D_x\nabla}u + k_x u = S_x$
%%
% $-\nabla \cdot {D_m\nabla}v + k_m u = B_{xm}u$ 
%%
% $2\gamma n\cdot{D_x\nabla}u + u = 0$
%%
% $2\gamma n\cdot{D_m\nabla}v + v = 0$
 %Equivalent PDE toolbox notation (NOTE the vector notation for system of PDEs):
 
 %%
 % $-\nabla \cdot (\mathbf{c} \nabla \mathbf{u}) +\mathbf{a}\mathbf{u} = \mathbf{f}$
   
 
 %%
 % $n \cdot (\mathbf{c} \nabla \mathbf{u}) +\mathbf{q}\mathbf{u} = \mathbf{g}$

close all
clear all
mu_a = 0.02; %cm^-1
mu_sp = 10; %cm^-1
gamma = 1.89;   % Bounday factor based on refractive index mismatch
omega = 2*pi*1e8;  % in radians/s, for 100 MHz frequency
cl = 3e10/1.34; %speed of light in tissue 


% Fluorescence properties (Indocyanine green equivalent)
mu_axf = 0.2;
phi = 0.02;
tau = 0.56e-9;



%Template using the new MATLAB PDE Toolbox workflow
model1 = createpde(2);
model2 = createpde(2);

%create and visualize geometry
rect1 = [3;4;0;10;10;0;0;0;5;5];
geom1 = decsg(rect1);




% create another geometry with a fluorescent inclusion
rect2 = [3;4;3;4;4;3;3;3;4;4];
geom2 = decsg([rect1,rect2]);


%Assign geometries to models
geometryFromEdges(model1,geom1);
geometryFromEdges(model2,geom2);
%Visualize geometries and note the edge and face labels
figure;pdegplot(model1,'Edgelabels','on','Subdomainlabels','on');axis image;box off;title('Geometry: no inclusion')
figure;pdegplot(model2,'Edgelabels','on','Subdomainlabels','on');axis image;box off;title('Geometry: with inclusion')

% Apply boundary conditions
applyBoundaryCondition(model1,'neumann','edge',[1,2,3,4],'q',1/(2*gamma)*[1,0,0,1],'g',0);
applyBoundaryCondition(model2,'neumann','edge',[1,2,6,7],'q',1/(2*gamma)*[1,0,0,1],'g',0);

%Create and apply PDE coefficients
c = 1/(3* (mu_a +mu_sp));


% Specify coefficients
specifyCoefficients(model1,'m',0,'d',0,'c',c,'a',@AbsFunc_2,'f',@SrcFunc_2);
specifyCoefficients(model2,'m',0,'d',0,'c',c,'a',@AbsFunc_2,'f',@SrcFunc_2);


% generate mesh
generateMesh(model1,'Hmax',0.1);
generateMesh(model2,'Hmax',0.1);
%solve
result1 = solvepde(model1);
result2 = solvepde(model2);


% visualize solution
figure;pdeplot(model2,'XYData',abs(result2.NodalSolution(:,1)));axis image;title('Excitation amplitude: geometry with fluorescent inclusion')

figure;pdeplot(model2,'XYData',abs(result2.NodalSolution(:,2)));axis image;title('Fluorescence amplitude: geometry with fluorescent inclusion')

% visualize along detection path place along y = 0 edge
xq = linspace(0,10,50);
yq = linspace(0,0,50);

u1interp_1 = interpolateSolution(result1,[xq;yq],1);
u1interp_2 = interpolateSolution(result1,[xq;yq],2);

u2interp_1 = interpolateSolution(result2,[xq;yq],1);
u2interp_2 = interpolateSolution(result2,[xq;yq],2);


figure;plot(xq,abs(u1interp_2));hold on; plot(xq,abs(u2interp_2));
legend('no-inclusion','with-inclusion')
xlabel('Detector location')
ylabel('Amplitude of Light Fluence')

figure;plot(xq,angle(u1interp_2));hold on; plot(xq,angle(u2interp_2));
legend('no-inclusion','with-inclusion')
xlabel('Detector location')
ylabel('Phase of Light Fluence')