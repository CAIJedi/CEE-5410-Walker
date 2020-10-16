%% Lecture Example - Solve a more complicated problem with Matlab using Simulated Annealing

% Maximize z(x1,x2) = ChevyChevFunction(x1,x2)
%  subject to -3 <= x1 <= 3
%             -3 <= x2 <= 3

% David E. Rosenberg
% October 2020
% Modified from Matlab documentation example for ChevyChevFunction
% https://www.mathworks.com/help/gads/particleswarm.html

%Objective function (ChevyChev Function)
%Minus sign to flip direction of optimization (turn minimize to maximize)
Zfun = @(x)-(3*(1-x(1)).^2.*exp(-(x(1).^2) - (x(2)+1).^2) ... 
   - 10*(x(1)/5 - x(1).^3 - x(2).^5).*exp(-x(1).^2-x(2).^2) ... 
   - 1/3*exp(-(x(1)+1).^2 - x(2).^2));

rng default  % Set random number generation to a common seed for reproducibility
nvars = 2; % Number of decision variables

% Set lower and upper bounds for each variable
lb =  [-3 -3];
ub = [3 3]; 

%Specify plot functions to display while solving. Also specify the maximum
%number of iterations
options = optimoptions('simulannealbnd','PlotFcns',...
          {@saplotbestx,@saplotbestf,@saplotx,@saplotf}, 'MaxIterations',750);

%Solve for the optimal value
[xOpt,zOpt,exitflag,output] = simulannealbnd(Zfun,[-2 -2], lb,ub, options)


%Plot the objective function and solution found
%Make a grid over the feasible domain
[xMesh,yMesh] = meshgrid([lb(1):0.1:ub(1)],[lb(2):0.1:ub(2)]);
zGrid = 0*xMesh;
%Calculate objective function value at each point on the grid
%Minus sign in from on Zfun to flip direction
for i=1:size(xMesh,1)
    for j=1:size(xMesh,2)
        zGrid(i,j) = -Zfun([xMesh(i,j) yMesh(i,j)]);
    end
end

%Create a new figure
figure
        
%surf(xMesh,yMesh,zGrid)
surf(xMesh,yMesh,zGrid)
hold on
set(gca,'fontsize',18,'xLim',[-3 3],'yLim',[-3 3]);
xlabel('X'); ylabel('Y'); zlabel('Objective Function Value');
%Minus sign on zOpt to again flip direction (maximize)
plot3(xOpt(1),xOpt(2),-zOpt,'color','b','marker','o','MarkerSize', 10,'MarkerFaceColor','r')


