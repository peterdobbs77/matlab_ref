% Example program for solving diffusion equation with constant optical
% properties and a single absorbing inclusion with MATLAB PDE syntax for elliptic PDEs and generalized
% Neuman boundaries
  
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

close all
clear all
mu_a = 0.02; %cm^-1
mu_sp = 10; %cm^-1
gamma = 1.89;   % Bounday factor based on refractive index mismatch
omega = 2*pi*1e8;  % in radians/s, for 100 MHz frequency
cl = 3e10/1.34; %speed of light in tissue 


%Template using the new MATLAB PDE Toolbox workflow
model1 = createpde();
model2 = createpde();

%create and visualize geometry
rect1 = [3;4;0;10;10;0;0;0;5;5];
geom1 = decsg(rect1);




% create another geometry with an absorbing inclusion
rect2 = [3;4;3;4;4;3;3;3;4;4];
geom2 = decsg([rect1,rect2]);


%Assign geometries to models
geometryFromEdges(model1,geom1);
geometryFromEdges(model2,geom2);

%Visualize geometries and note the edge and face labels
figure;pdegplot(model1,'Edgelabels','on','Subdomainlabels','on');axis image;box off;title('Geometry: no inclusion')
figure;pdegplot(model2,'Edgelabels','on','Subdomainlabels','on');axis image;box off;title('Geometry: with inclusion')

% Apply boundary conditions: Generalized Neumann or Robin Boundary
% conditions at external boundaries
applyBoundaryCondition(model1,'neumann','edge',[1,2,3,4],'q',1/(2*gamma),'g',0);
applyBoundaryCondition(model2,'neumann','edge',[1,2,6,7],'q',1/(2*gamma),'g',0);

%Create and apply PDE coefficients
c = 1/(3* (mu_a +mu_sp));  % Diffusion coefficient
a = complex(mu_a,omega/cl); % Constant background Absorption coefficient term in Frequency Domain

% Example non-constant Source term and absorption term syntax
f = @(region,state) complex(exp(- ( (region.x-5).^2/(2*0.01) + (region.y-4.8).^2/(2*0.01)   ) ),0); 
a2 = @(region,state) (region.subdomain ==2) * complex (100*mu_a,omega/cl) + (region.subdomain ==1) * complex (mu_a,omega/cl); 

% Specify source location and PDE coefficients
specifyCoefficients(model1,'m',0,'d',0,'c',c,'a',a,'f',@SrcFunc_1);
specifyCoefficients(model2,'m',0,'d',0,'c',c,'a',a2,'f',@SrcFunc_1);


% generate mesh with 1mm resolution
generateMesh(model1,'Hmax',0.1);
generateMesh(model2,'Hmax',0.1);
%solve
result1 = solvepde(model1);
result2 = solvepde(model2);


% visualize along detection path place along y = 0 edge
xq = linspace(0,10,50);
yq = linspace(0,0,50);

u1interp = interpolateSolution(result1,xq,yq);
u2interp = interpolateSolution(result2,xq,yq);

% Plot simulation results
figure;plot(xq,abs(u1interp));hold on; plot(xq,abs(u2interp));
legend('no-inclusion','with-inclusion')
xlabel('Detector location')
ylabel('Amplitude of Light Fluence')


figure;plot(xq,angle(u1interp));hold on; plot(xq,angle(u2interp));
legend('no-inclusion','with-inclusion')
xlabel('Detector location')
ylabel('Phase of Light Fluence')


figure;pdeplot(model2,'XYData',(log(abs(result2.NodalSolution))),'Mesh','off');axis image;title('Amplitude of light Fluence: with-inclusion')

figure;pdeplot(model1,'XYData',(log(abs(result1.NodalSolution))),'Mesh','off');axis image;title('Phase of light Fluence: with-inclusion')


