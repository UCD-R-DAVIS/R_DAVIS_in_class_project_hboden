#Other data types
## Lists

c(4, 6, "dog")
a <- list(4, 6, "dog")
class(a)
str(a)

# Data Frames
# Can have different types of data but all have to be the same length

letters
data.frame(letters)
df <- data.frame(letters)
length(df)
dim(df)
nrow(df)
ncol(df)
as.data.frame(t(df)) # transposing, need to use as.data.frame to have it not turn into a matrix (since t is a matrix function)

# also arrays and matrices (matrices are two dimensional, arrays are three dimensional)
# with matrices be careful to know whether you're assigning data row-wise or column-wise

# factors
# character values with levels, combination of string values and order assigned to the string values
animals <- factor(c("duck", "duck", "goose", "goose", "chicken"))
animals

# levels are assigned in alphabetical order
class(animals)
levels(animals) # gives you the names of the levels associated with the factor
nlevels(animals) # gives you the number of levels associated with the factor

# how to change order of factors
animals <- factor(x = animals, levels = c("goose", "chicken", "duck"))
animals
as.numeric(animals) # gives numeric level values of the levels
as.character(animals) # lose ordering information, only gives you the names

# factor with numbers
year <- factor(c(1978, 1980, 1934, 1979))
year
as.numeric(year) # gives numeric level values of the levels, doesn't give you the numbers themselves
as.numeric(as.character(year)) #as.character runs first, removes the levels, then numeric will give you the numbers themselves
levels(year)

## Using Spreadsheets

?read.csv
file_loc <- 'data/portal_data_joined.csv'
surveys <- read.csv(file_loc)
str(surveys)
surveys
class(surveys)

nrow(surveys)
ncol(surveys)
summary(surveys)
summary(surveys$record_id) # summary for a particular column

# Indexing with 2 dimensions
# first value is row, second value is column
surveys[1,5]
surveys[1:5,] # this gives you first five rows, and all columns because columns aren't specified
surveys[c(1, 5, 24, 3001),]
surveys[,1:5] #first five columns, all rows (up to an extent)
surveys[,1]
surveys[1] # if only specify one number, it gives you the column matching that number

colnames(surveys)
surveys[c('record_id','year','day')] # it's better to use the actual name of the column instead of the number in case you change column order

head(surveys) #first five rows
head(surveys, n=1) # first row only
head(surveys[1:10,]) # useful to include head wrapper at first to check work

tail(surveys) # last 6 rows

head(surveys["genus"]) # pulls column from the data frame in data frame form
head(surveys[["genus"]]) # looks like a vector, double bracket gets into internal object within larger object
# data frames are made up of vectors, double bracket gives the individual vector

str(surveys["genus"])
str(surveys[["genus"]])

surveys[c("genus","species")]
surveys["genus",] # genus is the name of a column but you're treating it as a row, so R can't find anything

surveys[,"genus"]

surveys$genus # open object and move to next level of names (allows you to choose column names)
surveys$hindfoot_length
class(surveys$hindfoot_length)
class(surveys$genus)

# dollar sign can work on list but only if you assign names to parts of the list
# mostly use dollar sign in data frame because names automatically assigned

# Tidyverse package
install.packages('tidyverse') # need character string to search internet R server
library(tidyverse) # use object name because is loaded as object in R after installation
t_surveys <- read_csv('data/portal_data_joined.csv')
class(t_surveys)
t_surveys
