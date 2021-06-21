/* 주성분분석 */
proc import datafile = 'C:\Users\uos\Desktop\real.csv'
dbms = csv out = original replace;
run;

data original;
set original;
label
district = '지역'
y = '행복지수'
x1 = '공교육 환경'
x2 = '사교육 환경'
x3 = '교육수준 및 질'
x4 = '소득 10점평균'
x5 = '문화생활 비용'
x6 = '지역 생활환경'
x7 = '체감안전'
;
run;

title '기존 데이터';
proc print data = original label;
run;

proc standard data = original mean = 0 std = 1 out = standard;
var y x1--x7;
run;

title '표준화 처리한 데이터';
proc print data = standard label;
run;

proc princomp data = standard out = prin;
var x1--x7;
run;

/* 판별분석 */

proc import datafile =  'C:\Users\uos\Desktop\newprin.csv'
dbms = csv replace out = dis;
run;

proc print data = dis;
run;

data dis;
set dis;
label
district = '지역'
Prin1 = '교육환경 주성분'
Prin2 = '주거환경 주성분'
Prin3 = '경제환경 주성분'
y = '표준화 행복지수'
group = '행복지수 그룹화'
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

/* 추가 */

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
