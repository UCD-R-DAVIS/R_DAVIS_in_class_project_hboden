#Working directory is where .Rproj file is

getwd()
setwd("/Users/hopebodenschatz/Desktop/R-Projects/R_DAVIS_in_class_project_hboden")
#relative path: 
d <- read.csv("./data/tail_length.csv")

## Best practices
# Treat raw data as read only
# Treat generated output as disposable

dir.create("./lectures")
