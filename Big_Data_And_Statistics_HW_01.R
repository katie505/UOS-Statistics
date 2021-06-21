rm(list = ls())
if(!require(readxl)){install.packages('readxl');library(readxl)}

# 1. 데이터 선택
# 생존함수를 구하기 위해서 국민건강보험공단의 ‘표본코호트 2.0 DB’ 중 
# 출생 및 사망 테이블(NSC2_BND_1000.xlsx)를 선택했다.

# 2. 데이터 전처리
# 본격적으로 생존함수를 구하기 전, 원데이터를 적절한 데이터 형태로 전처리하겠다.

# 1) 데이터 불러오기
data <- read_excel('C:/Users/daess/desktop/NSC2_BND_1000.xlsx')

# 2) 원데이터에서 출생년도 데이터를 추출하여 변수 birth_time에 저장
# 3) birth_time에는 1921년 이전에 태어난 사람은 '1921LE'로 되어있기 때문에 편의상 '1921'로 바꾸기
# 4) birth_time의 값은 문자형이기때문에 수치형으로 바꿔줌
birth_time <- data$BTH_YYYY
birth_time[birth_time == '1921LE'] <- '1921'
birth_time <- as.numeric(birth_time)

# 5) 원데이터에는 사망년도가 없기 때문에 사망년도 랜덤 생성
# 사망년도는 표본코호트 2.0 DB 사용자 메뉴얼에 기재된 
# 출생 및 사망 테이블의 개요를 참고하여 2006년에서 2015년 사이로 정하였다.
death_time <-sample(x = 2006:2015, size = length(birth_time),replace = T)

# 6) birth_time과 death_time 합치기
df <- data.frame(birth_time, death_time)

# 7) 데이터 중 사망년도보다 출생년도가 이후인 행들(생존시간이 음수인 경우)이 존재하므로 
# 이에 해당하는 행들의 사망년도를 편의상 2021년으로 바꾼다
df$death_time[df$birth_time>df$death_time] <- 2021

# 3. 생존함수 구하기
# S(t) = 1 - F(t) 임을 이용하였다.

st <- df$death_time - df$birth_time
s <- sort(st)
Fx <- 1:length(st)*(1/length(st))
fx <- 1 - Fx

# 생존함수 그리기
par(mfrow = c(1,1))
plot(s, fx, type = 'l', xlab = 'time', ylab = 'survival probability', 
     main = 'survival function')

