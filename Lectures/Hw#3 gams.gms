$ontext
Chapter 2,Problem 3, Bishop et al. Solution
Andrew Walker CEE 5410 Utah State University Fall 2020
09/28/20
$offtext

*Defining the sets
SETS 
plnt types of plant to grow /Hay, Grain/
res resources constrained /Land,Jw "June",Jlw "July", Auw "August"  /;
*Defining Parameters
PARAMETERS
p(plnt) Benifit per plant planted ($)
 / Hay 100, Grain 120/
c(res) right hand constraint values (per resource)
/ Land 10000, Jw 14000, Jlw 18000, Auw 6000/; 
*Defining Constraints
Table A(plnt,res) lefthand constraint cooeficents
      Land  Jw   Jlw    Auw
 Hay   1     2     1     1
 Grain 1     1     2     0 ;
* Selecting Variables
Variables
X(plnt) number of each plant
Vprofit total benifit of planting
Y(res) value of resources used (varies with plants)
VREDCOST total reduced cost ($);
Positive Variables X;
Equations
Profit_Primal total profit ($) and objective function value
Res_Constraint_primal(res) Resource constraints
REDCOST_DUAL Reduced Cost ($) associated with using resources
RES_CONS_DUAL(plnt) Profit levels ;

*Primal Equations
Profit_Primal.. Vprofit =E= Sum(plnt,X(plnt)*p(plnt));
Res_Constraint_Primal(res).. Sum(plnt,A(plnt,res)*X(plnt)) =L= c(res);
*Dual Equations
REDCOST_DUAL..                 VREDCOST =E= SUM(res,c(res)*Y(res));
RES_CONS_DUAL(plnt)..          sum(res,A(plnt,res)*Y(res)) =G= p(plnt);

MODEL PLANT_PRIMAL /Profit_Primal, Res_Constraint_Primal/;
*Set the options file to print out range of basis information
PLANT_PRIMAL.optfile = 1;

*DUAL model
MODEL PLANT_DUAL /REDCOST_DUAL, RES_CONS_DUAL/;

SOLVE PLANT_PRIMAL USING LP MAXIMIZING VPROFIT;

* Solve the PLANTING DUAL model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize VPROFIT
SOLVE PLANT_DUAL USING LP MINIMIZING VREDCOST;

Execute_Unload "HW3_Dual.gdx";
* Dump the gdx file to an Excel workbook
Execute "gdx2xls HW3_Dual.gdx"  