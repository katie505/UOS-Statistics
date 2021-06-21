rm(list = ls()); gc(reset = T)

# ----------------------------
counts = table(state.region)
counts
barplot(counts, main = "simple bar chart", 
        xlab = "region", ylab = "freq")

# ----------------------------
counts = table(state.region)
counts

#barplot에서 height 자리에는 그래프를 구성하는 막대에 대응되는 높이에 해당되는 
#값들의 벡터 대입
barplot(c(1,2,5,1))
barplot(matrix(c(1,2,5,1), 2, 2))
barplot(matrix(c(1,2,5,1,3,4),3,2))

x = c(1,3)
names(x)
names(x) = c('a', 'b')
x

#barplot에서는 names.arg로 변수이름 지정 가능
#names.arg와 xlab 잘 구분하기
x = c(1,2)
barplot(x)
barplot(x, xlab = 'levels')
barplot(x, xlab = 'levels', names.arg = c('a', 'b'))  #xlab : x축의 이름


barplot(counts, main = "simple bar chart", 
        xlab = "region", ylab = "freq")

# ----------------------------
freq.cyl = table(mtcars$cyl)
barplot(freq.cyl, col ="light blue", names.arg = c('a', 'b', 'c'))
colors()

x = 1:10
barplot(x, names.arg = 1:10)
par(las = 2) #변수 이름을 길게 써야할 경우 모든 변수명이 표시되게 하기 위한 옵션
par(las = 2, mai = c(1.5,1,1,1))#그래프 아래쪽 영역을 늘리기

barplot(x, names.arg = paste(1:10, 'cyl - activation'))

cyl.name =  c("4 cyl", "6 cyl", "8 cyl")
barplot(freq.cyl, main = "simple bar chart", col ="light blue",
        names.arg = cyl.name)

# ----------------------------
paste('a', 'b')
paste0('a', 'b') #띄어쓰기 없이 붙여줌

#파이차트에 빈도수가 아닌 백분율 표시
percent = prop.table(table(mtcars$cyl))*100
percent = round(freq.cyl / sum(freq.cyl)*100, 1)
cyl.name2 = paste0(cyl.name, "(", freq.cyl / sum(freq.cyl)*100, '%')

cyl.name2 = paste0( cyl.name, "(", percent, "%)")
pie(freq.cyl, labels = cyl.name2, 
    col = rainbow(length(freq.cyl)), main = "pie chart")

cyl.name2 = paste0( cyl.name, "(", freq.cyl, "%)")
pie(freq.cyl, labels = cyl.name2, 
    col = rainbow(length(freq.cyl)), main = "pie chart")

# ----------------------------
cyl.name2 = paste0( cyl.name, "(", freq.cyl, "%)")
pie(freq.cyl, labels = cyl.name2, 
    col = rainbow(length(freq.cyl)), main = "pie chart")
pie(freq.cyl, labels = cyl.name2, 
    col = c('tomato1', 'light green', 'light blue'), main = "pie chart")

#rainbow
?rainbow

# ----------------------------
if(!require(plotrix)){install.packages("plotrix"); library(plotrix)}
pie3D(freq.cyl, labels = cyl.name2, explode = 0.1, main = "3d pie plot")

# ----------------------------
fan.plot(freq.cyl, labels = cyl.name2, main = "Fan plot")

# ----------------------------
if(!require(vcd)){install.packages("vcd"); library(vcd)}

head(Arthritis, n = 3)

# ----------------------------
my.table <- xtabs( ~ Treatment + Improved, data = Arthritis)
my.table

# ----------------------------
barplot( my.table,
         xlab = "Improved", ylab = "Frequency", legend.text = TRUE,
         col = c("green", "red"))

#높이를 같게 만들어주기
colSums(my.table)
matrix(rep(colSums(my.table), each = 2), 2, 3)
a <- my.table / matrix(rep(colSums(my.table), each = 2), 2, 3)
barplot( a,
         xlab = "Improved", ylab = "Frequency", legend.text = TRUE,
         col = c("green", "red"))

# ----------------------------
barplot( t(my.table),
         xlab = "Improved", ylab = "Frequency", legend.text = TRUE,
         col = c("green", "red", "orange"))

# ----------------------------
t(my.table)

# ----------------------------
barplot( t(my.table),
         xlab = "Improved", ylab = "Frequency", legend.text = TRUE,
         col = c("green", "red", "orange"))

# ----------------------------
tmp = c("buckled", "unbuckled")
belt <- matrix( c(58, 2, 8, 16), ncol = 2, 
                dimnames = list(parent = tmp, child = tmp))
belt

