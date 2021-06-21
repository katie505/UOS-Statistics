proc import datafile = 'C:\Users\daess\Desktop\회귀2\자료\diabetes.csv' dbms = csv
replace out = diabetes;
getnames = yes;
run;

proc standard data = diabetes out = zcore mean = 0 std = 1;
var preg glu bp st insul dpf age bmi;
run;

proc print data = zcore;
run;

proc export data = zcore outfile = 'C:\Users\daess\Desktop\회귀2\자료\standard.csv';
run;

proc import datafile = 'C:\Users\daess\Desktop\회귀2\자료\standard.csv' dbms = csv
replace out = diabetes;
getnames = yes;
run;
/*회귀계수추정*/
proc logistic data = diabetes descending;
model outcome = preg glu bp st insul dpf age bmi / selection = backward lackfit;
run;

proc logistic data = diabetes descending;
model outcome = preg glu bp st insul dpf age bmi;
run;

proc genmod data = diabetes;
model outcome = preg glu dpf bmi / residuals;
run;

/*최종모형 적합도 검정*/
proc logistic data = diabetes;
class outcome(ref = '0');
model outcome = preg glu dpf bmi /scale = none aggregate = (preg glu dpf bmi);
run;

proc import datafile = 'C:\Users\daess\Desktop\회귀2\자료\outcome.txt'
dbms = csv replace out = outcome;
getnames = yes;
run;

proc import datafile = 'C:\Users\daess\Desktop\회귀2\자료\real.txt'
dbms = csv replace out = predict;
getnames = yes;
run;

proc print data = diabetes;
run;

proc compare data = outcome compare = predict;
var outcome;
with predict;
run;

