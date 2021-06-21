/*==========================================================*/
/*���� �м� : ���� 4-1 [ǥ 4.3]*/

/* �ڷḦ �о�帮�� SAS ���� ����

����: SAS�� ��� ������ �����ݷ�(;)���� ������!!!!!!!!

(1) SAS dataset�� �̸� ����
    DATA �� ������  SAS dataset�� �̸��� �����Ѵ�. �Ʒ����� SAS dataset�� �̸��� liver�� �ȴ�.

(2) ������ ���� 
    INPUT �� �������� �о�帱 ������ �������  ����. ������������ �̸� �ڿ���  $�� ���δ�.
    ���� �� �ٿ� �� �� �̻��� ���������� ���� ���� �������� @@�� ���δ�.

(3) �ڷ�
    �����ʹ� ó���� CARDS; �� �����ϰ� INPUT ���� ������ ������ ������� �ڷḦ ��ġ�Ѵ�.
    ������ �����͵ڿ� �����ݷ�(;)�� ���δ�. 
*/

DATA liver;
INPUT trt $ remission y @@;
CARDS;
A   3   0 A 3   1
A   3   1 A 6   1
A   15  0 A 6   1
A   6   1 A 6   1
A   15  0 A 15  0
A   12  0 A 18  0
A   6   1 A 15  0
A   6   1 A 15  0
A   12  1 A 9   0
A   6   1 A 6   0
A   6   0 A 6   0
A   3   1 A 18  0
A   9   0 A 12  1
A   6   0 A 9   1
A   9   1 A 3   0
A   9   1 A 12  0
A   12  0 A 3   0
A   12  0 A 12  0
A   12  0 A 9   1
A   6   1 A 12  0
A   6   0 A 15  1
A   9   0 A 3   1
A   9   0 A 9   0
A   9   0 A 9   0
A   9   1 A 12  1
A   3   1 B 9   1
B   3   0 B 12  1
B   3   1 B 3   1
B   15  1 B 9   1
B   12  1 B 3   1
B   9   1 B 15  1
B   9   1 B 6   1
B   9   1 B 6   1
B   12  0 B 9   0
B   15  0 B 15  1
B   9   0 B 9   0
B   12  1 B 3   1
B   6   1 B 6   1
B   12  0 B 12  0
B   12  1 B 3   1
B   12  1 B 3   1
B   12  1 B 6   1
B   6   1 B 9   1
B   15  0 B 15  0
B   12  0 B 9   0
B   12  0 B 15  0
B   18  1 B 12  0
B   15  1 B 15  0
B   15  0 B 18  0
B   18  1 B 18  0
B   18  0 B 6   1
;


/* LOGISTIC regression */
/*

(1) ������ƽ ȸ�͸� �����ϴ� ���νõ��� PROC LOGISTIC�̴�.

(2)  �������� ���Ǵ� �����߿� ������ ������ �����Ѵ�.

     CLASS x1 ....;

(3) ������ ������ ����  �����Ѵ�.

    (a) �������� y�� ���׺����� ���(single-trial syntax) (���� 4-1)
 
        model y = x1 x2 ..../SCALE=NONE AGGREGATE;

    (b) ���������� ��� �������̰� ���������� ������ ���� ������ �־��� ��� (���� 4-2)

        FREQ count;
        MODEL y =x1 x2 .. /SCALE=NONE AGGREGATE;

         
    (c) ���������� ����ȸ��(n)�� ����ȸ��(r)�� ���(events/trials syntax) 
 
        model  r/n = x1 x2 ... /SCALE=NONE AGGREGATE;

    

    ����:  MODEL ���� �� ���� option ���� �ִµ� ������ ������ �������� ����Ƿ� �����ϰ� ������ �ٿ��ش�. 
 
            - AGGREGATE: show Pearson chi-square test statistic and the likelihood ratio chi-square test statistic 
            - SCALE=NONE: specifies that no correction is needed for the dispersion parameter; that is, the dispersion parameter remains as 1

(4) PROC LOGISTIC�� �ƹ��� option�� �������� �ʴ´ٸ� ���������� ���ָ� ��������(ũ���)���� �����Ͽ� ���� ó���� ������ 
    ���ָ� ����������� �����Ѵ�.  ���������� ���ָ� ������������ �����Ͽ� ������ ���ָ� ����������� �Ϸ��� DESCENDING ������
     PROC LOGISTIC �ڿ� �ٿ��ش�.

*/

