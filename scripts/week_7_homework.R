#Week 7 Homework
#Hope Bodenschatz

library(tidyverse)
library("RColorBrewer")

#Read in gapminder dataset
gapminder <- read_csv("https://ucd-r-davis.github.io/R-DAVIS/data/gapminder.csv")
view(gapminder)

#To get the population difference between 2002 and 2007 for each country, it would probably be easiest to have a country in each row and a column for 2002 population and a column for 2007 population.
gapminder <- gapminder %>% select(country, year, pop, continent) 

gapminder <- gapminder %>% pivot_wider(names_from = "year", values_from = "pop") %>% select(continent, country, '2002', '2007') %>% rename(pop2002='2002', pop2007='2007') %>% mutate(pop_change = pop2007-pop2002)

#Notice the order of countries within each facet. You’ll have to look up how to order them in this way.
#Also look at how the axes are different for each facet. Try looking through ?facet_wrap to see if you can figure this one out.
#The color scale is different from the default- feel free to try out other color scales, just don’t use the defaults!
#The theme here is different from the default in a few ways, again, feel free to play around with other non-default themes.
#The axis labels are rotated! Here’s a hint: angle = 45, hjust = 1. It’s up to you (and Google) to figure out where this code goes!
#Is there a legend on this plot?

ggplot(gapminder[gapminder$continent %in% c('Africa','Americas','Asia','Europe'),], mapping = aes(x = reorder(country, pop_change), y = pop_change, fill = continent)) + 
  geom_col() +
  facet_wrap(~continent, scales = "free") +
  theme_classic() +
  theme(axis.text.x = element_text(angle=45, hjust=1), legend.position="none") + scale_fill_brewer(palette = "Dark2") + xlab("Country") + 
  ylab("Change in Population between 2002 and 2007")
