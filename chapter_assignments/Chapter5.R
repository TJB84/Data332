deck2$new <- 1:52

head(deck2

deck2$new <- NULL

deck2[c(13, 26, 39, 52), ]

deck2[c(13, 26, 39, 52), 3]

deck2$value[c(13, 26, 39, 52)]

deck2$value[c(13, 26, 39, 52)] <- c(14, 14, 14, 14)

deck2$value[c(13, 26, 39, 52)] <- 14

head(deck2, 13)

deck3 <- shuffle(deck)

deck2$face

deck2$face == "ace"

sum(deck2$face == "ace")

deck3$face == "ace"

deck3$value[deck3$face == "ace"]

deck3$value[deck3$face == "ace"] <- 14

deck4 <- deck deck4$value <- 0

head(deck4, 13)

deck4$suit == "hearts"

deck4$value[deck4$suit == "hearts"]

deck4$value[deck4$suit == "hearts"] <- 1

deck4$value[deck4$suit == "hearts"]

deck4[deck4$face == "queen", ]

deck4[deck4$suit == "spades", ]

deck4$face == "queen" & deck4$suit == "spades"

queenOfSpades <- deck4$face == "queen" & deck4$suit == "spades"

deck4[queenOfSpades, ]

deck4$value[queenOfSpades]

deck4$value[queenOfSpades] <- 13

deck4[queenOfSpades, ]

w>0 10<x&x<20 y == "February" all(z %in% c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday",
                                           "Saturday", "Sunday"))
deck5 <- deck

head(deck5, 13)

facecard <- deck5$face %in% c("king", "queen", "jack")

deck5[facecard, ]

deck5$value[facecard] <- 10

head(deck5, 13)

