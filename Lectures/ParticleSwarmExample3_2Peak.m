%% Lecture Example #3 - Solve a more complicated problem with Matlab

% Minimize z(x) = x1 * exp(-norm(x)^2)
%  subject to -5 <= x1 <= 5
%                    -10 <= x2 <= 5

% David E. Rosenberg
% October 2016
% Taken from Matlab documentation example
% https://www.mathworks.com/help/gads/particleswarm.html

%Objective function
Zfun = @(x)x(1)*exp(-norm(x)^2);

rng default  % Set random number generation to a common seed for reproducibility
nvars = 2; % Number of decision variables

% Set lower and upper bounds for each variable
lb =  [-5 -10];%  [-10,-15];
ub = [5 5]; %[15,20];

%Set additional options like swarm size
options = optimoptions('particleswarm','SwarmSize',20); % polishing option ,'HybridFcn',@fmincon);

%Solve for the optimal value
[xOpt,zOpt] = particleswarm(Zfun,nvars,lb,ub,options)

%Plot the objective function and solution found
%Make a grid over the feasible domain
[xMesh,yMesh] = meshgrid([lb(1):0.25:ub(1)],[lb(2):0.25:ub(2)]);
zGrid = 0*xMesh;
%Calculate objective function value at each point on the grid
for i=1:size(xMesh,1)
    for j=1:size(xMesh,2)
        zGrid(i,j) = Zfun([xMesh(i,j) yMesh(i,j)]);
    end
end
        
%surf(xMesh,yMesh,zGrid)
surf(xMesh,yMesh,zGrid)
hold on
xlabel('X'); ylabel('Y'); zlabel('Objective Function Value');
plot3(xOpt(1),xOpt(2),zOpt,'color','r','marker','o')

%Plot just the surface
fig2 = figure;
surf(xMesh,yMesh,zGrid)
hold on
xlabel('X'); ylabel('Y'); zlabel('Objective Function Value');


