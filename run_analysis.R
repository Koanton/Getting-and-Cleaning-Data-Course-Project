# Clean global environment
rm(list=ls())

# Set working directory
setwd("C:/Users/anton/Documents/Data Science/Coursera Data Science/Course 3/assignment")

# Load dplyr, which is needed for the last section of the code
library(dplyr)

# Load source files:
testData<-read.table("X_test.txt", header=FALSE)
trainData<-read.table("X_train.txt", header=FALSE)
features<-read.table("features.txt", header=FALSE)
yTest<-read.table("y_test.txt", header=FALSE)
yTrain<-read.table("y_train.txt", header=FALSE)
subjectTest<-read.table("subject_test.txt")
subjectTrain<-read.table("subject_train.txt")

# Set column headings from the features.txt
names(testData)<-features$V2
names(trainData)<-features$V2

# Set the column heading for the activity file
names(yTest)<-c("Activity")
names(yTrain)<-c("Activity")

# Set the column heading for the subject file
names(subjectTest)<-c("Subject")
names(subjectTrain)<-c("Subject")

# Extract only the columns with mean() from the test set
meansTest<-testData[,grep("*mean\\(\\)*", names(testData))]

# Extract only the columns with std() from the test set
stdsTest<-testData[,grep("*std\\(\\)*", names(testData))]

# Combine means and standard deviations columns
finalTest<-cbind(meansTest, stdsTest)

# Append the activity column to the front of the file
finalTest<-cbind(yTest, finalTest)

# Append the subject column to the front of the file
finalTest<-cbind(subjectTest, finalTest)

# Repeat as above for the training set
meansTrain<-trainData[,grep("*mean\\(\\)*", names(trainData))]
stdsTrain<-trainData[,grep("*std\\(\\)*", names(trainData))]
finalTrain<-cbind(meansTrain, stdsTrain)
finalTrain<-cbind(yTrain, finalTrain)
finalTrain<-cbind(subjectTrain, finalTrain)

# Combine the resulting traing and testing data sets
finalData<-rbind(finalTest, finalTrain)

# Rename column headings into more user-friendly text
# See ReadMe file for nomenclature
names(finalData)<-sub("^t", "Time-", names(finalData))
names(finalData)<-sub("^f", "FFT-", names(finalData))
names(finalData)<-sub("Acc","Acceleration-",names(finalData))
names(finalData)<-sub("Jerk","JerkSignal-",names(finalData))
names(finalData)<-sub("Gyro","Gyroscope-",names(finalData))
names(finalData)<-sub("Mag","Magnitude-",names(finalData))
names(finalData)<-sub("Body","Body-",names(finalData))
names(finalData)<-sub("Gravity","Gravity-",names(finalData))
names(finalData)<-sub("mean\\(\\)", "MEAN", names(finalData))
names(finalData)<-sub("std\\(\\)", "SD", names(finalData))
names(finalData)<-sub("--", "-", names(finalData))

# Rename activity values into more user-friendly text
finalData$Activity<-sub("1", "Walking", finalData$Activity)
finalData$Activity<-sub("2", "Walking Upstairs", finalData$Activity)
finalData$Activity<-sub("3", "Walking Downstairs", finalData$Activity)
finalData$Activity<-sub("4", "Sitting", finalData$Activity)
finalData$Activity<-sub("5", "Standing", finalData$Activity)
finalData$Activity<-sub("6", "Laying", finalData$Activity)

# Create the tidy data extract by grouping the results by subject and activity
# Means are computed for the resulting groupings 
tidyData<-finalData %>%
    group_by(Subject, Activity) %>%
    summarize_all(mean)

# Export the resulting tidy data
# Ensure row names are not exported
write.table(tidyData, "tidy_data.txt", row.names=FALSE)

