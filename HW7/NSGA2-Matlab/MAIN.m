%% ::: GA OPTIMIZATION(nsga2):::
% Code shared by Andrea Cominola, Politecnico di Milano, Milan, Italy, Spring 2015.
% Most comments are in Italian.

% English comments added by David E. Rosenberg, October 9, 2018

clear all

%Load the inflow time series from a text file
load -ascii Inflow_Test_AR0_1.txt
Inflow_Test_AR0_1=Inflow_Test_AR0_1;

%Set up NSGA-II to run for multiple objectives
%nsga2:algoritmo che funziona per problemi a molti obiettivi.
global opt_setting
opt_setting.q=Inflow_Test_AR0_1(1:150,2); %Allow opt_setting.q (inflow) to be seen across the companion functions
opt_setting.s0=100; %Initial storage
%Set the population size to 100

%% NSGA-II Parameters to set or adjust
pop=100; %Dimensione della popolazione testati ad ogni iterazione (se è alto si ha più 
        %probabilità di trovare l'ottimo, ma si hanno maggiori costi
        %computazionali). In genere si prende una popolazione con un ordine
        %di grandezza maggiore rispetto al numero delle variabili di
        %decisione.
%Set the number of generations to 20
gen=20;%Numero di iterazioni

%% Problem Parameters
M=4;%Numero di funzioni obiettivo -- Number of objective functions
V=3;%Numero di variabili di decisione -- Number of decision variables

%Range of the decision variables (mininimum to maximum) [bounding box for
%the decision space
%Range delle variabili di decisioni
min_range=[0 50 0];
max_range=[pi/4 150 pi/2];

for i=1:10 %Repeat 10 times, with different lower bounds for first decision variable
    if i<5
        min_range=[0 50 0];
    else
        min_range=[pi/4 50 0];
    end
    
    disp(i);
    %Run the NSGA-II algorithm
    [ chromosome_0, chromosome, f_intermediate ] = nsga_2(pop,gen,M,V,min_range,max_range);
    %Initial chromosome =>  [x1,x2,x3,J_flo,J_irr]*pop
    chromosome_0; %Matrice con i valori delle V all'inizializzazione e gli obiettivi --> [x1,x2,x3,J_flo,J_irr]*pop; 
    %Final chromosome
    chromosome; %Matrice come la precedente, ma sul finale.
    
    %Pull out results from the chromosome
    u1(:,i)=chromosome(:,1);
    u2(:,i)=chromosome(:,2);
    u3(:,i)=chromosome(:,3);

    J1(:,i)=chromosome(:,4);
    J2(:,i)=chromosome(:,5);
    J3(:,i)=chromosome(:,6);
    J4(:,i)=chromosome(:,7);
end

%Reshape the matrices for easier display in data file
u1=reshape(u1,1000,1);
u2=reshape(u2,1000,1);
u3=reshape(u3,1000,1);

J1=reshape(J1,1000,1);
J2=reshape(J2,1000,1);
J3=reshape(J3,1000,1);
J4=reshape(J4,1000,1);
%% EXTREME POINT GENERATION TRY
for i=1:4 %Iterate over objective functions
    
    if i==1 % irrigation
    xA=[pi/4 150 pi/4];
    elseif i==2 % flood
            xA=[pi/4 50 pi/4];
    elseif i==3 % tourism
            xA=[0 150 0];
    elseif i==4 % hydropower
            xA=[pi/4 150 pi/4];
    else
            xA=[rand(1)*pi/4 rand(1)*150 rand(1)*pi/4];
                xA(2)=max(xA(2),50);
    end
   [ sA, uA, rA, vA, VA, g_flo_A, g_irr_A, g_hyd_A, g_rec_A ] = sim_Test( opt_setting.q, opt_setting.s0, xA ) ;
    
    u1(end+1)=xA(1);
    u2(end+1)=xA(2);
    u3(end+1)=xA(3);
    
    J1(end+1)=mean(g_flo_A(2:end));
    J2(end+1)=mean(g_irr_A(2:end));
    J3(end+1)=mean(g_hyd_A(2:end));
    J4(end+1)=mean(g_rec_A(2:end));

end

disp('done');

%Calculate the dominance rank of all alternatives
NumResults = [J1 J2 J3 J4 u1 u2 u3]; % Four objective functions and then 3 decision variables
NumResultsDom = non_domination_sort_mod(NumResults ,M,V);

%Dump the results to csv file
Headers = {'FloodIntensity' 'UnmetIrrDemand' 'UnmetHydroDemand' 'UnmetRecreationDemand'	'x1' 'x2'	'x3' 'Dominance' };
writetable(cell2table([Headers; num2cell(NumResultsDom(:,1:end-1))]),'HW7_altsNew.csv','writevariablenames',0);

%% First tries at PLOTTING RESULTS

scatter3(J1, J2, J3, [],J4, 'filled');
scatter3(J1, J2, J4, [],J3, 'filled');
hold on
%Overplot dominence one points in black
Dom1 = NumResultsDom(:,8) == 1;
scatter3(J1(Dom1==1), J2(Dom1==1), J4(Dom1==1), [],J3(Dom1==1), 'MarkerFaceColor', [0 0 0]);

%hold on;scatter3(J1(end), J2(end), J4(end));
xlabel('flo');
ylabel('irr');
zlabel('hyd');



