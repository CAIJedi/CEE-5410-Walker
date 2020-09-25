$ontext
Chapter 2,Problem 3, Bishop et al. Solution
Andrew Walker CEE 5410 Utah State University Fall 2020
09/20/20
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
Vprofit total benifit of planting;
Positive Variables X;
Equations
Profit total profit ($) and objective function value
Res_Constraint(res) Resource constraints;


Profit.. Vprofit =E= Sum(plnt,X(plnt)*p(plnt));
Res_Constraint(res).. Sum(plnt,A(plnt,res)*X(plnt)) =L= c(res);

MODEL Planting /Profit,Res_Constraint/;

SOLVE PLANTING USING LP MAXIMIZING VPROFIT;
    