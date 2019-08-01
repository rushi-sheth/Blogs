
set.seed(123)
student_town = data.frame(week=1:10,trees = as.integer(rnorm(10,mean = 145, sd = 5)))
student_town

shapiro.test(student_town)

library("ggplot2")
library(repr)

options(repr.plot.width=2, repr.plot.height=2)
qplot(sample=student_town)+stat_qq_line()

t.test(student_town$trees,mu=150,alternative="less")

set.seed(123)
pooled = data.frame(week=1:10,Concrete_jungle = as.integer(rnorm(10,145,sd=5)),Nature_lovers=as.integer(rnorm(10,155,sd=6)))
pooled

shapiro.test(pooled$Concrete_jungle)
shapiro.test(pooled$Nature_lovers)

t.test(pooled$Concrete_jungle,pooled$Nature_lovers,var.equal = TRUE)

t.test(pooled$Concrete_jungle,pooled$Nature_lovers,var.equal = TRUE,alternative = 'less')

set.seed(123)
paired = data.frame(state = 1:10,trees_planted_before =as.integer(rnorm(10,145,sd=5)),trees_planted_after =as.integer(rnorm(10,149,sd=5)))
paired                    

shapiro.test(paired$trees_planted_before)
shapiro.test(paired$trees_planted_after)

t.test(paired$trees_planted_before,paired$trees_planted_after,paired = TRUE,alternative = 'less')

packet = data.frame(Item = c('Baked','Fried','Almonds'),Weight = c(28,35,37))
packet

chisq.test(packet$Weight,p=c(1/3,1/3,1/3))

shift_data = data.frame(Shift= c("Morning","evening","night"),Baked = c(33,35,32),Fried=c(33,43,30),Almond=c(33,29,44),row.names = 1)
shift_data

test = chisq.test(shift_data)
test

test$observed

round(test$expected,2)
test
