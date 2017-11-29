#libraries
library(tidyverse)
library(dplyr)
library(plyr)
?mutate
#reading in the data sets

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)

gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# structure, dimensions and summaries
str(hd)
dim(hd)#195 observatios of 8 variables
summary(hd)

str(gii)
dim(gii)#195 observations of 10 variables
summary(gii)


#renaming variables
colnames(hd)
a <- c("rank", "country", "index", "life.exp", "education.exp", "education.mean", "GNI", "GNI.rank")

colnames(hd) <- a
glimpse(hd)

colnames(gii)
a <- c("rank", "country", "genderinequality", "MMR", "adolescentBR", "representation", "seceduF", "seceduM", "labourfF", "labourfM")

colnames(gii) <- a
glimpse(gii)

# Mutate the “Gender inequality” data and create two new variables.

#education ratio
gii2 <- mutate(gii, secedu.ratio=(seceduF/seceduM) )
glimpse(gii2)
#labour ratio
gii3 <- mutate(gii2, labour.ratio=(labourfF/labourfM) )
glimpse(gii3)

# Join together the two datasets using the variable Country as the identifier. Keep only the countries in both data sets (Hint: inner join). The joined data should have 195 observations and 19 variables. Call the new joined data "human" and save it in your data folder. (1 point)

#Joining data sets by Counrty
human <- inner_join(hd, gii3, by = "country", suffix = c(".hd", ".gii"))
dim(human) #195 observations, 19 variables

#saving the data as .cvs in the IODS/data-folder
setwd("/Users/Frida/Dropbox/Abortforskning/opendatascience/IODS_project/data")
getwd()
write.csv(human,"human.csv", row.names = FALSE)

#reading in the dataset again 
human <- read.csv("human.csv", header = TRUE, sep = ",")
dim(human)
