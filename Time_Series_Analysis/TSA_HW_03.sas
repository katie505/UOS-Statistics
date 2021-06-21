data mindex;
infile 'C:\Users\daess\desktop\mindex.txt';
input mindex @@;
date = intnx('month','1jan86'd,_n_-1);
format date monyy.; run;
proc sgplot;
series x=date y=mindex;
run;

proc forecast data =mindex
interval=month method=expo out=out1 outest=est1
weight=0.2 trend=1 lead=6 outfull outresid;
id date; var mindex; run;

proc sgplot data=out1;
series x=date y=mindex / group=_type_;
where _type_^='RESIDUAL'; refline '01may94'd / axis=x;
yaxis values=(0 to 30 by 5); run;


proc forecast data =mindex
interval=month method=expo out=out2 outest=est2
weight=0.2 trend=1 astart=9.3 lead=6 outfull outresid;
id date; var mindex; run;

proc sgplot data=out2;
series x=date y=mindex / group=_type_;
where _type_^='RESIDUAL'; refline '01may94'd / axis=x;

proc forecast data =mindex
interval=month method=expo out=out3 outest=est3
weight=0.2 trend=1 astart=11.912 lead=6 outfull outresid;
id date; var mindex; run;

proc sgplot data=out3;
series x=date y=mindex / group=_type_;
where _type_^='RESIDUAL'; refline '01may94'd / axis=x;
yaxis values=(0 to 30 by 5); run;

data out4;
set out1 out2 out3;
run;

proc sgplot data=out4;
series x=date y=mindex / group=_type_;
where _type_^='RESIDUAL'; refline '01may94'd / axis=x;
yaxis values=(0 to 30 by 5); run;
