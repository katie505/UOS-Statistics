proc import datafile = 'C:\Users\daess\desktop\data2.txt'
dbms = csv replace out = hw2;
getnames = yes;
run;

proc gplot data = hw2;
plot cerio * conc = strain / haxis = axis2 vaxis = axis1;
axis1 major = (w = 1 h = 1) minor = (w = 1 h = 0.5)
	label = (f = duplex h = 3 C = black A = 90 R = 0 "Ceriodaphnia") value = (h = 2);
axis2 major = (w = 1 h = 1) minor = (w = 1 h = 0.5)
	label = (f = duplex h = 3 C = black A = 0 R = 0 "Concentration") value = (h = 2);
symbol1 v = circle c = blue i = none h = 1;
symbol2 v = dot c = red i = none h = 1;
run;

proc reg data = hw2;
model cerio = conc strain;
output out = b p = pred r = resid;
plot cerio * conc = strain;
run;

proc gplot data = b;
plot resid * conc / vref = 0 haxis = axis2 vaxis = axis1;
axis1 major = (w = 1 h = 1) minor = (w = 1 h = 0.5)
	label = (f = duplex h = 3 C = black A = 90 R = 0 "Ceriodaphnia") value = (h = 2);
axis2 major = (w = 1 h = 1) minor = (w = 1 h = 0.5)
	label = (f = duplex h = 3 C = black A = 0 R = 0 "Concentration") value = (h = 2);
symbol1 v = circle c = blue i = none h = 1;
run;

data t;
set hw2;
l_cerio = log(cerio);
run;

proc reg data = t;
model l_cerio = conc strain;
output out  = g p = pred r = resid;
run;

proc gplot data = g;
plot (l_cerio pred) * conc;
run;

proc gplot data = g;
plot resid * conc / vref = 0 haxis = axis2 vaxis = axis1;
axis1 major = (w = 1 h = 1) minor = (w = 1 h = 0.5)
	label = (f = duplex h = 3 C = black A = 90 R = 0 "Residual") value = (h = 2);
axis2 major = (w = 1 h = 1) minor = (w = 1 h = 0.5)
	label = (f = duplex h = 3 C = black A = 0 R = 0 "Concentration") value = (h = 2);
symbol v = dot i = none h = 1;
run;

proc genmod data = hw2;
model cerio = conc strain / dist = poisson link = log type3;
output out = d pred = predicted resdev = resid;
run;

proc gplot data = d;
plot predicted * conc = strain / haxis = axis2 vaxis = axis1;
axis1 major = (w = 1 h = 1) minor = (w = 1 h = 0.5)
	label = (f = duplex h = 3 C = black A = 90 R = 0 "Predicted Values") value = (h = 2);
axis2 major = (w = 1 h = 1) minor = (w = 1 h = 0.5)
	label = (f = duplex h = 3 C = black A = 0 R = 0 "Concentration") value = (h = 2);
symbol1 v = dot i = spline h = 1;
symbol2 v = dot i = spline h = 1;
run;

proc gplot data = d;
plot resid * conc / haxis = axis2 vaxis = axis1 vref = 0;
axis1 major = (w = 1 h = 1) minor = (w = 1 h = 0.5)
	label = (f = duplex h = 3 C = black A = 90 R = 0 "Residuals") value = (h = 2);
axis2 major = (w = 1 h = 1) minor = (w = 1 h = 0.5)
	label = (f = duplex h = 3 C = black A = 0 R = 0 "Concentration") value = (h = 2);
symbol1 v = dot i = none c = blue h = 1;
run;
