# Frida Gyllenberg, november 22nd, 2017
# script for data wranglig, RStudio exercise 3

#data imported from https://archive.ics.uci.edu/ml/datasets/Student+Performance


#reading in student-mat from data-folder
s.mat <- read.csv2("~/Dropbox/Abortforskning/opendatascience/IODS_project/data/student-mat.csv")
dim(s.mat) # 395 rows and 33 columns
str(s.mat) # structure

#reading in student-por from data-folder
s.por <- read.csv2("~/Dropbox/Abortforskning/opendatascience/IODS_project/data/student-por.csv")
dim(s.por) # 649 rows and 33 columns
str(s.por) # structure

# Joining the two data sets using the variables "school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery","internet" as (student) identifiers. Keeping only the students present in both data sets.

# access the dplyr library
library(dplyr)

# common columns to use as identifiers
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")

# join the two datasets by the selected identifiers
math_por <- inner_join(s.mat, s.por, by = join_by)
alc <- select(math_por, one_of(join_by))
# see the new column names
colnames(alc)

# glimpse at the data
glimpse(alc)
dim(alc) # 382 observations and 13 columns
str(alc)

# deleting duplicates
# the columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(s.mat)[!colnames(s.mat) %in% join_by]

# print out the columns not used for joining
print(notjoined_columns)

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(math_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}
glimpse(alc)
dim(alc)
str(alc)

# Take the average of the answers related to weekday and weekend alcohol consumption to create a new column 'alc_use' to the joined data.

alc <- mutate(alc, alc_use = (Dalc + Walc) / 2) 

# Then use 'alc_use' to create a new logical column 'high_use' which is TRUE for students for which 'alc_use' is greater than 2 (and FALSE otherwise). 

alc <- mutate(alc, high_use = alc_use > 2)

glimpse(alc)
dim(alc) #382 observations and 35 variables, just as it should.
str(alc)


#saving the data as .cvs in the IODS/data-folder
write.csv(alc,"alc.csv", row.names = FALSE)

#reading in the dataset again 
alc <- read.csv("alc.csv", header = TRUE, sep = ",")


#Checking the dataframe
str(alc)
head(alc)
dim(alc)
#looks good, still 382 observations of 35 variables.
