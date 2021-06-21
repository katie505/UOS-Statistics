if(!require(reshape2)){install.packages('reshape2'); library(reshape2)}

#1
ff <- french_fries
str(ff)

#2
ff2 <- na.omit(ff)
mean1 <- aggregate(potato ~ subject, ff2, mean)
mean1
boxplot(ff2$potato ~ ff2$subject, main = 'boxplot', col = 'lightblue')

#3
apply(ff2[,5:9], 2, mean)

#4
par(mfrow = c(3,1))
attach(ff2)
x1 <- painty[treatment == 1]
x2 <- painty[treatment == 2]
x3 <- painty[treatment == 3]

hist(x1, xlab = 'painty', main = 'painty dist by treatment1',
     xlim = c(0, 14), col = 'light coral', breaks = seq(min(x1), max(x1), length = 7))
hist(x2, xlab = 'painty', main = 'painty dist by treatment2',
     xlim = c(0, 14), col = 'pale green', breaks = seq(min(x2), max(x2), length = 7))

hist(x3, xlab = 'painty', main = 'painty dist by treatment3',
     xlim = c(0, 14), col = 'light cyan', breaks = seq(min(x3), max(x3), length = 7))

#5
library(dplyr)

ff2 %>% group_by(subject) %>% summarise(total = n())

df <- ff2 %>% group_by(subject) %>% summarise(total = n()) %>% arrange(desc(total)) %>% head(6)
x <- unlist(df[1], use.name = F)

df2 <- subset(ff2, treatment == 1 & subject %in% x)

boxplot(grassy ~ time, data = df2, xlab = 'Time', ylab = 'grassy', col = 'lightblue')



