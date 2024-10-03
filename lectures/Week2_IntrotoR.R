# Introduction to R: arithmetic

3 + 4
# incomplete command: finish line or press escape in console to move ahead
2 * 5

#order of operations is followed by R
4 + 8 * 3 ^ 2
#or you can use parentheses to change the order
4 + (8 * 3) ^ 2

#scientific notation
2 / 100000
4e3

#mathematical functions
exp(1)
exp(3)
log(4)
sqrt(4)

#R help files
?log

#order matters
log(2, 4)
log(4, 2)

#best to explicitly say arguments (also order doesn't matter if you do this)
log(x=2, base=4)

#assigning variables
x <- 1
x
rm(x)

#nested functions (R works from inside out)
sqrt(exp(4))

#six comparison functions
mynumber <- 6 # alternatively, mynumber = 6
mynumber == 5
mynumber != 5
mynumber > 4
mynumber < 3
mynumber >= 2
mynumber <= -1

#objects and assignment: you can overwrite variable values
mynumber <- 7
othernumber <- -3
mynumber * othernumber

#object naming conventions
numSamples <- 50
num_samples <- 50
numsamples <- 50
rm(numSamples)
rm(numsamples)
rm(list = ls()) #removes all variables

#challenge
elephant1_kg <- 3492
elephant2_lb <- 7757
elephant1_lb <- elephant1_kg * 2.2
elephant2_lb > elephant1_lb
my_elephants <- c(elephant1_lb, elephant2_lb)
which(my_elephants==max(my_elephants))
