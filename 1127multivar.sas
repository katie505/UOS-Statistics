proc import datafile = 'C:\Users\daess\desktop\income.csv'
dbms = csv replace out = income;
run;

proc print data = income;
run;

/*income �����Ϳ��� 2��° �� own�� �з�*/
proc discrim data = income pool = yes out = local; /*pool = yes : �յ����л��� ���ڴ�.������ ����*/
class own;
var income size;
run;

proc discrim data = income pool = yes 
listerr out = local; /*pool = yes : �յ����л��� ���ڴ�.*/
class own;
var income size;
run;

proc print data = local;
run; /*���â���� _INTO_�� ���� ��.*/

data test; 
input xvalues own_test $ income size; 
cards; 
1 . 60.5 19.5 
2 . 79.0 18.0 
3 . 88.0 17.0 
;
proc print data = test;
run;

proc discrim data = local testdata = test testlist 
testout = test_out; 
class own; 
var income size; 
run; 

proc print data = test_out; 
run;

/*ex2*/
proc import datafile = 'C:\Users\daess\desktop\skull.csv'
dbms = csv replace out = skull;
run;
proc print data = skull (obs = 10);
run;

proc discrim data = skull pool = test listerr out = skull_out;
class group;
var x1--x4;
run;

proc discrim data = skull pool = test listerr out = skull_out simple;
class group;
var x1--x4;
priors prop; /*prior�� ������ ������ */
run;

/*cross validation*/
proc discrim data = skull pool = test  simple crosslisterr out = skull_out;
class group;
var x1--x4;
priors prop;
run;
