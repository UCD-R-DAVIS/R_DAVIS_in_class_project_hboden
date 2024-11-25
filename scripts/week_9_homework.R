#Week 9 Homework
#Hope Bodenschatz

library(tidyverse)

#Read in surveys dataset
surveys <- read.csv("data/portal_data_joined.csv")

#Using a for loop, print to the console the longest species name of each taxon. Hint: the function nchar() gets you the number of characters in a string.
surveys <- surveys %>% mutate(nchar_species = nchar(species))

for(i in unique(surveys$taxa)){
  taxa_df <- surveys[surveys$taxa == i, ]
  max_species <- taxa_df %>% mutate(max_char = max(nchar_species)) %>% filter(nchar_species == max_char) %>% select(species) %>% head(n=1)
  print(max_species)
}

#Read in mauna loa dataset
mloa <- read_csv("https://raw.githubusercontent.com/ucd-cepb/R-DAVIS/master/data/mauna_loa_met_2001_minute.csv")

#Use the map function from purrr to print the max of each of the following columns: “windDir”,“windSpeed_m_s”,“baro_hPa”,“temp_C_2m”,“temp_C_10m”,“temp_C_towertop”,“rel_humid”,and “precip_intens_mm_hr”.
mloa %>% select(windDir, windSpeed_m_s, baro_hPa, temp_C_2m, temp_C_10m, temp_C_towertop, rel_humid, precip_intens_mm_hr) %>% map(max)

#Make a function called C_to_F that converts Celsius to Fahrenheit. Hint: first you need to multiply the Celsius temperature by 1.8, then add 32. Make three new columns called “temp_F_2m”, “temp_F_10m”, and “temp_F_towertop” by applying this function to columns “temp_C_2m”, “temp_C_10m”, and “temp_C_towertop”. Bonus: can you do this by using map_df? Don’t forget to name your new columns “temp_F…” and not “temp_C…”!
C_to_F <- function(tempC){
  ((tempC*1.8) + 32)
}

mloa$temp_F_2m <- function(tempC = temp_C_2m)
mloa$temp_F_10m <- function(tempC = temp_C_10m)
mloa$temp_F_towertop <- function(tempC = temp_C_towertop)

#Challenge: Use lapply to create a new column of the surveys dataframe that includes the genus and species name together as one string.

#This is as close as I was able to get, but I don't think I'm iterating, and it didn't work. Will look at the answer key to try to understand the right way.
paste_hb <- function(x, y) {
  paste(x, y, sep = " ")}
  
lapply(1:nrows(mloa$species), paste_hb(mloa$genus, mloa$species))
