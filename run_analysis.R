## This script pulls files relating to
## UCI various measurements on a set of 30 subjects engaged
## in 6 activities and creates workable dataframes

##Create a temp connection to download and unzip the files
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", temp)

## These datasets include the measurements partititioned into two groups
testData <- read.table(unz(temp,"UCI HAR Dataset/test/X_test.txt"))
trainData <- read.table(unz(temp,"UCI HAR Dataset/train/X_train.txt"))

## Includes the 561 features measured
attributeNames <- read.table(unz(temp,"UCI HAR Dataset/features.txt"))

## List of activities associated with each measurement
activityTest <- read.table(unz(temp,"UCI HAR Dataset/test/y_test.txt"))
activityTrain <- read.table(unz(temp,"UCI HAR Dataset/train/y_train.txt"))

## The total list of 6 activities
activities <- read.table(unz(temp,"UCI HAR Dataset/activity_labels.txt"))

## The list of subjects split into two datasets
subjectTest <- read.table(unz(temp,"UCI HAR Dataset/test/subject_test.txt"))
subjectTrain <- read.table(unz(temp,"UCI HAR Dataset/train/subject_train.txt"))
unlink(temp)

## We combine the split data from the test and train datasets
allData <- rbind(testData,trainData)
activityData <- rbind(activityTest,activityTrain)
subjectData <- rbind(subjectTest,subjectTrain)

## Convert the activityData list to a factor
## and change the factors to match those of
## the activities variable
activityData <- factor(activityData[,1])
levels(activityData) <- activities$V2

## Name the columns acording to the features file
## The features appear in the second column and must
## be converted to characters.
## Also, remove those parentheses and hyphens
for(i in 1:561) {
  names(allData)[i] <- as.character(attributeNames[i,2])
}

## Here, we begin to use dplyr

library(dplyr)

## The assignment reqests standard deviation and mean variables,
## i.e. those containing the strings in the "contains" function
## I did this using select but got an error
## so now we use grep
## desiredData <- select(allData,contains("std","mean"))

meanAndstd <- union(grep("std",names(allData)),grep("mean",names(allData)))

desiredData <- allData[,meanAndstd] 

## Next, build a dataframe that includes the subject and activities                      
## This dataframe will be grouped and summarized
dataToRegroup <- data.frame("subjectNumber" = subjectData,"activity" = activityData,desiredData)

## For some reason, I need to rename a column
dataToRegroup <- dataToRegroup %>% rename(subjectNumber = V1)

## Build a dataframe that groups by subject and activity.
## There are a total of 180 such pairs. We take the average of
## all numeric columns across this grouping
## with "summarize_if
newData <- dataToRegroup %>% group_by(subjectNumber,activity) %>%
  summarize_if(is.numeric,mean)

## Lastly, we make the (unsatisfactory) choice of rewriting the names
## by signifying that a mean is taken
for(i in 3:81) {
  names(newData)[i] <- paste(names(newData)[i],"-mean",sep = "")
}