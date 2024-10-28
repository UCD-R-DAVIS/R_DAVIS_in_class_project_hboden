#Week 5 homework
#Hope Bodenschatz

library(tidyverse)

#Create a tibble named surveys from the portal_data_joined.csv file. 
surveys <- read_csv("data/portal_data_joined.csv")
view(surveys)

#Then manipulate surveys to create a new dataframe called surveys_wide with a column for genus and a column named after every plot type, with each of these columns containing the mean hindfoot length of animals in that plot type and genus. So every row has a genus and then a mean hindfoot length value for every plot type. The dataframe should be sorted by values in the Control plot type column.
surveys_wide <- surveys %>% filter(!is.na(hindfoot_length)) %>% 
  group_by(genus, plot_type) %>% 
  summarize(mean_hindfoot_length = mean(hindfoot_length)) %>% 
  pivot_wider(id_cols = 'genus', names_from = 'plot_type',values_from = 'mean_hindfoot_length') %>% 
  arrange(Control)
surveys_wide

#testing (can ignore)
surveys %>% filter(!is.na(hindfoot_length), plot_type=="Control") %>% group_by(genus, plot_type) %>% summarize(hindfoot_length)

#Using the original surveys dataframe, use the two different functions we laid out for conditional statements, ifelse() and case_when(), to calculate a new weight category variable called weight_cat. For this variable, define the rodent weight into three categories, where “small” is less than or equal to the 1st quartile of weight distribution, “medium” is between (but not inclusive) the 1st and 3rd quartile, and “large” is any weight greater than or equal to the 3rd quartile. (Hint: the summary() function on a column summarizes the distribution). 
summary(surveys$weight)

#ifelse version
surveys$weight_cat <- ifelse(surveys$weight <= 20, yes = "small", no = ifelse(surveys$weight >20 & surveys$weight<48, yes = "medium", no = "large"))

#check
surveys %>% select(weight, weight_cat) %>% filter(weight>20 & weight<48)
surveys %>% select(weight, weight_cat) %>% filter(weight<=20)
surveys %>% select(weight, weight_cat) %>% filter(weight>=48)
surveys %>% select(weight, weight_cat) %>% filter(!is.na(weight))

#case_when version (without specifying NA)
surveys <- surveys %>%
  mutate(weight_cat2 = case_when(
    weight <= 20 ~ "small",
    weight > 20 & weight < 48 ~ "medium",
    TRUE ~ "large"
  ))
  
#check
surveys %>% select(weight, weight_cat2) %>% filter(weight>20 & weight<48)
surveys %>% select(weight, weight_cat2) %>% filter(weight<=20)
surveys %>% select(weight, weight_cat2) %>% filter(weight>=48)
surveys %>% select(weight, weight_cat2) %>% filter(is.na(weight))

#case_when version (with specifying NA)
surveys <- surveys %>%
  mutate(weight_cat3 = case_when(
    weight <= 20 ~ "small",
    weight > 20 & weight < 48 ~ "medium",
    is.na(weight) ~ NA_character_,
    TRUE ~ "large"
  ))

#check
surveys %>% select(weight, weight_cat3) %>% filter(weight>20 & weight<48)
surveys %>% select(weight, weight_cat3) %>% filter(weight<=20)
surveys %>% select(weight, weight_cat3) %>% filter(weight>=48)
surveys %>% select(weight, weight_cat3) %>% filter(is.na(weight))

#For ifelse() and case_when(), compare what happens to the weight values of NA, depending on how you specify your arguments.

#For ifelse(), NA is classified as NA regardless of how you specify your arguments. For case_when(), NA is classified in the "catch all" category, unless you specifically set it to be NA.

#BONUS: How might you soft code the values (i.e. not type them in manually) of the 1st and 3rd quartile into your conditional statements in question 2?

#ifelse version
surveys$weight_cat_soft <- ifelse(surveys$weight <= quantile(surveys$weight,0.25, na.rm=TRUE), yes = "small", no = ifelse(surveys$weight >quantile(surveys$weight,0.25, na.rm=TRUE) & surveys$weight<quantile(surveys$weight,0.75, na.rm=TRUE), yes = "medium", no = "large"))

#check
surveys %>% select(weight, weight_cat_soft) %>% filter(weight>20 & weight<48)
surveys %>% select(weight, weight_cat_soft) %>% filter(weight<=20)
surveys %>% select(weight, weight_cat_soft) %>% filter(weight>=48)
surveys %>% select(weight, weight_cat_soft) %>% filter(is.na(weight))

#case_when version (with specifying NA)
surveys <- surveys %>%
  mutate(weight_cat_soft2 = case_when(
    weight <= quantile(surveys$weight,0.25, na.rm=TRUE) ~ "small",
    weight > quantile(surveys$weight,0.25, na.rm=TRUE) & weight < quantile(surveys$weight,0.75, na.rm=TRUE) ~ "medium",
    is.na(weight) ~ NA_character_,
    TRUE ~ "large"
  ))

#check
surveys %>% select(weight, weight_cat_soft2) %>% filter(weight>20 & weight<48)
surveys %>% select(weight, weight_cat_soft2) %>% filter(weight<=20)
surveys %>% select(weight, weight_cat_soft2) %>% filter(weight>=48)
surveys %>% select(weight, weight_cat_soft2) %>% filter(is.na(weight))

