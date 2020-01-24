% Generate synthetic fluorescence data for 50 sources and 50 detectors
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

%create and visualize geometry
rect1 = [3;4;0;10;10;0;0;0;5;5];
geom1 = decsg(rect1);

%Assign geometries to models
geometryFromEdges(model1,geom1);
%Visualize geometries and note the edge and face labels
figure;pdegplot(model1,'Edgelabels','on','Subdomainlabels','on');axis image;box off;title('Geometry: no inclusion')

% Define 50 sources along y = 4.9
xs = linspace(0,10,50);
ys = linspace(4.9,4.9,50);

% Define 50 detectors along y=0
xd = linspace(0,10,50);
yd = linspace(0,0,50);

% Measurement Data
measData = zeros(length(xd),length(xs));

for i=1:length(xs)
    % Define source 
    f = @(region,state)  complex(   [exp(- ( (region.x-xs(i)).^2/(2*0.01) + (region.y-ys(i)).^2/(2*0.01)) );zeros(1,length(region.x))]  );
    
    % Apply boundary conditions
    applyBoundaryCondition(model1,'neumann','edge',[1,2,3,4],'q',1/(2*gamma)*[1,0,0,1],'g',0);
    
    %Create and apply PDE coefficients
    c = 1/(3* (mu_a +mu_sp));
    
    
    % Specify coefficients
    specifyCoefficients(model1,'m',0,'d',0,'c',c,'a',@AbsFunc_3,'f',f); %uses state mesh (AbsFunc_3)
    
    % generate mesh
    generateMesh(model1,'Hmax',0.1);
    
    %solve
    result1 = solvepde(model1);
    
    
    %plot solution
    figure;pdeplot(model1,'XYData',(log(abs(result1.NodalSolution(:,2)))),'Mesh','off');axis image;title(['Fluorescence Emission for source  ',num2str(i)])

    % Detector Solution
    measData(:,i) = interpolateSolution(result1,[xd;yd],2);
end
save measData_50sd measData
