proc import datafile = 'C:\Users\daess\desktop\data1.xlsx'
dbms = xlsx replace out = hw1;
getnames = yes;
run;

proc gplot data = hw1;
plot number * age / haxis = axis2 vaxis = axis1;
axis1 major = (w = 2 h = 1) minor = (w = 1 h = 0.5)
	label = (f = duplex h = 3 C = black A = 90 R = 0 "Number") value = (h = 3);
axis2 major = (w = 2 h = 1) minor = (w = 1 h = 0.5)
	label = (f = duplex h = 3 C = black A = 0 R = 0 "Age") value = (h = 3);
symbol v = circle h = 1.5 c = blue;
run;

proc reg data = hw1;
model number = age;
plot number * age;
plot rstudent. * age / vref = -2.5 2.5;
plot rstudent. * obs. / vref = -2.5 2.5 cvref = blue lvref = 1
href = 0 to 50 by 5 chref = red cframe = ligr;
run;

proc genmod data = hw1;
model number = age / dist = poisson link = log type3;
output out = b pred = predicted resdev = resid;
run;

proc gplot data = b;
plot (number predicted) * age /  haxis = axis2 vaxis = axis1 overlay;
axis1 major = (w = 2 h = 1) minor = (w = 1 h = 0.5)
	label = (f = duplex h = 3 C = black A = 90 R = 0 "Number") value = (h = 3);
axis2 major = (w = 2 h = 1) minor = (w = 1 h = 0.5)
	label = (f = duplex h = 3 C = black A = 0 R = 0 "Age") value = (h = 3);
symbol v = circle h = 1.5 c = blue;;
run;

proc gplot data = b;
plot resid * age /  haxis = axis2 vaxis = axis1 vref = 0;
axis1 major = (w = 2 h = 1) minor = (w = 1 h = 0.5)
	label = (f = duplex h = 3 C = black A = 90 R = 0 "Residual") value = (h = 3);
axis2 major = (w = 2 h = 1) minor = (w = 1 h = 0.5)
	label = (f = duplex h = 3 C = black A = 0 R = 0 "Age") value = (h = 3);
symbol v = dot i = none h = 1;
run;

data c;
set hw1;
age2 = age**2;

proc genmod data = c;
model number = age age2 / dist = poisson link = log type3;
output out = d pred = predicted resdev = resid;
run;