# ----------------------------
spine(belt, main="spine plot for child seat-belt usage",
      gp = gpar(fill = c("green", "red")))


# ----------------------------
x = rnorm(100)
boxplot(x, main = "boxplot", col ='lightblue')
quantile(x)
IQR(x)
# ----------------------------
par(mfrow = c(1,2))
x = faithful$waiting

#같은 데이터지만 보여주는 것은 다름
#
hist(faithful$waiting, nclass = 8)
boxplot(x)

# ----------------------------
x = faithful$waiting
hist(faithful$waiting, breaks = seq(min(x), max(x), length = 10),
     probability = T)

# ----------------------------
x = faithful$waiting
hist(faithful$waiting, nclass = 10, probability = T)
lines(density(x), col = "red", lwd = 2)

# ----------------------------
if(!require(vioplot)){install.packages("vioplot"); library(vioplot)}

x = rpois(1000, lambda = 3)
vioplot(x, col = "lightblue")

# ----------------------------
x = rpois(1000, lambda = 3)
vioplot(x, col = "lightblue", names = 'variable')

# ----------------------------
rm(list = ls())
attach(mtcars)
mtcars
boxplot(mpg~cyl, data = mtcars, names = c('4 cyl','6 cyl', '8 cyl'),
        main = "MPG dist by cylinder")

# ----------------------------
hist(mpg[cyl==4], xlab="MPG", main = "MPG dist by cylinder",
     xlim = c(5, 40),  ylim = c(0,10), col = 'lightblue',
     nclass = trunc(sqrt(length(mpg[cyl==4]))))
hist(mpg[cyl==6], xlab="MPG", main = "MPG dist by cylinder",
     xlim = c(5, 40),  ylim = c(0,10), col = 'orange',
     nclass = trunc(sqrt(length(mpg[cyl==6]))), add= TRUE)
hist(mpg[cyl==8], xlab="MPG", main = "MPG dist by cylinder",
     xlim = c(5, 40),  ylim = c(0,10), col = 'red',
     nclass = trunc(sqrt(length(mpg[cyl==8]))), add= TRUE)

# ----------------------------
par(mfrow = c(3,1))
hist(mpg[cyl==4], xlab="MPG", main = "MPG dist by cylinder",
     xlim = c(5, 40),  ylim = c(0,10), col = 'lightblue',
     nclass = trunc(sqrt(length(mpg[cyl==4]))))
hist(mpg[cyl==6], xlab="MPG", main = "MPG dist by cylinder",
     xlim = c(5, 40),  ylim = c(0,10), col = 'orange',
     nclass = trunc(sqrt(length(mpg[cyl==6]))))
hist(mpg[cyl==8], xlab="MPG", main = "MPG dist by cylinder",
     xlim = c(5, 40),  ylim = c(0,10), col = 'red',
     nclass = trunc(sqrt(length(mpg[cyl==8]))))

#높이를 백분율로 설정
hist(mpg[cyl==4], xlab="MPG", main = "MPG dist by cylinder",
     xlim = c(5, 40),  ylim = c(0,0.4), col = 'lightblue',
     nclass = trunc(sqrt(length(mpg[cyl==4]))), probability = T)
hist(mpg[cyl==6], xlab="MPG", main = "MPG dist by cylinder",
     xlim = c(5, 40),  ylim = c(0,0.4), col = 'orange',
     nclass = trunc(sqrt(length(mpg[cyl==6]))), probability = T)
hist(mpg[cyl==8], xlab="MPG", main = "MPG dist by cylinder",
     xlim = c(5, 40),  ylim = c(0,0.4), col = 'red',
     nclass = trunc(sqrt(length(mpg[cyl==8]))), probability = T)
mpg[cyl == 8]
# ----------------------------
plot(density(mpg[cyl==4]), xlab="MPG", main = "MPG dist by cylinder",
     xlim = c(5, 40), ylim = c(0.,0.26))
lines(density(mpg[cyl==6]), col = "red", lty = 2)
lines(density(mpg[cyl==8]), col = "blue", lty = 3)      
legend("topright", paste(c(4,6,8), "Cylinder"),
       col = c("black","red", "blue"),
       lty = c(1,2,3), lwd = 3, bty ="n")

# ----------------------------
tmp = c("buckled", "unbuckled")
belt <- matrix( c(58, 2, 8, 16), ncol = 2, 
                dimnames = list(parent = tmp, child = tmp))
belt

# ----------------------------
barplot( t(belt), main = "Stacked Bar chart for child seat-belt usage",
         xlab = "parent", ylab = "Frequency", legend.text = TRUE,
         col = c("green", "red"))

