%% Example ChevyLocalOptimums
%
% This script plots the objective function of the Chevyychev Function 2
% (has multiple peaks)
% Function taken from https://www.chebfun.org/docs/guide/guide12.html
%
%The Problem:
% Maximize Z = 3*(1-x).^2.*exp(-(x.^2) - (y+1).^2) ... 
%   - 10*(x/5 - x.^3 - y.^5).*exp(-x.^2-y.^2) ... 
%   - 1/3*exp(-(x+1).^2 - y.^2)
% s.t.
% -3 <= x <= 3
% -3 <= y <= 3
%
% David E. Rosenberg
% October 4, 2020
% CEE 6410
%
% The task is students will solve the GAMS version of the problem using
% different starnting points to explore the "optimal" solution.



% Paste in student solutions from Google Sheet to draw a path from start to finish
% https://docs.google.com/spreadsheets/d/1HrinIg7Jr20wQv2IKfQsFs6CRJ9JaeoyVLd-YMBER2Q/edit#gid=0

xPaths = [ 
-2	-2	-3	-3	-9.60E-05	;
1	1	-0.009	1.581	8.106	;
];

%Calculate the objective function for the start point. Add as new column
xPaths = [xPaths  3*(1-xPaths(:,1)).^2.*exp(-(xPaths(:,1).^2) - (xPaths(:,2)+1).^2) ... 
   - 10*(xPaths(:,1)/5 - xPaths(:,1).^3 - xPaths(:,2).^5).*exp(-xPaths(:,1).^2-xPaths(:,2).^2) ... 
   - 1/3*exp(-(xPaths(:,1)+1).^2 - xPaths(:,2).^2)];




%Create a grid and calculate of the objective function on it
xPts = [-3:.1:3];
[xMesh,yMesh] = meshgrid(xPts,xPts);
z = 3*(1-xMesh).^2.*exp(-(xMesh.^2) - (yMesh+1).^2) ... 
   - 10*(xMesh/5 - xMesh.^3 - yMesh.^5).*exp(-xMesh.^2-yMesh.^2) ... 
   - 1/3*exp(-(xMesh+1).^2 - yMesh.^2);

%Create the plot and annotate it
[h,cons] = contour(xMesh,yMesh,z,[-10:1:10]); %,'showtext','on', 'labelspacing',1000);
clabel(h);
hold on

%Plot solutions
%plot(xGradPath(:,1),xGradPath(:,2),'LineWidth',3,'Color','Blue','marker','x','markersize',12);

set(gca,'fontsize',18,'xLim',[-3 3],'yLim',[-3 3]);
xlabel('X');
ylabel('Y');

set(gca,'xtick',[-3:1:3],'xticklabel',[-3:1:3])
set(gca,'ytick',[-3:1:3],'yticklabel',[-3:1:3])
set(cons,'labelspacing',1);

%Label the constraints
%annotation('textbox',[0.6 0.65 0.175 0.05],'String','Constraint 1','FitBoxToText','off');

grid on

hold off

%3-d surface plot without student solutions
figure
meshc(xMesh,yMesh,z)
hold on

set(gca,'fontsize',18,'xLim',[-3 3],'yLim',[-3 3]);
xlabel('X');
ylabel('Y');

set(gca,'xtick',[-3:1:3],'xticklabel',[-3:1:3])
set(gca,'ytick',[-3:1:3],'yticklabel',[-3:1:3])
set(cons,'labelspacing',1);

%3-d surface plot with student solutions
figure
meshc(xMesh,yMesh,z)
hold on

set(gca,'fontsize',18,'xLim',[-3 3],'yLim',[-3 3]);
xlabel('X');
ylabel('Y');

%Plot the student solutions
for i = 1:size(xPaths,1)
    xToPlot = [xPaths(i,1) xPaths(i,2) xPaths(i,6);
               xPaths(i,3) xPaths(i,4) xPaths(i,5)];
    plot3(xToPlot(:,1),xToPlot(:,2),xToPlot(:,3),'LineWidth',3,'Color','Black','marker','none','markersize',12);
end    

set(gca,'xtick',[-3:1:3],'xticklabel',[-3:1:3])
set(gca,'ytick',[-3:1:3],'yticklabel',[-3:1:3])
set(cons,'labelspacing',1);



