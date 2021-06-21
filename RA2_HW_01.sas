data h;
infile 'C:\Users\daess\Desktop\h.txt';
input x1 x2 y;
run;

proc nlin data = h method = gauss plots = (fit diagnostics);
	model y = exp(-b1*x1*exp(-b2*(1/x2 - 1/620)));
	parms b1 = 0.01155 b2 = 5000; 
run;

data j;
infile 'C:\Users\daess\Desktop\j.txt';
input x1 x2 y;
run;

proc nlin data = j method = gauss plots = (fit diagnostics);
	model y = b1*b3*x1/(1+b1*x1+b2*x2);
	parms b1 = 2.9 b2 = 12.2 b3 =0.69;
run;
