#Week 4 homework
#Hope Bodenschatz

library(tidyverse)

#Create a tibble named surveys from the portal_data_joined.csv file.
surveys <- read_csv("data/portal_data_joined.csv")
class(surveys)
surveys

#Subset surveys using Tidyverse methods to keep rows with weight between 30 and 60, and print out the first 6 rows.
weight_30_60 <- surveys %>% filter(weight > 30 & weight < 60)
head(weight_30_60)

#Create a new tibble showing the maximum weight for each species + sex combination and name it biggest_critters. 
biggest_critters <- surveys %>%
  group_by(species, sex) %>%
  filter(!is.na(weight)) %>% 
  summarize(max_weight = max(weight, na.rm = TRUE))
biggest_critters

#Sort the tibble to take a look at the biggest and smallest species + sex combinations. 
#HINT: it’s easier to calculate max if there are no NAs in the dataframe…
biggest_critters %>% arrange(max_weight) #smallest
biggest_critters %>% arrange(-max_weight) #biggest

#Try to figure out where the NA weights are concentrated in the data
#is there a particular species, taxa, plot, or whatever, where there are lots of NA values? 
#There isn’t necessarily a right or wrong answer here, but manipulate surveys a few different ways to explore this. 
#Maybe use tally and arrange here.

surveys %>% filter(is.na(weight)) %>% group_by(species) %>% tally() %>% arrange(-n) 
#the species harrisi, merriami, bilineata, and spilosoma have the most NA weights

surveys %>% filter(is.na(weight)) %>% group_by(taxa) %>% tally() %>% arrange(-n)
#the taxa rodent has the most NA weights

surveys %>% filter(is.na(weight)) %>% group_by(plot_type) %>% tally() %>% arrange(-n)
#the plot_type control has the most NA weights

#Take surveys, remove the rows where weight is NA and add a column that contains the average weight of 
#each species+sex combination to the full surveys dataframe. 
surveys <- surveys %>% filter(!is.na(weight)) %>% 
  group_by(species, sex) %>%
  mutate(mean_weight = mean(weight)) 
surveys
tail(surveys)

#Then get rid of all the columns except for species, sex, weight, and your new average weight column. 
#Save this tibble as surveys_avg_weight.
surveys_avg_weight <- surveys %>% select(species, sex, weight, mean_weight)
surveys_avg_weight

#Take surveys_avg_weight and add a new column called above_average that contains logical values stating whether or 
#not a row’s weight is above average for its species+sex combination (recall the new column we made for this tibble).
surveys_avg_weight <- surveys_avg_weight %>% mutate(above_average = weight>mean_weight)
tail(surveys_avg_weight)
