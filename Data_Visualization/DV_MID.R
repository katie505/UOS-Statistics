rm(list = ls())
setwd('C:/Users/daess/Desktop/midterm')

#1-(1)
#291번 데이터는 비어있기 때문에 제외
file_list <- list.files('./prob_1')
data <- data.frame()

for(file in file_list){
  temp <- read.csv(paste('./prob_1', file, sep = '/'), header = TRUE, stringsAsFactors = FALSE)
  data <- rbind(data, temp)
}

view(data)
name <- data[,1]
data <- data.frame(data, row.names = name)
data <- data[, -1]
prob_1 <- t(data)


#1-(2)
sum <- apply(prob_1, 1, sum)
head(sum, 10)
tail(sum, 10)


#2
if(!require(dplyr)){install.packages(dplyr); library(dplyr)}
if(!require(ggplot2)){install.packages(ggplot2); library(ggplot2)}

A <- read.csv('./prob_2/A.csv', header = TRUE, stringsAsFactors = FALSE)
sum(is.na(A))
A <- A %>% arrange(year, month, day)
date <- paste(A$year, A$month, A$day)
A <- data.frame(date, A$return)
A %>% ggplot(aes(x = date, y = A.return)) + 
  geom_line(color = 'deepskyblue', aes(group=1)) +
  theme_bw() +
  theme(axis.text.x = element_blank()) +
  theme(axis.ticks.x = element_blank()) +
  labs(title = '시간에 따른 수익률의 변화', x = '시간', y = '수익률')


#3
circle1 <- function(x){
  percent = round(prop.table(x)*100,2)
  name = paste0(percent, '%')
  level = levels(x)
  pie(x, labels = level, col = rainbow(length(level)))
  legend('topright', paste(level,'\t',name), fill = rainbow(length(level)))
}

x <- c(24, 15, 7)
circle1(x)

circle2 <- function(x){
  percent = round(prop.table(x)*100,2)
  name = paste0(percent, '%')
  level = levels(x)
  pie(x, labels = level, col = rainbow(length(x)))
  legend('topright', paste(c(1,2,3),'\t',name), fill = rainbow(length(x)))
}
circle2(x)

par(mfrow = c(1,2))
circle1(x)
circle2(x)
#4
prob_4 <- read.csv('./prob_4/full_grouped.csv', header = TRUE, stringsAsFactors = FALSE)
sum(is.na(prob_4))
prob_4$month <- substr(prob_4$Date, 6,7)
skprt <- prob_4 %>% filter(Country.Region %in% c('Portugal', 'South Korea')) %>% 
  group_by(month, Country.Region) %>% summarise(total = sum(Confirmed))
skprt

ggplot(skprt, aes(x = month, y = total, group = Country.Region, color = Country.Region)) +
  geom_line() + labs(title = 'Portugal vs South Korea', x = '월', y = '확진자 수') + 
  theme_bw()


#5
setwd('C:/Users/daess/desktop/mid5')

set.seed(1234)
N <- c(10, 50, seq(100, 10000, 500))

for (i in N){
  x = rnorm(i, mean = 0, sd = 1)
  bin = round(sqrt(i))
  name = paste0(i, '.png')
  png(filename = name)
  hist(x, breaks = seq(min(x), max(x), length = bin),
                       probability = T, xlim = c(-4, 4), ylim = c(0, 0.5))
  y = seq(-4, 4, length = 1000)
  lines(y, dnorm(y, mean = 0, sd = 1))
  dev.off()
}

library(magick)
library(dplyr)
dir <- './'
imgs <- list.files(dir)
list <- data.frame()
for(i in 1:length(imgs)){
  n <- gsub('\\D', '', imgs[i])
  list[i,1:2] <- c(imgs[i], n)
}
list$V2 <- as.numeric(list$V2)
list <- list %>% arrange(V2)
imgs <- list[,1]

img_list <- lapply(imgs, image_read)
img_joined <- image_join(img_list)

img_animated <- image_animate(img_joined, fps = 2)

img_animated

image_write(image = img_animated,
            path = "C:/Users/daess/desktop/histogram.gif")
