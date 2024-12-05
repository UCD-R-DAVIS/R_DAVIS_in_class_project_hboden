#Week 9 Homework
#Hope Bodenschatz

library(tidyverse)

#Read in surveys dataset
surveys <- read.csv("data/portal_data_joined.csv")

#Using a for loop, print to the console the longest species name of each taxon. Hint: the function nchar() gets you the number of characters in a string.

for(i in unique(surveys$taxa)){
  taxa_df <- surveys %>% filter(taxa == i)
  print(i)
  myspecies <- unique(taxa_df$species)
  maxlength <- max(nchar(myspecies))
  print(taxa_df %>% filter(nchar(species) == maxlength) %>% select(species) %>% unique())
}

#Read in mauna loa dataset
mloa <- read_csv("https://raw.githubusercontent.com/ucd-cepb/R-DAVIS/master/data/mauna_loa_met_2001_minute.csv")

#Use the map function from purrr to print the max of each of the following columns: “windDir”,“windSpeed_m_s”,“baro_hPa”,“temp_C_2m”,“temp_C_10m”,“temp_C_towertop”,“rel_humid”,and “precip_intens_mm_hr”.
mloa %>% select(windDir, windSpeed_m_s, baro_hPa, temp_C_2m, temp_C_10m, temp_C_towertop, rel_humid, precip_intens_mm_hr) %>% map(max)

#Make a function called C_to_F that converts Celsius to Fahrenheit. Hint: first you need to multiply the Celsius temperature by 1.8, then add 32. Make three new columns called “temp_F_2m”, “temp_F_10m”, and “temp_F_towertop” by applying this function to columns “temp_C_2m”, “temp_C_10m”, and “temp_C_towertop”. Bonus: can you do this by using map_df? Don’t forget to name your new columns “temp_F…” and not “temp_C…”!
C_to_F <- function(tempC){
  ((tempC*1.8) + 32)
}

#Method 1
mloa$temp_F_2m <- function(tempC = temp_C_2m)
mloa$temp_F_10m <- function(tempC = temp_C_10m)
mloa$temp_F_towertop <- function(tempC = temp_C_towertop)
  
#Method 2
mloa <- mloa %>% mutate(temp_F_2m = C_to_F(temp_C_2m), 
                temp_F_10m = C_to_F(temp_C_10m),
                temp_F_towertop = C_to_F(temp_C_towertop))

#Method 3
mloa %>% select(temp_C_2m, temp_C_10m, temp_C_towertop) %>% map_df(C_to_F) %>% rename(temp_F_2m = temp_C_2m, temp_F_10m = temp_C_10m, temp_F_towertop = temp_C_towertop) %>% bind_cols(mloa)

#string R
install.packages("stringr")
library(stringr)

str_replace("temp_F_2m", "_F_", "_C_") #first row only
str_replace_all("temp_F_2m", "_F_", "_C_") #all rows
colanmes <- c("temp_F_2m")

#also bind_rows

#Challenge: Use lapply to create a new column of the surveys dataframe that includes the genus and species name together as one string.
surveys %>% mutate(genusspecies = lapply(
  1:length(surveys), #could also use nrows(surveys)
  function(i){
    paste0(surveys$genus[i], surveys$species[i])
  }
))
