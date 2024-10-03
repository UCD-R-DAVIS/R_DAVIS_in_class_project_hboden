# Vectors

weight_g <- c(50, 60, 65, 82)
animals <- c("mouse", "rat", "dog")

# Inspection
length(weight_g)
str(weight_g)

# change vectors
weight_g <- c(weight_g, 90)
weight_g <- c(20, weight_g)

# challenge
num_char <- c(1, 2, 3, "a")
class(num_char) #character
num_logical <- c(1, 2, 3, FALSE)
class(num_logical) #numeric
char_logical <- c("a", "b", "c", TRUE)
class(char_logical) #character
tricky <- c(1, 2, 3, "4")
class(tricky) #character

num_logical <- c(1, 2, 3, TRUE)
char_logical <- c("a", "b", "c", TRUE)
combined_logical <- c(num_logical, char_logical) #character

# subsetting
animals <- c("mouse", "rat", "dog", "cat")
animals
animals[2]
animals[c(2,3)]

# conditional subsetting
weight_g <- c(21, 34, 39, 54, 55)
weight_g > 50
weight_g[weight_g>50]
weight_g <- weight_g[weight_g>50]

#symbols
#%in% (within)
animals %in% c("rat","cat","dog","duck","goat")
# == pairwise matching -- ORDER MATTERS
# %in% comparing buckets -- ORDER DOESN'T MATTER