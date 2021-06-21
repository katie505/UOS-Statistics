proc import datafile = 'C:\Users\daess\Desktop\ȸ��2\�ڷ�\diabetes.csv' dbms = csv
replace out = diabetes;
getnames = yes;
run;

proc standard data = diabetes out = zcore mean = 0 std = 1;
var preg glu bp st insul dpf age bmi;
run;

proc print data = zcore;
run;

proc export data = zcore outfile = 'C:\Users\daess\Desktop\ȸ��2\�ڷ�\standard.csv';
run;

proc import datafile = 'C:\Users\daess\Desktop\ȸ��2\�ڷ�\standard.csv' dbms = csv
replace out = diabetes;
getnames = yes;
run;
/*ȸ�Ͱ������*/
proc logistic data = diabetes descending;
model outcome = preg glu bp st insul dpf age bmi / selection = backward lackfit;
run;

proc logistic data = diabetes descending;
model outcome = preg glu bp st insul dpf age bmi;
run;

proc genmod data = diabetes;
model outcome = preg glu dpf bmi / residuals;
run;

/*�������� ���յ� ����*/
proc logistic data = diabetes;
class outcome(ref = '0');
model outcome = preg glu dpf bmi /scale = none aggregate = (preg glu dpf bmi);
run;

proc import datafile = 'C:\Users\daess\Desktop\ȸ��2\�ڷ�\outcome.txt'
dbms = csv replace out = outcome;
getnames = yes;
run;

proc import datafile = 'C:\Users\daess\Desktop\ȸ��2\�ڷ�\real.txt'
dbms = csv replace out = predict;
getnames = yes;
run;

proc print data = diabetes;
run;

proc compare data = outcome compare = predict;
var outcome;
with predict;
run;

