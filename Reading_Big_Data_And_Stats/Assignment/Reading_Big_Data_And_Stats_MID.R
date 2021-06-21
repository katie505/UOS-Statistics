rm(list=ls())
setwd('C:/Users/daess/desktop/midterm/data')

#1
#파일 불러오기
bnc <- read.table('./nsc2_edu_bnc.txt', header = TRUE, sep = '|')
bnd <- read.table('./nsc2_edu_bnd.txt', header = TRUE, sep = '|')
d20 <- read.table('./nsc2_edu_d20.txt', header = TRUE, sep = ',')
d30 <- read.table('./nsc2_edu_d30.txt', header = TRUE, sep = '|')
d40 <- read.table('./nsc2_edu_d40.txt', header = TRUE, sep = '|') 
d60 <- read.table('./nsc2_edu_d60.txt', header = TRUE, sep = '|')
g1e <- read.table('./nsc2_edu_g1e.txt', header = TRUE, sep = '|')
inst <- read.table('./nsc2_edu_inst.txt', header = TRUE, sep = '|')
k20 <- read.table('./nsc2_edu_k20.txt', header = TRUE, sep = ',')
k30 <- read.table('./nsc2_edu_k30.txt', header = TRUE, sep = '|')
k40 <- read.table('./nsc2_edu_k40.txt', header = TRUE, sep = '|')
m20 <- read.table('./nsc2_edu_m20.txt', header = TRUE, sep = ',')
m30 <- read.table('./nsc2_edu_m30.txt', header = TRUE, sep = '|')
m40 <- read.table('./nsc2_edu_m40.txt', header = TRUE, sep = '|')
m60 <- read.table('./nsc2_edu_m60.txt', header = TRUE, sep = '|')
p20 <- read.table('./nsc2_edu_p20.txt', header = TRUE, sep = ',')
p30 <- read.table('./nsc2_edu_p30.txt', header = TRUE, sep = '|')

#파일 내 건수 
nrow(bnc); nrow(bnd); nrow(d20); nrow(d30); nrow(d40); nrow(d60)
nrow(g1e); nrow(inst); nrow(k20); nrow(k30); nrow(k40); nrow(m20)
nrow(m30); nrow(m40); nrow(m60); nrow(p20); nrow(p30)

#2
bnc_RI <- unique(bnc$RN_INDI) #자격 및 보험료DB의 개인고유번호 집합
bnd_RI<- bnd$RN_INDI #출생 및 사망DB의 개인고유번호 집합
test <- bnc_RI %in% bnd_RI #두 집합 비교
length(which(test==FALSE)) #두 집합 내 서로 다른 값이 있는지 확인

#3
library(dplyr)
library(tibble)
view(bnd)
bnd_85 <- bnd %>% filter(BTH_YYYY %in% c('1921LE', '1920') & is.na(DTH_YYYYMM))
bnd_85
RI <- bnd_85$RN_INDI
bnc_sex <- bnc %>% filter(RN_INDI %in% RI) %>% select(RN_INDI, SEX)
bnc_sex <- bnc_sex[-which(duplicated(bnc_sex)),]
table(bnc_sex$SEX)

#4
bnd %>% filter(DTH_YYYYMM == 2013 & COD2 == 'X60-X84')

#5
#요양일수 포함한 데이터 합치기
f20 <- rbind(d20, k20, m20, p20)

#60년대생 생존자 개인고유번호 추출
bnd_60 <- bnd %>% filter(BTH_YYYY == 1960 & is.na(DTH_YYYYMM))
RI_60 <- bnd_60$RN_INDI

#개인별 요양일수의 합계 계산
f20_1 <- f20 %>% filter(RN_INDI %in% RI_60)
f20_1 <- aggregate(MDCARE_DD_CNT ~ RN_INDI, f20_1, sum)

#요양일수가 없는 사람의 요양일수 0 처리
tf <- RI_60 %in% f20_1$RN_INDI
index <- which(tf == FALSE)
zero <- data.frame(RN_INDI = RI_60[index], MDCARE_DD_CNT = 0)
f20_2 <- rbind(f20_1, zero)

#개인별 소득분위 추출
income <- bnc %>% filter(STD_YYYY == 2012 & RN_INDI %in% RI_60 & !is.na(CTRB_Q10))

#개인별 요양일수와 소득분위 합치기
income_1 <- income %>% select(RN_INDI, CTRB_Q10)
fi <- merge(f20_2, income_1, by = 'RN_INDI')

#소득분위별로 개인별 요양일수 총계 구하기
tot <- aggregate(MDCARE_DD_CNT ~ CTRB_Q10, fi, sum)

library(ggplot2)
ggplot(tot, aes(x = CTRB_Q10, y = MDCARE_DD_CNT)) + geom_line(stat = 'identity') +
  scale_x_discrete(limits = c('1', '2', '3', '4', '5', '6', '7','8', '9', '10')) +
  labs(x = '소득분위', y = '개인별 요양일수 합계')

cor(tot)

#6
#소득1분위에 있는 60년대 생존자(38명)
s1 <- income %>% filter(CTRB_Q10 == 1) %>% select(RN_INDI)
s1 <- f20 %>% filter(RN_INDI %in% s1$RN_INDI)
tot_s1 <- aggregate(ED_RC_TOT_AMT ~ RN_INDI, s1, sum)
tot_s1 <- sort(tot_s1$ED_RC_TOT_AMT)

#소득10분위에 있는 60년대 생존자(80명)
s10 <- income %>% filter(CTRB_Q10 == 10) %>% select(RN_INDI)
s10 <- f20 %>% filter(RN_INDI %in% s10$RN_INDI)
tot_s10 <- aggregate(ED_RC_TOT_AMT ~ RN_INDI, s10, sum)
tot_s10 <- sort(tot_s10$ED_RC_TOT_AMT)

#분포 그리기
par(mfrow = c(1,2))
plot(tot_s1, xlab = '소득1분위', ylab = '1인당 심결요양급여비용총액')
plot(tot_s10, xlab = '소득10분위', ylab = '1인당 심결요양급여비용총액')
