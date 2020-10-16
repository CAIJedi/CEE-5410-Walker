$ontext
CEE 6410 Fall 2018
Problem 19.5 in Bishop et al and Example 1 in the Lecture notes MOP - Classical Methods.

A reservoir with capacity of 60 units of water and season 1 and 2 streamflow
of 100 and 20 units, respectively, during a critical design period.
The reservoir is intended to maximize both irrigation yield (X),
and hydropower yield (Y) (refer to Figure 19.3).  Irrigation yield has seasonal
distribution (at) of (0.3, 0.7).  Hydropower releases have seasonal a
distribution of Bt = (0.6, 0.4).

Assume initial storage of 30 units and turbine capacity of 45 units.
The irrigation district diverts all river water downstream of the reservoir
(NOT from the HYDROPOWER facility)

Develop an LP model of this problem and
generate the Pareto optimal set of solutions by using the constraint method.
Is the limiting resource water or reservoir capacity?
What is the relative weighting of the two objectives if an irrigation  yield of 50 is selected?

THE PROBLEM
Objective 1 (Irrigation Yield) is Max X = 0.3*I(1) + 0.7*I(2)
Objective 2 (Hydropower Yield) is Max Y = 0.6*H(1) + 0.4*H(2)

Subject to
         S(t+1) = S(t) + inflow(t) - H(t) - Sp(t)  (reservoir mass balance);
         S(t) <= 60    (reservoir capacity)
         I(t) = SPI(t)   (irrigation deliveries from river)
         H(t) <= 45    (turbine capacity)


David E. Rosenberg
October 7, 2018
david.rosenberg@usu.edu
$offtext

*1. Define the sets
SETS t season /s1*s2/
     l network locations
         /res "Reservoir", hyd "Hydropower", irr "Irrigation", spi "Spill"/
*    Define a new set f (objective functions) that is a subset of the set l
*    See GAMS Users Guide Section 4.4
     f(l) locations of benefits /hyd,irr/;

*Define a second name for the set f -- f2. See GAMS Users Guide Section 4.3.
Alias (f,f2);


*2. Define the input data
PARAMETERS
   inflow(t) reservoir inflow (volume)
        /s1 100, s2 20/
   FtoUse(f) Objective functions to use (1=yes 0=no)
   FLevel(f)  Right hand side of constraint when the objective is constrained (arb. units)
* Note we did not set values for FtoUse or FLevel. GAMS assumes zeros. We will set later with an assignment statement
   FStore(f2,f) Storing objective function values over different scenarios of f
   XStore(f2,l,t) Store decision variable values over different scenarios of f;

TABLE bens(f,t) benefit at location f at time t ($ per volume)
          s1     s2
     hyd  0.6    0.4
     irr  0.3    0.7
          ;

SCALARS
   MaxStor Maximum reservoir storage (volume) /60/
   InitStor Initital reservoir storage (volume) /30/
   TurbCap  Turbine capacity (volume) /45/;


*3. Define the decision variables
VARIABLES
   X(l,t)  Flow or storage in network at location l at time t (volume)
   FBen(f)   Total benefits at location f ($)
   TotalBen    Total benefits across all locations ($)

Positive Variables X;

*4. Define the equations
EQUATIONS
   FBenefit Benefits at location f ($) [Objective function]
   TotBenefits Total benefits across all locations ($) [Single objective function]
   ResBalance(t) Reservoir mass balance in time t (volume)
   ResCapacity(t) Upper limit on reservoir storage (volume)
   EndStorage Ending reservoir storage (volume)
   HydropowerCap(t) Hydropower capacity for each month (volume)
   IrrFlow(t)  Irrigation flow from river (volume);


*Equations for LP formulation
FBenefit(f)..        FBen(f) =E= SUM(t, bens(f,t)*X(f,t));
TotBenefits..         TotalBen =E= SUM(f,FtoUse(f)*FBen(f));
ResBalance(t)..     X("res",t) =E= inflow(t) - X("hyd",t) - X("spi",t) +
*                              Only use initial storage in time step 1
                               InitStor$(ord(t) eq 1) +
*                              Use prior storage in other time steps
                               X("res",t-1)$(ord(t) gt 1);
ResCapacity(t) ..   X("res",t) =L= MaxStor;
*card(t) = last time step.
EndStorage..        sum(t$(ord(t) eq card(t)),X("res",t)) =G= InitStor;
HydropowerCap(t)..  X("hyd",t) =L=  TurbCap;
IrrFlow(t)..   X("irr",t) =E= X("spi",t);

*5. Define the models
*Linear Program - combined objective functions
*This model will also allow us to find the extreme points by adjusting FToUse(f)
MODEL ExtremePt Find an extreme point of the LP
         /FBenefit,TotBenefits,ResBalance,ResCapacity,EndStorage,HydropowerCap,IrrFlow/;

*Model that constrains one objective to be greater than a level
EQUATION
ObjAsCon(f)    Objective function as constraint f(x) >= FLevel;

ObjAsCon(f)$(1 - FtoUse(f))..   FBen(f) =G= FLevel(f);


MODEL ObjAsConstraint Single-objective model with other objectives constrained /ALL/;


*6. Solve the models.

*First, solve the single objective formulation (MAX Irrigation + Hydropower benefits; as in prior models)
*   SUM(t, IRR(1)+IRR(2) + HYD(1) + HYD(2)
FtoUse(f) = 1;

*Solve as a single-objective deterministic linear programming formulation
SOLVE ExtremePt USING LP Maximizing TotalBen;


* Solve for the extrement points in sequence
* Step A. First find the extreme points associated with objective #1. Ignore all other objectives
*   i.e., Max fi(X) s.t. aX <= b;
* Then move to objective #2

Loop(f2,
*  Ignore all the objectives
   FtoUse(f) = 0;
*  Only consider the current objective
   FtoUse(f2) = 1;

   Display FtoUse;

*  Solve the model
   SOLVE ExtremePt USING LP MAXIMIZING TotalBen;

   DISPLAY TotalBen.L, FBen.L, X.L;
*Also save the results for later use
   FStore(f2,f) = FBen.L(f);
   XStore(f2,l,t) = X.L(l,t);

   );

DISPLAY FStore,XStore;

$ontext
* Step B. Constrain one objective function value and maximize the other objective

*Maximum the hydropower objective, constraint the irrigation objective
FToUse(f) = 0;
FtoUse("hyd") = 1;
*Constrain the irrigation objective
*Choose a value between the extreme points for the irrigation objective identified above
*FLevel("irr") = ________________ ;

*Alternatively
*Maximize the irrigation objective, constrain the hydropower objective
*FtoUse(f) = 0;
*FtoUse("irr") = 1;
*Set a level for the Hydropower objective
*FLevel("hyd") = 15;

SOLVE ObjAsConstraint USING LP MAXIMIZING TotalBen;

DISPLAY TotalBen.L, FBen.L, X.L;

* Dump all input data and results to a GAMS gdx file
Execute_Unload "Ex19-5.gdx";
* Dump the gdx file to an Excel workbook
Execute "gdx2xls Ex19-5.gdx"
$offtext
