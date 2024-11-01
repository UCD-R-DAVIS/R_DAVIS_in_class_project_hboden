# ggplot2 ----
## Grammar of Graphics plotting package (included in tidyverse package - you can see this when you call library(tidyverse)!)
## easy to use functions to produce pretty plots
## ?ggplot2 will take you to the package helpfile where there is a link to the website: https://ggplot2.tidyverse.org - this is where you'll find the cheatsheet with visuals of what the package can do!

## ggplot basics
## every plot can be made from these three components: data, the coordinate system (ie what gets mapped), and the geoms (how to graphical represent the data)
## Syntax: ggplot(data = <DATA>) + <GEOM_FUNCTION>(mapping = aes(<MAPPING>))

## tips and tricks
## think about the type of data and how many data  variables you are working with -- is it continuous, categorical, a combo of both? is it just one variable or three? this will help you settle on what type of geom you want to plot
## order matters! ggplot works by layering each geom on top of the other
## also aesthetics like color & size of text matters! make your plots accessible 


## example ----
library(tidyverse)
## load in data
surveys <- read_csv("data/portal_data_joined.csv") %>%
  filter(complete.cases(.)) # remove all NA's

## Let's look at two continuous variables: weight & hindfoot length
## Specific geom settings
ggplot(data = surveys, mapping = aes(x = weight, y = hindfoot_length)) + 
  geom_point(aes(color = genus)) + 
  geom_smooth(aes(color = genus))

## Universal geom settings
ggplot(data = surveys, mapping = aes(x = weight, y = hindfoot_length, color = genus)) + 
  geom_point() + 
  geom_smooth(method = "lm")
#method = "lm" means OLS

## Visualize weight categories and the range of hindfoot lengths in each group
## Bonus from hw: 
sum_weight <- summary(surveys$weight)
surveys_wt_cat <- surveys %>% 
  mutate(weight_cat = case_when(
    weight <= sum_weight[[2]] ~ "small", 
    weight > sum_weight[[2]] & weight < sum_weight[[5]] ~ "medium",
    weight >= sum_weight[[5]] ~ "large"
  )) 

table(surveys_wt_cat$weight_cat)


## We have one categorical variable and one continuous variable - what type of plot is best?
ggplot(data = surveys_wt_cat, mapping = aes(x = weight_cat, y = hindfoot_length, color = weight_cat)) + 
  geom_point()

ggplot(data = surveys_wt_cat, mapping = aes(x = weight_cat, y = hindfoot_length, color = weight_cat)) + 
  geom_point(alpha = 0.1) +
  geom_boxplot(alpha = 0)

ggplot(data = surveys_wt_cat, mapping = aes(reorder(x = weight_cat), y = hindfoot_length, color = weight_cat)) + 
  geom_point(alpha = 0.1) +
  geom_boxplot(alpha = 0)

## What if I want to switch order of weight_cat? factor!
surveys_wt_cat$weight_cat <- factor(surveys_wt_cat$weight_cat, levels = c("small", "medium", "large"))
levels(surveys_wt_cat$weight_cat)

ggplot(data = surveys_wt_cat, mapping = aes(x = weight_cat, y = hindfoot_length, color = weight_cat)) + 
  geom_point(alpha = 0.1) +
  geom_boxplot(alpha = 0)

ggplot(data = surveys_wt_cat, mapping = aes(x = weight_cat, y = hindfoot_length, color = weight_cat)) + 
  geom_jitter(alpha = 0.1, width = 0.1) +
  geom_boxplot(alpha = 0.5)

# LECTURE PART 2
surveys_complete <- read_csv('data/portal_data_joined.csv') %>% 
  filter(complete.cases(.))
yearly_counts <- surveys_complete %>%  count(year,species_id)
head(yearly_counts)

ggplot(data = yearly_counts, mapping = aes(x = year, y = n)) + 
  geom_line() #this draws a line from the highest point in a year down through all of the other points in the year

ggplot(data = yearly_counts, mapping = aes(x = year, y = n, group = species_id, color=species_id)) + 
  geom_line() + geom_point()

ggplot(data = yearly_counts, mapping = aes(x = year, y = n, group = species_id, color=species_id)) + 
  geom_line() + 
  geom_point() + 
  facet_wrap(~species_id) #~ is part of a formula, which means map across species_id

#choose subset
ggplot(data = yearly_counts[yearly_counts$species_id %in% c('BA','DM','DO','DS'),], mapping = aes(x = year, y = n, group = species_id, color=species_id)) + 
  geom_line() + 
  geom_point() + 
  facet_wrap(~species_id)

#change scales
ggplot(data = yearly_counts[yearly_counts$species_id %in% c('BA','DM','DO','DS'),], mapping = aes(x = year, y = n, group = species_id, color=species_id)) + 
  geom_line() + 
  geom_point() + 
  facet_wrap(~species_id, scales = 'free_y', nrow=1)

#alter the axis names and scale breaks
ggplot(data = yearly_counts[yearly_counts$species_id %in% c('BA','DM','DO','DS'),], mapping = aes(x = year, y = n, group = species_id, color=species_id)) + 
  geom_line() + 
  geom_point() + 
  facet_wrap(~species_id) + 
  scale_y_continuous(name = 'obs', n.breaks = 10)

#how to change the theme (background)
ggplot(data = yearly_counts[yearly_counts$species_id %in% c('BA','DM','DO','DS'),], mapping = aes(x = year, y = n, group = species_id, color=species_id)) + 
  geom_line() + 
  geom_point() + 
  facet_wrap(~species_id) + 
  scale_y_continuous(name = 'obs', n.breaks = 10) +
  theme_bw()

install.packages('ggthemes')
library(ggthemes)

#how to change the theme (background)
ggplot(data = yearly_counts[yearly_counts$species_id %in% c('BA','DM','DO','DS'),], mapping = aes(x = year, y = n, group = species_id, color=species_id)) + 
  geom_line() + 
  geom_point() + 
  facet_wrap(~species_id) + 
  scale_y_continuous(name = 'obs', n.breaks = 10) +
  theme_stata()

install.packages('tigris')
install.packages('sf')
library(tigris)
library(sf)

ca_counties = tigris::counties(state = 'CA', class='sf', year=2024)
ggplot(data = ca_counties) + 
  geom_sf(aes(fill = ALAND)) + 
  theme_stata() + 
  scale_fill_continuous_tableau()
