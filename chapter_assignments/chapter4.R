library(dplyr)
library(tidytext)
library(janeaustenr)
library(ggplot2)
library(stringr)
library(tidyverse)
library(readxl)
library(tidyr)
library(wordcloud)
library(reshape2)
library(gutenbergr)

rm(list = ls())

deal <- function(cards) { cards[1, ]
}

shuffle <- function(cards) { random <- sample(1:52, size = 52) cards[random, ]
}
