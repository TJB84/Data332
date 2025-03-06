install.packages("ggplot2")

library("ggplot2")

x3<-c(0,1,1,2,2,2,3,3,4)

qplot(x3, binwidth = 1)

rolls <- replicate(10000, roll()) 
qplot(rolls, binwidth = 1)

roll <- function() { 
  die <- 1:6 
  dice <- sample(die, size = 2, replace = TRUE, 
    prob = c(1/8, 1/8, 1/8, 1/8, 1/8, 3/8)) 
  sum(dice)
}
