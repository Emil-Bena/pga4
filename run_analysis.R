## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.


# Load libraries
install.packages("tidyverse")
library(tidyverse)

# Read necessary data from local directory
ActivityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
FeatureLabels <- read.table("./UCI HAR Dataset/features.txt")
xTrain  <- read.table("./UCI HAR Dataset/train/X_train.txt")
yTrain  <- read.table("./UCI HAR Dataset/train/y_train.txt")
xTest   <- read.table("./UCI HAR Dataset/test/X_test.txt")
yTest   <- read.table("./UCI HAR Dataset/test/y_test.txt")
SubjectTest   <- read.table("./UCI HAR Dataset/test/subject_test.txt")
SubjectTrain  <- read.table("./UCI HAR Dataset/train/subject_train.txt")

## 1. Merges the training and the test sets to create one data set.
# Binding sets
features <- rbind(xTest,xTrain)
activity  <- rbind(yTest,yTrain)
subject <- rbind(SubjectTest,SubjectTrain)

# Renaming columns
colnames(features) <- t(FeatureLabels[2])
colnames(activity) <- "Activity"
colnames(subject) <- "Subject"

# Creating whole dataset
dataset <- cbind(features,activity,subject)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# Extracting columns with mean and standard deviation
dataset2 <- dataset %>% select("Subject","Activity",contains("mean"), contains("std"))

## 3. Uses descriptive activity names to name the activities in the data set
dataset2$Activity <- ActivityLabels[dataset2$Activity,2]


## 4. Appropriately labels the data set with descriptive activity names.
names(dataset2)  <-  gsub("Acc", "Accelerometer", names(dataset2), ignore.case = TRUE)
names(dataset2)  <-  gsub("Gyro", "Gyroscope", names(dataset2), ignore.case = TRUE)
names(dataset2)  <-  gsub("BodyBody", "Body", names(dataset2), ignore.case = TRUE)
names(dataset2)  <-  gsub("Mag", "Magnitude", names(dataset2), ignore.case = TRUE)
names(dataset2)  <-  gsub("^t", "Time", names(dataset2), ignore.case = TRUE)
names(dataset2)  <-  gsub("^f", "Frequency", names(dataset2), ignore.case = TRUE)
names(dataset2)  <-  gsub("tBody", "TimeBody",names(dataset2), ignore.case = TRUE)
names(dataset2)  <-  gsub("-mean()", "Mean", names(dataset2), ignore.case = TRUE)
names(dataset2)  <-  gsub("-std()", "Std", names(dataset2), ignore.case = TRUE)
names(dataset2)  <-  gsub("-freq()", "Frequency", names(dataset2), ignore.case = TRUE)
names(dataset2)  <-  gsub("angle", "Angle", names(dataset2), ignore.case = TRUE)
names(dataset2)  <-  gsub("gravity", "Gravity", names(dataset2), ignore.case = TRUE)
names(dataset2)  <-  gsub(",", "", names(dataset2), ignore.case = TRUE)
names(dataset2)  <-  gsub(")", "", names(dataset2), ignore.case = TRUE)
names(dataset2)  <-  gsub("[(]", "", names(dataset2), ignore.case = TRUE)
names(dataset2)  <-  gsub("-", "", names(dataset2), ignore.case = TRUE)

## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidydataset <- aggregate(. ~Subject+Activity, dataset2, mean)
write.table(tidydataset, file = "Tidydataset.txt", row.names = FALSE)
