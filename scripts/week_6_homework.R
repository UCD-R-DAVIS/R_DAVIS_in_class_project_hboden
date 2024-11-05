#Week 6 Homework
#Hope Bodenschatz

library(tidyverse)

#read in gapminder data
gapminder <- read_csv("https://ucd-r-davis.github.io/R-DAVIS/data/gapminder.csv") #ONLY change the "data" part of this path if necessary
view(gapminder)

#First calculate mean life expectancy on each continent. Then create a plot that shows how life expectancy has changed over time in each continent. Try to do this all in one step using pipes! (aka, try not to create intermediate dataframes)
gapminder %>% group_by(continent, year) %>% mutate(mean_life_exp = mean(lifeExp)) %>% ggplot(data = ., mapping = aes(x = year, y = mean_life_exp, group = continent, color=continent)) + 
  geom_line()

#Look at the following code and answer the following questions. What do you think the scale_x_log10() line of code is achieving? What about the geom_smooth() line of code?
ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(color = continent), size = .25) + 
  scale_x_log10() +
  geom_smooth(method = 'lm', color = 'black', linetype = 'dashed') +
  theme_bw()

#I think the scale_x_log10() line of code is transforming the x axis to be on a log scale. I think that the geom_smooth() line of code is calculating some sort of line of best fit through the scatterplot.

#Challenge! Modify the above code to size the points in proportion to the population of the country. 
gapminder <- gapminder %>% mutate(pop_hundred_mil = pop/100000000)
ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(color = continent), size = gapminder$pop_hundred_mil) + 
  scale_x_log10() +
  geom_smooth(method = 'lm', color = 'black', linetype = 'dashed') +
  theme_bw()

#Create a boxplot that shows the life expectancy for Brazil, China, El Salvador, Niger, and the United States, with the data points in the background using geom_jitter. Label the X and Y axis with “Country” and “Life Expectancy” and title the plot “Life Expectancy of Five Countries”.
ggplot(data = gapminder[gapminder$country %in% c('Brazil','China','El Salvador','Niger','United States'),], mapping = aes(x = country, y = lifeExp, color = country)) + 
  geom_boxplot(alpha = 0.5) +
  geom_jitter(width = 0.2) +
  labs(title="Life Expectancy of Five Countries", x="Country", y="Life Expectancy")
