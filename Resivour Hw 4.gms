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
SETS flow flows into /Turbine,Irrigation,Reservoir,Spillway,Aout/
     t time (months) /one,two,three,four,five,six/;
*defining imput data
PARAMETERS
    hb(t) hydropower benifit coeffencent ($ per unit)
    /one 1.6,
    two 1.8,
    three 1.8,
    four 1.9,
    five 2.0,
    six 2.0/
    ib(t) Irrigation benifit coeffecent ($ per unit)
    /one 1.6,
    two 1.8,
    three 1.8,
    four 1.9,
    five 2.0,
    six 2.0/
    inflow(t) inflow units per month
     /one 2,
     two 2,
     three 3,
     four 4,
     five 3,
     six 2/
    inital_storage(t) the inital storage of the reservoir
    / one 5/
TABLE A (flow,t) constraint cooefficents;
VARIABLES
    X(flow,t) types of flows in and out of components
    VPROFIT total profit;
Positive Variables X;
Equations
    Profit total profit and objective function value
    Outflow_Constraint(flow,t) minnimum flow required to flow out of the system
    Cap_Constraint(flow,t) constraint based on capacity of the reservoir
    Sustain_constraint(flow,t) requiremtny to have sustaiable use of Reservoir
    Turbine_constraint(flow,t) maximum flow through turbine
    Massbalance_Constraint(flow,t) flow in equals flow out
    Inflow1_constraint(flow,t) constrains the inflow and spillway flow of the Reservoir initally
    Inflowallohters_constraint(flow,t) constrains the inflow and spillway flow of the Reservoir in all but the inital case;
Profit...  VPROFIT =E= SUM(t,hb(t)*X("Turbine",t)+ib(t)*X("Irrigation",t));
Cap_Constraint(flow,t)... X("Reservoir",t)=L= 9;
Outflow_Constraint(flow,t)... X("Aout",t)=G=1;
Sustain_constraint(flow,t)... X("Reservoir",six) =G= 5;
Turbine_constraint(flow,t)... X("Turbine",t)=L= 4;
Massbalance_constraint(flow,t)... Sum(X("Turbine",t),X("Spillway",t))=E=Sum(X("Irrigation",t),X("Aout",t));
Inflow1_constraint(flow,t)... Sum(X("Reservoir",one)) =E= Sum(initial_storage(t),inflow(one),X("Turbine",one),-X("Spillway",one);
Inflowallohters_constraint(flow,t)...  X("Reservoir",t) =E= Sum(inflow(t+1),X("Reservoir",t),-X("Spillway",t+1),-X("Turbine",t+1));
*Deinfing model based on equations
MODEL RES /Profit,Cap_Constraint,Outflow_Constraint,Sustain_constraint, Turbine_Constraint,Massbalance_Constraint,Inflow1_constraint,Inflowallohters_constraint/;
*Solve Model
Solve Res Using LP Maximizing VPROFIT;
