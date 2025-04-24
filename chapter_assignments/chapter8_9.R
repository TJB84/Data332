play <- function() { 
  symbols <- get_symbols() 
  prize <- score(symbols) 
  attr(prize, "symbols") <- symbols prize
}

print.slots <- function(x, ...) { slot_display(x)
}

play <- function() { symbols <- get_symbols() structure(score(symbols), symbols = symbols, class = "slots")
}

combos <- expand.grid(wheel, wheel, wheel, stringsAsFactors = FALSE)

prob <- c("DD" = 0.03, "7" = 0.03, "BBB" = 0.06, "BB" = 0.1, "B" = 0.25, "C" = 0.01, "0" = 0.52)

combos$prob1 <- prob[combos$Var1] combos$prob2 <- prob[combos$Var2] combos$prob3 <- prob[combos$Var3]

combos$prob <- combos$prob1 * combos$prob2 * combos$prob3
head(combos, 3)

for (i in 1:nrow(combos)) { symbols <- c(combos[i, 1], combos[i, 2], combos[i, 3]) combos$prize[i] <- score(symbols)
}

score <- function(symbols) { diamonds <- sum(symbols == "DD")
Challenge
There are many ways to modify score that would count DDs as wild. If you would like to test your skill as an R programmer, try to write your own version of score that correctly handles diamonds.
If you would like a more modest challenge, study the following score code. It accounts for wild diamonds in a way that I find elegant and succinct. See if you can understand each step in the code and how it achieves its result.
cherries <- sum(symbols == "C")

bars <- slots %in%

  if (diamonds == 3) prize <- 100
} else if (same) { payouts <- c("7"
                                c("B", "BB", "BBB")
                                {
                                  = 80, "BBB" = 40, "BB" = 25, "B"=10,"C"=10,"0"=0)
prize <- unname(payouts[slots[1]]) } else if (all(bars)) {
  prize <- 5 } else if (cherries > 0) {
  }else{ prize <- 0
  }

    prize * 2^diamonds
}

for (i in 1:nrow(combos)) { symbols <- c(combos[i, 1], combos[i, 2], combos[i, 3]) combos$prize[i] <- score(symbols)
}