PROC LOGISTIC data=liver DESCENDING;
CLASS trt;
MODEL y=trt remission/SCALE=NONE AGGREGATE;
RUN;


/*  ���� Ȯ���� ����

  ������ƽ ȸ�ͺм����� ȸ�Ͱ���� ������ ������ �־��� ���������� ���� ����Ȯ���� ������ ���� �����Ѵ�.

                                            exp(b0 + b1*x1 + b2*x2 + ... + bp*xp) 
      P(Y=1 | x1, x2 ... xp) =     ----------------------------------
                                            1 +  exp(b0 + b1*x1 + b2*x2 + ... + bp*xp) 


  (a)  �׷��� ���� 
     �� ó���� ���Ͽ� remission(x) �� ���� Ȯ��(p(y=1|x))���� �Լ� ���踦 graph�� ��Ÿ������  PROC LOGISTIC .... ���� ����  
     ods graphics on; �� ����  option�� plots(only)=(effect) �� �߰��Ѵ�.

  (b) ������ȭ�� ���� 
     �ڷ��� �־��� ���������� ���Ͽ� ������ ������ Ȯ���� dataset���� ������ �� �ִ�. ������ ���� ������ �߰��ϸ� predprob ��� 
     dataset�� ���� ����� ������ Ȯ����  pred_prob������ �����Ѵ�.
 
*/

ods graphics on;
PROC LOGISTIC data=liver  DESCENDING plots(only)=(effect);;
CLASS trt;
MODEL y=trt remission/SCALE=NONE AGGREGATE;
output out=pdata  predicted = pred_prob; 
RUN;

PROC PRINT data = pdata; run; 
/*�ؽ�Ʈ ���Ϸ�  ����� ������ ������ �ҷ�����*/
data liver1;
infile 'C:\Users\UOS\Desktop\TA\liver.txt' dlm='09'x; /*�ؽ�Ʈ ���Ͽ��� tab�� �����ڷ� ���*/
input trt $ remission y;
run;


/*  ���ο� ����ġ�� ���� Ȯ���� ���� 

���࿡ ���� ���� �м��� ������ �� ���ο� ȯ�ڰ� ��Ÿ���� A ġ�Ḧ �ް�(trt=A) ȣ���Ⱓ�� 13�� �̶�� (remission=12)
��� Ȯ���� �󸶷� �����ϰڴ°�? 

���׼� ������ SAS�� ��� �� ȸ�Ͱ���� ������� (Analysis of Maximum Likelihood Estimates)�� �̿��ϸ� ������ ���� ����� �� �ִ�.

                                              exp(2.0446 + -0.5887*1 + -0.1998 *13) 
      P(Y=1 | x1=A, x2=13) =     -------------------------------------
                                            1 +  exp(2.0446 + -0.5887*1 + -0.1998 *13) 

�Ǵ� B ġ�Ḧ �ް�(trt=A) ȣ���Ⱓ�� 7�� �̶�� ��� Ȯ����?

�̷��� ���ο� ����ġ�� ���� Ȯ���� ������ ������ ���� 
     (a) outmodel=predmodel �� option�� �߰��Ͽ� ����� �����ϰ� (noprint �� ����� ������� �ʴ´�)
     (b) ���������� �ִ� ���ο� SAS dataset new �� �����
     (c) PROC LOGISTIC �� score ���� ���ο� �ڷḦ �����Ͽ�(score data=new) ���� Ȯ����  ����� �� �ִ�. 

*/

PROC LOGISTIC DESCENDING data=liver  outmodel=predmodel noprint   ;
CLASS trt;
MODEL y=trt remission/SCALE=NONE AGGREGATE;
RUN;

DATA new;
INPUT trt $ remission ;
CARDS;
A   13
B  7
;
run; 

PROC LOGISTIC inmodel=predmodel  ;
    score data=new out=newprob;
RUN;

proc print data=newprob; run;

/*=======================================================================*/
/*���� �м� : ���� 4-2 [ǥ 4.9]*/
DATA cure;
INPUT type $ trt $ outcome $ count @@;
CARDS;
T A cured 65  T A uncured 18
M B cured 100 M B uncured 13
T C cured 56  T C uncured 38
M A cured 80  M A uncured 15
T B cured 29  T B uncured 9
M C cured 78  M C uncured 22
;

PROC LOGISTIC;
FREQ count;
CLASS type trt;
MODEL outcome =type trt/SCALE=NONE AGGREGATE;
RUN;
