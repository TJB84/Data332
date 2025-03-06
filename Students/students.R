library(ggplot2)
library(dplyr)
library(tidyverse)
library(readxl)
library(tidyr)

rm(list = ls())

setwd("C:/R/documents/r_projects/students")


students <- read_excel('Student.xlsx', .name_repair = 'universal')
course <- read_excel('Course.xlsx', .name_repair = 'universal')
registration <- read_excel('Registration.xlsx', .name_repair = 'universal')

student_registration <- left_join(students, registration, by = 'Student.ID')
course_registration <- left_join(course, registration, by = 'Instance.ID')

class_registration <- left_join(student_registration, course_registration, by = 'Student.ID')

major_count <- class_registration %>%
  group_by(Title) %>%
  summarise(count = n())
            
ggplot(major_count, aes(x = Title, y = count)) + 
  geom_col() + 
  theme (axis.text = element_text(angle = 45, vjust = .5, hjust = 1))


class_registration[c('birth_year', 'birth_month', 'birth_day' )] <- 
    str_split_fixed(class_registration$Birth.Date, '-', 3)

birth_year_count <- class_registration %>%
  group_by(birth_year) %>%
  summarise(count = n())

ggplot(birth_year_count, aes(x = birth_year, y = count)) + 
  geom_col() + 
  theme (axis.text = element_text(angle = 90, vjust = .5, hjust = 1))


major_age_count <- data.frame(birth_year_count, 'Title')

ggplot(major_age_count, aes(fill= birth_year_count, y='Title', x='birth_year')) + 
  geom_bar(position="stack", stat="identity")



payment_plan_summary <- course_registration %>%
  group_by(Title, Payment.Plan) %>%
  summarise(sum_total=sum(Total.Cost))

payment_plan_cost <- data.frame(payment_plan_summary)

ggplot(payment_plan_cost, aes(fill=Payment.Plan, y=sum_total, x=Title)) + 
  geom_bar(position="stack", stat="Identity") +
  theme (axis.text = element_text(angle = 90, vjust = .5, hjust = 1))


payment_due_summary <- course_registration %>%
  group_by(Title, Payment.Plan) %>%
  summarise(sum_due_total=sum(Balance.Due))

payment_due_cost <- data.frame(payment_due_summary)

ggplot(payment_due_cost, aes(fill=Payment.Plan, y=sum_due_total, x=Title)) + 
  geom_bar(position="stack", stat="Identity") +
  theme (axis.text = element_text(angle = 90, vjust = .5, hjust = 1))



