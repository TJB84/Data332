library(ggplot2)
library(dplyr)
library(tidyverse)
library(readxl)
library(tidyr)

rm(list = ls())

setwd("C:/R/documents/r_projects/trucking")


df_truck <- read_excel('NP_EX_1-2.xlsx', sheet = 2, skip = 3, .name_repair = 'universal')

df <- df_truck[, c(4:15)]

df = subset(df, select = - c(...10) )

date1 <- min(df$Date)
date2 <- max(df$Date)

number_days_on_road <- date2 - date1
print(number_days_on_road)

total_hours <- sum(df$Hours)

trip_cost <- df$Gallons * df$Price.per.Gallon

total_fuel_expenses <- sum(trip_cost)

total_toll_expenses <- sum(df$Tolls)

total_misc_expenses <- sum(df$Misc)

total_exspenses <- total_fuel_expenses + total_toll_expenses + total_misc_expenses

other_exspenses <- total_toll_expenses + total_misc_expenses

total_gallons_consumed <- sum(df$Gallons)

trip_miles <- df$Odometer.Ending - df$Odometer.Beginning

total_miles_driven <- sum(trip_miles)

miles_per_gallon <- total_miles_driven / total_gallons_consumed

total_cost_per_mile <- total_exspenses / total_miles_driven

df[c('warehouse' , 'starting_city_state')] <- str_split_fixed(df$Starting.Location, ',', 2)

df$starting_city_state <- gsub(',', "", df$starting_city_state)

df[c('col1', 'col2')] <-
  str_split_fixed(df$starting_city_state, ' ', 2)

df[c('col1', 'col2', 'col3')] <-
  str_split_fixed(df$col2, ' ', 3)

simplify_city_state <-function(df) { 
  df$Starting_city <- ifelse(df$col3 != "",
                             paste0(df$col1, df$col2, sep = " "),
                             df$col1)
  df$starting_state <- ifelse(df$col3 != "",
                              df$col3,
                              df$col2)
  return(dif)
  }

df_starting_Pivot <- df %>%
  group_by(starting_city_state) %>%
  summarise(count = n(),
    mean_size_hours = mean(Hours, na.rm = TRUE),
    sd_hours = sd(Hours, na.rm = TRUE),
    total_hours = sum(Hours, na.rm = TRUE),
    total_gallons_consumed = sum(Gallons, na.rm = TRUE)
  )

ggplot(df_starting_Pivot, aes(x = starting_city_state, y = count)) + 
  geom_col() + 
  theme (axis.text = element_text(angle = 45, vjust = .5, hjust = 1))
  
df_truck_0001 <- read_excel('truck data 0001.xlsx', sheet = 2, skip = 3, .name_repair = 'universal')
df_truck_0369 <- read_excel('truck data 0369.xlsx', sheet = 2, skip = 3, .name_repair = 'universal')
df_truck_1226 <- read_excel('truck data 1226.xlsx', sheet = 2, skip = 3, .name_repair = 'universal')
df_truck_1442 <- read_excel('truck data 1442.xlsx', sheet = 2, skip = 3, .name_repair = 'universal')
df_truck_1478 <- read_excel('truck data 1478.xlsx', sheet = 2, skip = 3, .name_repair = 'universal')
df_truck_1539 <- read_excel('truck data 1539.xlsx', sheet = 2, skip = 3, .name_repair = 'universal')
df_truck_1769 <- read_excel('truck data 1769.xlsx', sheet = 2, skip = 3, .name_repair = 'universal')
df_pay <- read_excel('Driver Pay Sheet.xlsx', .name_repair = 'universal')

df <- rbind(df_truck_0001, df_truck_0369, 
            df_truck_1226, df_truck_1442, 
            df_truck_1478, df_truck_1539, 
            df_truck_1769)

df_starting_pivot <- df %>% 
  group_by(Truck.ID) %>%
  summarise(couny = n())

df <- left_join(df, df_pay, by = ('Truck.ID'))