data gas;
infile 'C:\Users\daess\Desktop\study\학교\수업자료\2020학년도 2학기\시계열\gas.txt';
input gas co2 @@; time + 1;
run;

/*시계열도 그리기*/
proc sgplot data = gas;
series x = time y = gas;
xaxis label = 'time';
yaxis label = 'gas';
run;

/*SACF, SPACF 그리기*/
proc arima;
identify var = gas nlag = 24;
run;

/*MA(7)*/
proc arima;
identify var = gas nlag = 24;
estimate q = 7 method = cls;
forecast lead = 0 out = res_b;
run;

/*AR(3)*/
proc arima;
identify var = gas nlag = 24;
estimate p = 3 method = cls;
forecast lead = 0 out = res;
run;

/*모평균이 없는 모형 최대우도법 적용*/
proc arima;
identify var = gas nlag = 24;
estimate p = 3 method = ML noint;
forecast lead = 0 out = res;
run;


data res;
set res;
time =_n_;
run;

proc sgplot;
series x = time y = residual;
run;

/*잔차 SACF, SPACF*/
proc arima;
identify var = residual nlag = 24;
run;

/*과대적합*/
/*AR(4)*/
proc arima;
identify var = gas nlag = 24;
estimate p = 4 method = cls noint;
forecast lead = 0 out = res;
run;

/*AR(4) p = (1 2 4)*/
proc arima;
identify var = gas nlag = 24;
estimate p = (1 2 4)method = cls noint;
forecast lead = 0 out = res;
run;

/*ARMA(3,1)*/
proc arima;
identify var = gas nlag = 24;
estimate p = 3 q = 1 method = cls;
forecast lead = 0 out = res;
run;
