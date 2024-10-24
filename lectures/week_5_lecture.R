# Conditional statements ---- 
## ifelse: run a test, if true do this, if false do this other thing
## case_when: basically multiple ifelse statements
# can be helpful to write "pseudo-code" first which basically is writing out what steps you want to take & then do the actual coding
# great way to classify and reclassify data

## Load library and data ----
library(tidyverse)
surveys <- read_csv("data/portal_data_joined.csv")

## ifelse() ----
# from base R
# ifelse(test, what to do if yes/true, what to do if no/false)
## if yes or no are too short, their elements are recycled
## missing values in test give missing values in the result
## ifelse() strips attributes: this is important when working with Dates and factors
surveys$hindfoot_cat <- ifelse(surveys$hindfoot_length < mean(surveys$hindfoot_length, na.rm = TRUE), yes = "small", no = "big")
head(surveys$hindfoot_cat)
head(surveys$hindfoot_length)
summary(surveys$hindfoot_length)
surveys$record_id
unique(surveys$hindfoot_cat)

## case_when() ----
# GREAT helpfile with examples!
# from tidyverse so have to use within mutate()
# useful if you have multiple tests
## each case evaluated sequentially & first match determines corresponding value in the output vector
## if no cases match then values go into the "else" category

# case_when() equivalent of what we wrote in the ifelse function
surveys %>%
  mutate(hindfoot_cat = case_when(
    hindfoot_length > 29.29 ~ "big", #hindfoot length greater than mean (29.29) is classified as big
    TRUE ~ "small"
  )) %>%
  select(hindfoot_length, hindfoot_cat) %>%
  head()

surveys %>% mutate(hindfoot_cat = case_when(
  hindfoot_length < 29.29 ~ "small",
  TRUE ~ "big"
))

# but there is one BIG difference - what is it?? (hint: NAs)
surveys %>% 
  mutate(hindfoot_cat = case_when(
    hindfoot_length > 31.5 ~ "big",
    hindfoot_length > 29 ~ "medium",
    is.na(hindfoot_length) ~ NA_character_,
    TRUE ~ "small"
  )) %>% select(hindfoot_length, hindfoot_cat) %>% head()
?NA

surveys %>% mutate(hindfoot_cat = case_when(
  hindfoot_length > 31.5 | hindfoot_length < 10 ~ "big",
  hindfoot_length > 29 ~ "medium",
  TRUE ~ "small"
)) %>% tail()

# if no "else" category specified, then the output will be NA


# lots of other ways to specify cases in case_when and ifelse
surveys %>%
  mutate(favorites = case_when(
    year < 1990 & hindfoot_length > 29.29 ~ "number1", 
    species_id %in% c("NL", "DM", "PF", "PE") ~ "number2",
    month == 4 ~ "number3",
    TRUE ~ "other"
  )) %>%
  group_by(favorites) %>%
  tally()

#MERGING
#inner_join: cases with match in dataset x and dataset y
#left_join(x, y): keeps everything in dataset x and all matches to dataset x in dataset y
#right_join(y, x): keeps everything in dataset y and all matches to dataset y in dataset x
#full_join: keeps everything in both datasets

#if you have columns in both datasets, then merging will be by both column names that are the same by default (unless you specify)
?full_join
?merge

library(tidyverse)
tail <- read_csv('data/tail_length.csv')
surveys <- read_csv('data/portal_data_joined.csv')
dim(tail)
dim(surveys)

surveys_test <- surveys %>% mutate(tail_length = mean(weight))
tail_test <- tail[sample(1:nrow(tail),15e3),]

surveys_inner <- inner_join(x = surveys, y = tail) #R assumes that record_id should be the merge variable because it is common
surveys_inner_test <- inner_join(x = surveys_test, y = tail) # this assumed that both record_id and tail_length should be the merge variables
surveys_inner <- inner_join(x = surveys, y = tail, by = "record_id")
surveys_left <- left_join(x = surveys, y = tail, by = "record_id")
surveys_right <- right_join(x = surveys, y = tail, by = "record_id")
surveys_full <- full_join(x = surveys, y = tail, by = "record_id")

surveys_inner2 <- inner_join(x = surveys, y = tail, by = "record_id")

left_join(surveys,tail %>% select(-record_id)) #if there is no column name in common, cannot merge

left_join(surveys,tail %>% rename(record_id2 = record_id),
          by = c('record_id'='record_id2')) # you can rename column names to be the same

#PIVOTS

surveys_mz <- surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(genus, plot_id) %>% 
  summarize(mean_weight = mean(weight))

surveys_mz

surveys_mz %>% pivot_wider(id_cols = 'genus', names_from = 'plot_id',values_from = 'mean_weight')
#id_cols = rows
#names_from = columns
#values_from = cells
