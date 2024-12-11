#R-DAVIS Final Exam
#Hope Bodenschatz

#Load tidyverse packages
library(tidyverse)

#TASK 1
#Read in the file tyler_activity_laps_12-6.csv from the class github page. This file is at url https://raw.githubusercontent.com/UCD-R-DAVIS/R-DAVIS/refs/heads/main/data/tyler_activity_laps_12-6.csv, so you can code that url value as a string object in R and call read_csv() on that object. The file is a .csv file where each row is a “lap” from an activity Tyler tracked with his watch.

data <- "https://raw.githubusercontent.com/UCD-R-DAVIS/R-DAVIS/refs/heads/main/data/tyler_activity_laps_12-6.csv"
laps <- read_csv(data)

#look at the data
view(laps)

#TASK 2
#Filter out any non-running activities.
laps <- laps %>% filter(sport=="running")

#visually inspect data to make sure is accurate
view(laps)

#TASK 3
#We are interested in normal running. You can assume that any lap with a pace above 10 minutes_per_mile pace is walking, so remove those laps. 
laps <- laps %>% filter(minutes_per_mile<=10)

#check work
summary(laps$minutes_per_mile)

#You should also remove any abnormally fast laps (< 5 minute_per_mile pace) and abnormally short records where the total elapsed time is one minute or less.
laps <- laps %>% filter(minutes_per_mile > 5, total_elapsed_time_s>60)

#check work
summary(laps$minutes_per_mile)
summary(laps$total_elapsed_time_s)

#TASK 4
#Group observations into three time periods corresponding to pre-2024 running, Tyler’s initial rehab efforts from January to June of this year, and activities from July to the present.

laps <- laps %>% mutate(time_period = case_when(
  year < 2024 ~ "pre-2024",
  year == 2024 & month <=6 ~ "Jan-June 2024",
  year == 2024 & month >=7 ~ "July-present 2024",
  TRUE ~ "other"
))

#check work
laps %>% select(time_period, year, month) %>% filter(year<2024) %>% head()
laps %>% select(time_period, year, month) %>% filter(year == 2024 & month <=6) %>% head()
laps %>% select(time_period, year, month) %>% filter(year == 2024 & month >6) %>% head()

#TASK 5
#Make a scatter plot that graphs SPM over speed by lap.
#Calculate speed by lap
laps <- laps %>% mutate(speed = total_distance_m/total_elapsed_time_s)

#Create scatter plot
ggplot(laps, aes(x=speed, y=steps_per_minute)) + geom_point()

#TASK 6
#Make 5 aesthetic changes to the plot to improve the visual.
#Change 1: Set alpha = 0.2 to make points transparent
#Change 2: Change theme to classic
#Change 3: Improve the x and y title names and add a plot title
#Change 4: Change the color of the points to blue
#Change 5: Use geom_jitter to make the points overlap less
#Change 6: Move the title to the center of the plot and make it bold
ggplot(laps, aes(x=speed, y=steps_per_minute)) + 
  geom_jitter(color = "blue", alpha = 0.2) + 
  theme_classic() + 
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) +
  ggtitle("SPM over Speed by Lap") +
  ylab("Steps per minute") +
  xlab("Speed (m/s)")

#TASK 7
#Add linear (i.e., straight) trendlines to the plot to show the relationship between speed and SPM for each of the three time periods (hint: you might want to check out the options for geom_smooth())

?geom_smooth #It looks like the right option here is to specify "group" in the aes argument

ggplot(laps, aes(x=speed, y=steps_per_minute)) + 
  geom_jitter(color = "blue", alpha = 0.2) + 
  theme_classic() + 
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) +
  ggtitle("SPM over Speed by Lap") +
  ylab("Steps per minute") +
  xlab("Speed (m/s)") +
  geom_smooth(aes(group = time_period, color = time_period), method = "lm")

#TASK 8
#Does this relationship maintain or break down as Tyler gets tired? Focus just on post-intervention runs (after July 1, 2024).
laps_post <- laps %>% filter(time_period == "July-present 2024")

#Make a plot (of your choosing) that shows SPM vs. speed by lap. 
ggplot(laps_post, aes(x=speed, y=steps_per_minute)) + 
  geom_jitter(color = "blue") + 
  theme_classic() + 
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) +
  ggtitle("SPM over Speed by Lap (July-December 2024)") +
  ylab("Steps per minute") +
  xlab("Speed (m/s)")

#Use the timestamp indicator to assign lap numbers, assuming that all laps on a given day correspond to the same run (hint: check out the rank() function). 

#Check that timestamp is already in a date format
class(laps_post$timestamp) #POSIXct, POSIXt

?rank()

#Add a new column that assigns lap numbers: group by month, day, year then rank timestamp.
laps_post <- laps_post %>% group_by(month, day, year) %>% mutate(lap_number = rank(timestamp))

#check that lap number variable is correct
laps_post %>% select(timestamp, lap_number) %>% head(n=15)

#Select only laps 1-3 (Tyler never runs more than three miles these days). 
laps_post <- laps_post %>% filter(lap_number <=3)

#check work
summary(laps_post$lap_number)

#Make a plot that shows SPM, speed, and lap number (pick a visualization that you think best shows these three variables).

#make lap number categorical (R is reading as continuous)
laps_post <- laps_post %>% mutate(lap_num_cat = case_when(
  lap_number == 1 ~ "Lap 1",
  lap_number == 2 ~ "Lap 2",
  lap_number == 3 ~ "Lap 3",
  TRUE ~ "other"
))

#Create plot
ggplot(laps_post, aes(x=speed, y=steps_per_minute)) + 
  geom_jitter() + 
  theme_classic() + 
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) +
  ggtitle("SPM over Speed by Lap Number (July-December 2024)") +
  ylab("Steps per minute") +
  xlab("Speed (m/s)") +
  geom_smooth(aes(group = lap_num_cat), method = "lm") +
  facet_wrap(~lap_num_cat)

#It looks like the positive relationship between speed and SPM gets stronger in lap 3 than in lap 1 - the straight-line relationship in lap 3 is more vertical than in lap 1, indicating a higher positive correlation.
