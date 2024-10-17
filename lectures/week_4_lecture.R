# Homework 3 Review -----
#Load your survey data frame with the read.csv() function. 
surveys <- read.csv("data/portal_data_joined.csv")

#Create a new data frame called surveys_base with only the species_id, the weight, and the plot_type columns. 
surveys_base <- surveys[, c("species", "weight", "plot_type")]
#surveys_base <- select(surveys, species_id, weight, plot_type) #tidyverse version

#Have this data frame only be the first 5,000 rows. 
surveys_base <- surveys_base[1:5000,]
surveys_base2 <- surveys[1:5000, c("species", "weight", "plot_type")] #can combine lines of code

#Convert both species_id and plot_type to factors.
surveys_base$species <- factor(surveys_base$species)
surveys_base$plot_type <- factor(surveys_base$plot_type)

#Remove all rows where there is an NA in the weight column. 
surveys_base <- surveys_base[!is.na(surveys_base$weight),]
surveys_base[!is.na(surveys_base$weight)]

#Explore these variables and try to explain why a factor is different from a character. Why might we want to use factors? Can you think of any examples?

#CHALLENGE: Create a second data frame called challenge_base that only consists of individuals from your surveys_base data frame with weights greater than 150g.
challenge_base <- surveys_base[surveys_base$weight>150,]

#LECTURE NOTES
#learning dplyr and tidyr: select, filter, and pipes
#only do this once ever:
install.packages("tidyverse")
#We've learned bracket subsetting
#It can be hard to read and prone to error
#dplyr is great for data table manipulation!
#tidyr helps you switch between data formats
  
#Packages in R are collections of additional functions
#tidyverse is an "umbrella package" that
#includes several packages we'll use this quarter:
#tidyr, dplyr, ggplot2, tibble, etc.
  
#benefits of tidyverse
#1. Predictable results (base R functionality can vary by data type) 
#2. Good for new learners, because syntax is consistent. 
#3. Avoids hidden arguments and default settings of base R functions
  
#To load the package type:
library(tidyverse)
#now let's work with a survey dataset
surveys <- read_csv("data/portal_data_joined.csv")
  
str(surveys)
        
#select columns
month_day_year <- select(surveys, month, day, year)
          
#filtering by equals (subsets rows)
year_1981 <- filter(surveys, year==1981)
sum(year_1981$year!=1981, na.rm = T)
year_1981_baser <- surveys[surveys$year==1981,]
  
#filtering by range
the80s <- surveys[surveys$year %in% 1981:1983,]
the80s_tidy <- filter(surveys,year %in% 1981:1983)
nrow(the80s) #5033 results
                   
                   
#review: why should you NEVER do:
the80srecycle <- filter(surveys, year == c(1981:1983))
nrow(the80srecycle) #1685 results
                          
#This recycles the vector 
#(index-matching, not bucket-matching)
#If you ever really need to do that for some reason,
#comment it ~very~ clearly and explain why you're recycling!
                          
#filtering by multiple conditions
bigfoot_with_weight <- filter(surveys, hindfoot_length>40 & !is.na(weight))
                                                        
#multi-step process
small_animals <- filter(surveys, weight<5)

#this is slightly dangerous because you have to remember to select from small_animals, not surveys in the next step
small_animal_ids <- select(small_animals, record_id, plot_id, species_id)
                                                                                                           
#same process, using nested functions
small_animal_ids <- select(filter(surveys, weight<5), record_id, plot_id, species_id)
                                                                                                             
#same process, using a pipe
#Cmd Shift M
#or |>
#note our select function no longer explicitly calls the tibble as its first element
small_animal_ids <- surveys %>% filter(., weight < 5)
                                                                                                                 
#same as
small_animal_ids <- surveys %>% filter(weight<5) %>% select(record_id, plot_id, species_id)
                                                                                                                   
#how to do line breaks with pipes
surveys %>% filter(weight<5) %>% 
  select(record_id,plot_id,species_id)
                                                                                                                     
#good:
surveys %>% 
  filter(month==1)

surveys %>% filter(
  month==1
)

surveys %>% filter(
  weight<5
) %>% select(record_id,plot_id,species_id)
                                                                                                                     
#not good:
surveys 
%>% filter(month==1)
#what happened here? not splitting lines correctly, R read separately
                                                                                                                     
#line break rules: after open parenthesis, pipe, commas, or anything that shows the line is not complete yet
                                                                                                                     
                                                                                                                     
#one final review of an important concept we learned last week
#applied to the tidyverse
mini <- surveys[190:209,]
table(mini$species_id)
#how many rows have a species ID that's either DM or NL?
nrow(mini)

mini %>%  filter(species_id == "DM" | species_id == "NL") # I think this also works?
#don't do mini %>%  filter(species_id == c("DM", "NL"))
mini %>%  filter(species_id %in% c("DM","NL"))

# Data Manipulation Part 1b ----
# Goals: learn about mutate, group_by, and summarize
library(tidyverse)
surveys <- read_csv("data/portal_data_joined.csv")
str(surveys)


# Adding a new column
# mutate: adds a new column
surveys <- surveys %>%
  mutate(weight_kg = weight/1000)
str(surveys)

# Add other columns
surveys <- surveys %>%
  mutate(weight_kg = weight/1000, weight_kg2=weight_kg*2)
str(surveys)

# Filter out the NAs for specific row
average_weight <- surveys %>% filter(!is.na(weight)) %>% mutate(mean_weight=mean(weight))
str(surveys)

# Eliminates all rows with an NA in any variable
average_weight <- surveys %>% filter(complete.cases(.)) %>% mutate(mean_weight=mean(weight)) 

# Group_by and summarize ----
# A lot of data manipulation requires us to split the data into groups, apply some analysis to each group, and then combine the results
# group_by and summarize functions are often used together to do this
# group_by works for columns with categorical variables 
# we can calculate mean by certain groups
surveys %>%
  group_by(sex) %>%
  mutate(mean_weight = mean(weight, na.rm = TRUE)) 

surveys %>%
  group_by(sex) %>% 
  summarize(mean_weight = mean(weight, na.rm = T))


# multiple groups
surveys %>%
  group_by(sex, species_id) %>%
  summarize(mean_weight = mean(weight, na.rm = TRUE))
view(surveys)


# remove na's


# sort/arrange order a certain way
df <- surveys %>% group_by(sex, species_id) %>% 
  filter(sex != "") %>% 
  summarize(mean_weight = mean(weight, na.rm = TRUE)) %>% 
  arrange(-mean_weight)
df

# Challenge
#What was the weight of the heaviest animal measured in each year? Return a table with three columns: year, weight of the heaviest animal in grams, and weight in kilograms, arranged (arrange()) in descending order, from heaviest to lightest. (This table should have 26 rows, one for each year)
challenge <- surveys %>% 
  mutate(weight_kg = weight/1000) %>% 
  group_by(year) %>% 
  summarize(max_weight = max(weight, na.rm = TRUE), max_weight_kg = max(weight_kg, na.rm = TRUE)) %>% 
  arrange(-max_weight)
challenge

#Try out a new function, count(). Group the data by sex and pipe the grouped data into the count() function. How could you get the same result using group_by() and summarize()? Hint: see ?n.
surveys %>% group_by(sex) %>% count()
