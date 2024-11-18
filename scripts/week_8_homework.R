#Week 8 Homework
#Hope Bodenschatz

library(tidyverse)
library(lubridate)

#Read in data
mloa <- read_csv("https://raw.githubusercontent.com/gge-ucd/R-DAVIS/master/data/mauna_loa_met_2001_minute.csv")

#Use the README file associated with the Mauna Loa dataset to determine in what time zone the data are reported, and how missing values are reported in each column. 

#According to the README file, the time is in UTC (coordinated universal time) and missing values are denoted by -9, -99, -999.9, or -999.90

#With the mloa data.frame, remove observations with missing values in rel_humid, temp_C_2m, and windSpeed_m_s. 

summary(mloa$rel_humid)
summary(mloa$temp_C_2m)
summary(mloa$windSpeed_m_s) # I think that the windspeed missing values denotation is listed incorrectly in the readme file - it says it is -999.9 but when I ran a summary on the variable the minimum was -99.9 so I believe that that denotes the missing values as -99.9 is an improbable wind speed value
mloa <- mloa %>% filter(rel_humid!=-99, temp_C_2m!=-999.9, windSpeed_m_s!=-99.9)
summary(mloa$rel_humid)
summary(mloa$temp_C_2m)
summary(mloa$windSpeed_m_s)

#Generate a column called “datetime” using the year, month, day, hour24, and min columns. 
class(year)
mloa$datetime <- paste(mloa$month,"-", mloa$day, "-", mloa$year, ",", mloa$hour24, ":", mloa$min, sep = "")
mloa %>% select(datetime, month, day, year, hour24, min) %>% tail()
mloa$datetime <- mdy_hm(mloa$datetime, 
                               tz = "UTC")
mloa %>% select(datetime, month, day, year, hour24, min) %>% tail()

#Next, create a column called “datetimeLocal” that converts the datetime column to Pacific/Honolulu time (HINT: look at the lubridate function called with_tz()). 
mloa$datetimeLocal <- with_tz(mloa$datetime, tzone = "Pacific/Honolulu")
  
#Then, use dplyr to calculate the mean hourly temperature each month using the temp_C_2m column and the datetimeLocal columns. (HINT: Look at the lubridate functions called month() and hour()). 
mloa$month <- month(mloa$datetimeLocal, label = TRUE, abbr=TRUE)
mloa$hour <- hour(mloa$datetimeLocal)
mloa_avgtemp <- mloa %>% group_by(month, hour) %>% summarize(mean_temp = mean(temp_C_2m))
mloa_avgtemp  

#Finally, make a ggplot scatterplot of the mean monthly temperature, with points colored by local hour.
mloa_avgtemp %>% ggplot(mapping = aes(x = month, y = mean_temp, color = -hour)) + geom_point() + scale_color_viridis_c() + xlab("Month") + ylab("Temperature at 2 meters above ground level (Celsius)")
  theme_classic()
