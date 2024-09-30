#Copy and run code from HW2
set.seed(15)
hw2 <- runif(50, 4, 50)
hw2 <- replace(hw2, c(4,12,22,27), NA)
hw2

#Remove NA
hw2 <- hw2[!is.na(hw2)]
hw2

#Select numbers between 14 and 38 inclusive
prob1 <- hw2[hw2>=14 & hw2<=38]
prob1

#Multiply each number in prob1 by 3
times3 <- prob1*3

#Add 10 to each number in times3
plus10 <- times3+10

#Select every other number in plus10
plus10 <- plus10[c(TRUE, FALSE)]
plus10
