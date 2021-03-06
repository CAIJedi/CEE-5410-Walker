$ontext
CEE 6410 - Water Resources Systems Analysis
Homework 4 Problem 1

THE PROBLEM:
A reservoir is designed to provide hydropower and water for irrigation.
At least one unit of water must be kept in the river  each  month  at  point  A.
The  hydropower  turbines  have  a  capacity  of  4  units  of  water  per month (flows are constant during any single month),
and any other releases must bypass the turbines.
The size of farmed area is very large relative to the amount of irrigation water available,
 so there is no upper limit on usable irrigation water.
 The reservoir has a capacity of 9 units, and initial storage  is  5  units  of  water.
The  ending  storage  must  be  equal  to  or  greater  than  the  beginning storage.
 The benefits per unit of water, and the estimated average inflows to the reservoir are given in Table 1.
$offtext
*Difine the variables
SETS flow flows into location /TURB "Turbine",IRR "Irrigation",RES "Reservoir",Spill "Spillway",Aout "Aout"/
     t time (months) /m1,m2,m3,m4,m5,m6/;
*defining imput data
PARAMETERS
    hb(t) hydropower benifit coeffencent ($ per unit)
    /m1 1.6,m2 1.7,m3 1.8,m4 1.9,m5 2.0,m6 2.0/
    ib(t) Irrigation benifit coeffecent ($ per unit)
    /m1 1,m2 1.2,m3 1.9,m4 2.0,m5 2.2,m6 2.2/
    inflow(t) inflow units per month
     /m1 2,m2 2,m3 3,m4 4,m5 3,m6 2/;
SCALARS
    MaxStor Max Storage of reserviour /9/
    InitalStor Inital storage of reservioir /5/
    Maxturbine Maximum flow through turbine /4/
    MinflowA minimum flow required at A /1/;
VARIABLES
    X(flow,t) types of flows in and out of components
    VPROFIT total profit;
*make sure all variables stay positive
Positive Variables X;
*set up constraints and profit formulation
Equations
    Profit total profit and objective function value
    Outflow_Constraint(t) minimum flow required to flow out of the system
    Cap_Constraint(t) constraint based on capacity of the reservoir
    Sustain_constraint(t) requiremtny to have sustaiable use of Reservoir
    Turbine_constraint(t) maximum flow through turbine
    Massbalance_Constraint(t) flow in equals flow out
    Inflow1_constraint constrains the inflow and spillway flow of the Reservoir initally
    Inflowallohters_constraint(t) constrains the inflow and spillway flow of the Reservoir in all but the inital case;
Profit..  VPROFIT =E= SUM(t,hb(t)*X('TURB',t)+ib(t)*X('IRR',t));
Cap_Constraint(t).. X('RES',t) =L= MaxStor;
Outflow_Constraint(t).. X('Aout',t)=G= MinflowA;
Sustain_constraint(t).. X('RES','m6') =G= InitalStor;
Turbine_constraint(t).. X('TURB',t)=L= MaxTurbine;
Massbalance_constraint(t).. X('TURB',t)+X('Spill',t) =E= X('IRR',t)+X('Aout',t);
Inflow1_constraint.. X('RES','m1') =E= InitalStor+inflow('m1')-X('TURB','m1')-X('Spill','m1');
Inflowallohters_constraint(t)$(ord(t) gt 1)..  X('RES',t) =E= inflow(t)+X('RES',t-1)-X('Spill',t)-X('TURB',t);
*Deinfing model based on equations
MODEL RESMODEL /Profit,Cap_Constraint,Outflow_Constraint,Sustain_constraint, Turbine_Constraint,Massbalance_Constraint,Inflow1_constraint,Inflowallohters_constraint/;
*Solve Model
Solve RESMODEL Using LP Maximizing VPROFIT;
