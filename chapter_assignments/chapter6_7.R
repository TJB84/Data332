#Yes

deal <- function() { card <- deck[1, ] assign("deck", deck[-1, ], envir = globalenv()) card}

shuffle <- function(){random <- sample(1:52, size = 52) assign("deck", DECk[random, ], envir = globalenv())}

#QUIZ1 = 2

#QUIZ2 = 2

#QUIZ3 = 2

all(symbols == symbols[1])

same <- symbols[1] == symbols[2] && symbols[2] == symbols[3] bars <- symbols %in% c("B", "BB", "BBB")
if (same) { payouts <- c("DD" = 100, "7" = 80, "BBB" = 40, "BB" = 25,
                         "B"=10,"C"=10,"0"=0) prize <- unname(payouts[symbols[1]])
} else if (all(bars)) { prize <- 5
}else{ cherries <- sum(symbols == "C") prize <- c(0, 2, 5)[cherries + 1]
} diamonds <- sum(symbols == "DD")
prize * 2 ^ diamonds