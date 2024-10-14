#Week 3 homework
#Hope Bodenschatz

#load survey data frame
surveys <- read.csv("data/portal_data_joined.csv")

#create a new data frame called surveys_base with only the species_id, weight, and plot_type columns
surveys_base <- data.frame(surveys[c("species_id","weight","plot_type")])
head(surveys_base) #check

#remove surveys dataframe to avoid getting confused
rm(surveys)

#limit to first 5,000 rows
surveys_base <- surveys_base[1:5000,]
tail(surveys_base) #check

#convert species_id and plot_type to factors
surveys_base$species_id <- factor(surveys_base$species_id)
surveys_base$plot_type <- factor(surveys_base$plot_type)
str(surveys_base) #check

#remove all rows where there is an NA in the weight column
#count number of NA
sum(is.na(surveys_base$weight)) # result is 368, so we should have 5000-368=4632 rows after this
sum(is.na(surveys_base$species_id)) # result is 0
sum(is.na(surveys_base$plot_type)) # result is 0
#because weight is the only column with any NA values, removing the rows with an NA in the weight column is equivalent to removing all rows in the dataframe with NA values
surveys_base1 <- surveys_base[complete.cases(surveys_base), ]

#alternative way to remove all rows with NA
surveys_base2 <- surveys_base[!is.na(surveys_base$weight),]

#why is a factor different than a character?
#Answer: A factor assigns an order and a numeric value to characters. My expectation is that this is useful if you want to group by categories using a function
#that takes numerical inputs. For example, if you have a factor variable with three levels and want to create three graphs (one for each level), I expect that the
#data visualization functions may be designed to recognize the levels by their integer value as opposed to a difference in the strings.

#Challenge: create a second data frame called challenge_base that only consists of individuals from your surveys_base data frame with weights greater than 150g
sum(surveys_base1$weight>150) #result is 209, so we should be left with 209 rows
challenge_base <- surveys_base1[surveys_base1$weight >150,]
