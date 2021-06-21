/* �ּ��км� */
proc import datafile = 'C:\Users\uos\Desktop\real.csv'
dbms = csv out = original replace;
run;

data original;
set original;
label
district = '����'
y = '�ູ����'
x1 = '������ ȯ��'
x2 = '�米�� ȯ��'
x3 = '�������� �� ��'
x4 = '�ҵ� 10�����'
x5 = '��ȭ��Ȱ ���'
x6 = '���� ��Ȱȯ��'
x7 = 'ü������'
;
run;

title '���� ������';
proc print data = original label;
run;

proc standard data = original mean = 0 std = 1 out = standard;
var y x1--x7;
run;

title 'ǥ��ȭ ó���� ������';
proc print data = standard label;
run;

proc princomp data = standard out = prin;
var x1--x7;
run;

/* �Ǻ��м� */

proc import datafile =  'C:\Users\uos\Desktop\newprin.csv'
dbms = csv replace out = dis;
run;

proc print data = dis;
run;

data dis;
set dis;
label
district = '����'
Prin1 = '����ȯ�� �ּ���'
Prin2 = '�ְ�ȯ�� �ּ���'
Prin3 = '����ȯ�� �ּ���'
y = 'ǥ��ȭ �ູ����'
group = '�ູ���� �׷�ȭ'
;
run;

proc discrim data = dis listerr pool = yes manova out = result;
class group;
var prin1 prin2 prin3;
priors prop;
run;

proc discrim data = dis pool = test;
class group;
var prin1 prin2 prin3;
priors prop;
run;

/* �߰� */

proc import datafile =  'C:\Users\uos\Desktop\prin.csv'
dbms = csv replace out = aaa;
run;

proc print data = aaa;
run;

proc standard data = aaa mean = 0 std = 1 out = aa_;
var aaa;
run;

proc print data = aa_;
run;
