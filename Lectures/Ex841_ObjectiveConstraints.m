%% Example 8-4-1. Objective Function and Constraints
%
%The Problem:
% Maximize Z = X1 (5-(X1)^2) + X2 * (14 – 6 X2)
% s.t.
% X1 + 4 X2 ? 18
% 6 X1 + 2 X2 ? 26
% (X2)^2 ? 5
%
% David E. Rosenberg
% October 1, 2020
% CEE 6410

%Gradient solution path (from Ex8-4-1.xlsx => Gradient-6
xGradPath = [0	0;
            0.463	1.296;
            1.212	1.029;
            1.264	1.173;
            1.289	1.164
            1.290	1.167];


%Create a grid and calculate of the objective function on it
xPts = [0:.1:6];
[xMesh,yMesh] = meshgrid(xPts,xPts);
z = xMesh.*(5 - xMesh.^2) + yMesh.*(14-6*yMesh); % 1000 - ((xMesh-1).^2 + (yMesh-1).^2);

%Calculate the constraints
%Constraint 1: X1 + 4 X2 ? 18
cx1 = 18 - 4*xPts;
%Constraint 2: 6 X1 + 2 X2 ? 26
cx2 = (26 - 2*xPts)/6;
%Constraint 3: (X2)^2 ? 5
cx3 = sqrt(5) + 0*xPts;

%Create the plot and annotate it
[h,cons] = contour(xMesh,yMesh,z,[-40:2:10]); %,'showtext','on', 'labelspacing',1000);
clabel(h);
hold on

%Plot constraints in black
plot(cx1,xPts,'LineWidth',2,'Color','Black');
plot(cx2,xPts,'LineWidth',2,'Color','Black');
plot(xPts,cx3,'LineWidth',2,'Color','Black');
%Plot optimal path in dashed blue
plot(xGradPath(:,1),xGradPath(:,2),'LineWidth',3,'Color','Blue','marker','x','markersize',12);

set(gca,'fontsize',18,'xLim',[0 6],'yLim',[0 6]);
xlabel('X_1');
ylabel('X_2');

set(gca,'xtick',[0:1:6],'xticklabel',[0:1:6])
set(gca,'ytick',[0:1:6],'yticklabel',[0:1:6])
set(cons,'labelspacing',1);

%Label the constraints
annotation('textbox',[0.6 0.65 0.175 0.05],'String','Constraint 1','FitBoxToText','off');
annotation('textbox',[0.475 0.8 0.175 0.05],'String','Constraint 2','FitBoxToText','off');
annotation('textbox',[0.675 0.48 0.175 0.05],'String','Constraint 3','FitBoxToText','off');



grid on


