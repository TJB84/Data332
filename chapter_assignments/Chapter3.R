#the first one is a number the second 2 are strings

hand <- c("ace", "king", "queen", "jack", "ten")
hand

hand1 <- c("ace", "king", "queen", "jack", "ten", "spades", "spades", "spades", "spades", "spades")
matrix(hand1, nrow = 5)
matrix(hand1, ncol = 2) 
dim(hand1) <- c(5, 2)

card <- c("ace", "hearts", 1)
card

card <- list("ace", "hearts", 1)
card