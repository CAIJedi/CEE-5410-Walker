$ontext
CEE 5410 Fall 2020
Problem 6.1 in Bishop et. al

Minimize cost to supply water by a new treatment plant or wholesale contract
This is the relaxed version that treats the interger decision variables
as standard, positive, continuous variables.

Integer version using INTEGER VARIABLES statement and SOLVE as MIP.

Andrew Walker
09/28/20
$offtext

* 1. DEFINE the SETS
SETS src water supply sources /tp "treatment plant", wc "wholesale contract"/;

* 2. DEFINE input data
PARAMETERS
   CapCost(src) capital cost ($ to build)
         /tp 90000/
   OpCost(src) operating cost ($ per ac-ft)
         /tp 120
          wc 150/
   MaxCapacity(src) Maximum capacity of source when built (ac-ft per year)
          /tp 2000,
           wc  12000/
   MinUse(src) Minimum required use of source when built (ac-ft per year)
          /tp 0,
           wc  1000/
   TotDemand  Total Demand (ac-ft per year) /2000/
* "Integer" variables free within 0 to 1 bounds. Same as "Binary Variables" statement below
* Leave values as is
   IntUpBnd(src) Upper bound on integer variables (#)
          /tp 1,
           wc 1/
   IntLowBnd(src) Lower bound on integer variables (#)
           /tp 0,
           wc 0/

* 3. DEFINE the variables
VARIABLES I(src) binary decision to build or do prject from source src (1=yes 0=no)
          X(src) volume of water provided by source src (ac-ft per year)
          TCOST  total capital and operating costs of supply actions ($);

BINARY VARIABLES I;
* Non-negativity constraints
POSITIVE VARIABLES X;

* 4. COMBINE variables and data in equations
EQUATIONS
   COST            Total Cost ($) and objective function value
   MaxCap(src)     Maximum capacity of source when built (ac-ft per year)
   MinReqUse(src)  Minimum required use of source when built (ac-ft per year)
   MeetDemand      Meet demand (ac-ft per year)
   IntUpBound(src) Upper bound on interger variables (number)
   IntLowBound(src) Lower bound on integer variables (number);

COST..                 TCOST =E= SUM(src,CapCost(src)*I(src) + OpCost(src)*X(src));
MaxCap(src) ..           X(src) =L= MaxCapacity(src)*I(src);
MinReqUse(src) ..        X(src) =G= MinUse(src)*I(src);
MeetDemand ..            sum(src,X(src)) =G= TotDemand;
IntUpBound(src) ..       I(src) =L= IntUpBnd(src);
IntLowBound(src) ..      I(src) =G= IntLowBnd(src);

* 5. DEFINE the MODEL from the EQUATIONS
MODEL WatSupplyRelaxed /ALL/;

* 6. Solve the Model as an LP (relaxed IP)
SOLVE WatSupplyRelaxed USING MIP MINIMIZING TCOST;

DISPLAY X.L, I.L, TCOST.L;

* Dump all input data and results to a GAMS gdx file
Execute_Unload "MIP.gdx";
* Dump the gdx file to an Excel workbook
Execute "gdx2xls MIP.gdx"
