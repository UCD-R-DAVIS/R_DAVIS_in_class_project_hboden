# Iteration ---------------------------------------------------------------

# Learning Objectives: 
## Understand when and why to iterate code
## Be able to start with a single use and build up to iteration
## Use for loops, apply functions, and purrr to iterate
## Be able to write functions to cleanly iterate code

# Data for class 
head(iris)
head(mtcars)
gapminder <- read_csv("https://ucd-r-davis.github.io/R-DAVIS/data/gapminder.csv")

# Packages
library(tidyverse)


# Subsetting refresher
## column of data
head(iris[1]) # first column
head(iris %>% select(Sepal.Length))

## vector of data
iris[[1]] # first column in a vector
iris[,1]
head(iris$Sepal.Length)

## specific values
iris[1,1]
iris$Sepal.Length[1]


# For Loops ---------------------------------------------------------------

### Comparison of Function & Iteraction Syntax ------
test <- function(i){
  print(i)
}
test(1)

#iteration
for(i in 1:10){
  print(i)
}

## Vector example -----
## 1. What do I want my output to be?
# we want an empty vector to fill up with values from our function
results <- rep(NA, nrow(mtcars)) # can run nrow() to see what to expect
results 

## 2. What is the task I want my for loop to do?
mtcars$wt*100

## 3. What values do I want to loop through the task?
for(i in 1:nrow(mtcars)){ # we want to do this for every row in cars data, we could hard code but more robust to soft code
  results[i] <- mtcars$wt[i]*100
}



## Dataframe example -----
for(i in unique(gapminder$country)){
  country_df <- gapminder[gapminder$country == i, ]
  df <- country_df %>%
    summarize(meanGDP = mean(gdpPercap, na.rm = TRUE))
  return(df)
} # And when we use the return function?? one in our environment
df

# how do we know for sure that the for loop is evaluating every country?
for(i in unique(gapminder$country)){
  country_df <- gapminder[gapminder$country == i, ]
  df <- country_df %>%
    summarize(meanGDP = mean(gdpPercap, na.rm = TRUE))
  print(df)
} 

gapminder %>% 
  group_by(country) %>% 
  summarize(meanGDP = mean(gdpPercap, na.rm = TRUE)) %>% 
  head()

## Changing the format so that it will save all the values as a data frame
## 1. What do I want my output to be?


## 2. What is the task I want my for loop to do?


## 3. What values do I want to loop through the task?




# Map Family of Functions -----------------------------------------------------------
# map functions are useful when you want to do something across multiple columns
library(tidyverse)
# two arguments: the data & the function
# think about output, but instead of creating a blank output, you can just use the specific function

# basic function
map(iris, mean) # warning of NA for species
# default is that the output is a list

map_df(iris, mean) # df in, df out, anything that follows the function is the desired output

map_df(iris[1:4], mean) # use subset to be a little more specific & select just columns with continuous data

# class coercion



# often times iteration is paired with custom functions
head(mtcars)
print_mpg <- function(x, y){
  paste(x, "gets", y, "miles per gallon")
}


# more detailed functions which can take two arguments
map2_chr(rownames(mtcars), mtcars$mpg, print_mpg)

# Can also embed an "anonymous" function 
map2_chr(rownames(mtcars), mtcars$mpg, function(x, y) paste(x, "gets", y, "miles per gallon"))

# You can use paste with vectors
paste(rownames(mtcars), "gets", mtcars$mpg, "miles per gallon")

# pmap for more than two inputs

## COMPLETE WORKFLOW

list_of_lap_dataframes <- lapply(fit_files, function(file) {
  print(file)
  fit2 <- readFitFile(paste0(floc, file))
  lap_data <- laps(fit2) %>% select(sport, timestamp,enhanced_avg_speed)
  lap_data
})

nrow(list_of_lap_dataframes[[1]]) + nrow(list_of_lap_dataframes[[2]])

nrow(rbind(list_of_lap_data_frames[[1]], list_of_lap_dataframes[[2]]))
     
do.call('rbind', list_of_lap_dataframes)
length(list_of_lap_dataframes)

seq_along(state.abb) # prints index values for each thing in vector
lapply(seq_along(state.abb), function(x) print(state.abb[x]))

sapply(seq_along(state.abb), function(x) print(state.abb[x])) #simplifies output
sapply(seq_along(state.abb), function(x) print(state.abb[x]), simplify = F) #same as lapply

if(!requireNamespace("remotes")) {
  install.packages("remotes")
}
remotes::install_github("grimbough/FITfileR")
library(R.utils)

floc <- 'data/strava_data/export_55674554/activities/'

gz_files <- list.files(floc,pattern = 'gz$')

library(FITfileR)
for(gz in gz_files){
  if(!file.exists(paste0(floc,stringr::str_remove(gz,'\\.gz$')))){
    gunzip(paste0(floc,gz), remove=FALSE)
  }
}

library(tidyverse)
fit_files <- list.files(floc, pattern = 'fit$')

library(pbapply)
lap_list <- pblapply(fit_files,function(f) {
  fit <- readFitFile(paste0(floc,f))
  sub <- laps(fit) %>% select(sport,timestamp,enhanced_avg_speed,
                              total_elapsed_time,total_ascent,total_descent,
                              avg_speed,avg_cadence,total_distance,avg_temperature,avg_heart_rate)
  sub},cl = 5)

library(data.table)
lap_dt <- rbindlist(lap_list)
library(lubridate)
lap_dt$timestamp <- ymd_hms(lap_dt$timestamp)
lap_dt$year <- year(lap_dt$timestamp)
lap_dt$month <- month(lap_dt$timestamp)
lap_dt$day <- day(lap_dt$timestamp)
lap_dt$date <- paste(lap_dt$year,lap_dt$month,lap_dt$day, sep = '-')
mile_per_hour_converter <- 2.236936
lap_dt$miles_per_hour <- as.numeric(lap_dt$enhanced_avg_speed) * mile_per_hour_converter
lap_dt$mile_pace <- 60 / lap_dt$miles_per_hour
lap_dt$steps_per_minute <- lap_dt$avg_cadence * 2

distance_vars <- grep('descent|ascent|distance',colnames(lap_dt),value = T)
setnames(lap_dt,distance_vars,paste0(distance_vars,'_','m'))
setnames(lap_dt,'total_elapsed_time','total_elapsed_time_s')
setnames(lap_dt,'mile_pace','minutes_per_mile')
setnames(lap_dt,'avg_heart_rate','avg_heart_rate_bpm')
setnames(lap_dt,'avg_speed','avg_speed_mps')
setnames(lap_dt,'enhanced_avg_speed','enhanced_avg_speed_mps')

lap_dt <- lap_dt %>% select(sport,year,month,day,timestamp,
                            total_distance_m,minutes_per_mile,total_elapsed_time_s,
                            avg_heart_rate_bpm,steps_per_minute,total_ascent_m,total_descent_m)

write_csv(lap_dt,file = 'data/tyler_activity_laps_10-24.csv')
