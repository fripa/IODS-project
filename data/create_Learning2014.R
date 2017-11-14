# Frida Gyllenberg, november 14th, 2017
# script for data wranglig, RStudio exercise 2

#### libraries ####
library(dplyr)


#reading in the data
url <- "http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt"
learning2014 <- read.table(url, sep = "\t" , header=TRUE)
# exploring the data
glimpse(learning2014) # quick glimpse of the data
str(learning2014) #structure
dim(learning2014) #dimensions

colnames(learning2014)

#making the variables deep, surf, and stra

deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# select the columns related to deep learning and create column 'deep' by averaging
deep_columns <- select(learning2014, one_of(deep_questions))
learning2014$deep <- rowMeans(deep_columns)

# select the columns related to surface learning and create column 'surf' by averaging
surface_columns <- select(learning2014, one_of(surface_questions))
learning2014$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning and create column 'stra' by averaging
strategic_columns <- select(learning2014, one_of(strategic_questions))
learning2014$stra <-rowMeans(strategic_columns)

colnames(learning2014)

#making subset with variables gender, Age, Attitude, deep, stra, surf, Points, excluding  observations where Points is 0

analysis <- subset(learning2014, Points!=0, c(gender, Age, Attitude, deep, stra, surf, Points))
dim(analysis) # 166 observations of 7 variables
colnames(analysis)
#### working directory ####
getwd()
#set wd to the data-folder for saving the csv
setwd("/Users/Frida/Dropbox/Abortforskning/opendatascience/IODS_project/data")

# saving as cvs to data folder
write.csv(analysis,"learning2014.csv")

#reading in the dataset again 
learning2014 <- read.csv("learning2014.csv", header = TRUE, sep = ",")
#of some reason, read.csv makes me a new variable X. Making this null to get a vlean data frame
learning2014$X <- NULL

#Checking the dataframe
str(learning2014)
head(learning2014)
#looks good, still 166 rows and 7 variables.

