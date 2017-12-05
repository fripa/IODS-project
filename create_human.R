## create human, Frida Gyllenberg, continuing with the data wrangling on December 5th, 2017.

#libraries
library(tidyverse)
library(dplyr)
library(plyr)

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

#### Data wrangling R Studio Excercise 5 
library(stringr)
#downloading the data
human <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human1.txt", header = TRUE, sep = ",")
View(human)
dim(human)
str(human)

# look at the structure of the GNI column in 'human'
str(human$GNI) # a factor string

# remove the commas from GNI and print out a numeric version of it
human$GNI <- str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric
str(human$GNI) # now it is numeric.

# Excluding unneeded variables in  a new dataset called human2

keep <- c("Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")

human2 <- dplyr::select(human, one_of(keep))
str(human2)

### remove all rowes with missing values

# print out a completeness indicator of the 'human' data
complete.cases(human2)

# print out the data along with a completeness indicator as the last column
data.frame(human2[-1], comp = complete.cases(human))
str(human2)
# filter out all rows with NA values
human_ <- filter(human2,complete.cases(human)==TRUE)
str(human_) # now the number of observations is reduced from 195 to 162.

#Remove the observations which relate to regions instead of countries.
colnames(human_)
human_$Country # from observation 156 forward it is no longer countries = 7 last observations
last <- nrow(human_) - 7
# choose everything until the last 7 observations
human_ <- human_[1:last, ]
# add countries as rownames
rownames(human_) <- human_$Country
dim(human_)
#remove country as column
human_ <- select(human_, -Country)
dim(human_)
View(human_)

#saving the data as .cvs in the IODS/data-folder
setwd("/Users/Frida/Dropbox/Abortforskning/opendatascience/IODS_project/data")
getwd()
write.csv(human_,"human.csv", row.names = TRUE)

#reading in the dataset again 
human <- read.csv("human.csv", header = TRUE, sep = ",", row.names = 1)
dim(human_)

