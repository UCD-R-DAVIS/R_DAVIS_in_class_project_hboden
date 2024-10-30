#Midterm
#Hope Bodenschatz

library(tidyverse)

#QUESTION 1
#Read in the file tyler_activity_laps_10-24.csv from the class github page. This file is at url https://raw.githubusercontent.com/ucd-cepb/R-DAVIS/refs/heads/main/data/tyler_activity_laps_10-24.csv, so you can code that url value as a string object in R and call read_csv() on that object.
file <- "https://raw.githubusercontent.com/ucd-cepb/R-DAVIS/refs/heads/main/data/tyler_activity_laps_10-24.csv"
str(file)

laps <- read_csv(file)
view(laps)

#QUESTION 2
#Filter out any non-running activities.
laps <- laps %>% filter(sport=="running")

#QUESTION 3
#You can assume that any lap with a pace above 10 minute-per-mile pace is walking, so remove those laps. You should also remove any abnormally fast laps (< 5 minute-per-mile pace) and abnormally short records where the total elapsed time is one minute or less.
laps <- laps %>% filter(minutes_per_mile <= 10 & minutes_per_mile >= 5)
summary(laps$minutes_per_mile) #check

laps <- laps %>% mutate(total_elapsed_time_m = total_elapsed_time_s/60) %>% filter(total_elapsed_time_m > 1)
summary(laps$total_elapsed_time_m) #check

#QUESTION 4
#Create a new categorical variable, pace, that categorizes laps by pace: “fast” (< 6 minutes-per-mile), “medium” (6:00 to 8:00), and “slow” ( > 8:00). 
laps <- laps %>% mutate(pace = case_when(
  minutes_per_mile < 6 ~ "fast",
  minutes_per_mile >=6 & minutes_per_mile <=8 ~ "medium",
  is.na(minutes_per_mile) ~ NA_character_,
  TRUE ~ "slow"
))

#check
laps %>% select(minutes_per_mile, pace) %>% filter(minutes_per_mile<6) %>% head()
laps %>% select(minutes_per_mile, pace) %>% filter(minutes_per_mile>=6 & minutes_per_mile<=8) %>% head()
laps %>% select(minutes_per_mile, pace) %>% filter(minutes_per_mile>8) %>% head()

#Create a second categorical variable, form, that distinguishes between laps run in the year 2024 (“new”, as Tyler started his rehab in January 2024) and all prior years (“old”).
laps <- laps %>% mutate(form = case_when(
  year == 2024 ~ "new",
  is.na(year) ~ NA_character_,
  TRUE ~ "old"
))

#check
laps %>% select(year, form) %>% filter(year==2024) %>% head()
laps %>% select(year, form) %>% filter(year!=2024) %>% head()

#QUESTION 5
#Identify the average steps per minute for laps by form and pace, and generate a table showing these values with old and new as separate rows and pace categories as columns. 
table <- laps %>% group_by(pace, form) %>% summarize(mean_steps_per_m = mean(steps_per_minute))
table <- table %>% pivot_wider(id_cols = 'form', names_from = 'pace',values_from = 'mean_steps_per_m')
table

#Make sure that slow speed is the second column, medium speed is the third column, and fast speed is the fourth column (hint: think about what the select() function does).
table <- table %>% select(form, slow, medium, fast)
table

#QUESTION 6
#Summarize the minimum, mean, median, and maximum steps per minute results for all laps (regardless of pace category) run between January - June 2024 and July - October 2024 for comparison.
laps <- laps %>% mutate(time_period = case_when(
  year == 2024 & month>=1 & month<=6 ~ "jan_june_2024",
  year == 2024 & month>=7 & month<=10 ~ "july_oct_2024",
  is.na(year) ~ NA_character_,
  TRUE ~ "other"
))

#check
laps %>% select(time_period, year, month) %>% filter(year==2024 & month>=1 & month<=6) %>% tail()
laps %>% select(time_period, year, month) %>% filter(year==2024 & month>=7 & month<=10) %>% tail()

#Create table
laps %>% group_by(time_period) %>% filter(time_period=="jan_june_2024" | time_period=="july_oct_2024") %>% summarize(min_steps = min(steps_per_minute), mean_steps = mean(steps_per_minute), median_steps = median(steps_per_minute), max_steps = max(steps_per_minute)) %>% select(time_period, min_steps, mean_steps, median_steps, max_steps) 
