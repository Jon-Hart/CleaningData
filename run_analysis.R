# Download the data.

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
              "data/Dataset.zip", method="curl")
date()

unzip("data/Dataset.zip")

activity.labels <- read.table("UCI HAR Dataset/activity_labels.txt", sep="", quote="")
test.x <- read.table("UCI HAR Dataset/test/X_test.txt", sep="", quote="")
test.y <- read.table("UCI HAR Dataset/test/y_test.txt", sep="", quote="")
test.y <- factor(test.y$V1, 1:6, activity.labels[, 2])
test.subject <- read.table("UCI HAR Dataset/test/subject_test.txt", sep="", quote="")

features <- read.table("UCI HAR Dataset/features.txt", sep="", quote="")

test <- data.frame(train=F, subject=test.subject, activity=test.y, test.x)
colnames(test) <- c("train", "subject", "activity", as.character(features[, 2]))

train.x <- read.table("UCI HAR Dataset/train/X_train.txt", sep="", quote="")
train.y <- read.table("UCI HAR Dataset/train/y_train.txt", sep="", quote="")
train.y <- factor(train.y$V1, 1:6, activity.labels[, 2])
train.subject <- read.table("UCI HAR Dataset/train/subject_train.txt", sep="", quote="")

train <- data.frame(train=T, subject=train.subject, activity=train.y, train.x)
colnames(train) <- c("train", "subject", "activity", as.character(features[, 2]))
data <- rbind(test, train)

data <- data[, c(1:3, grep("mean", features[, 2])+3, grep("std", features[, 2])+3)]


library(plyr)
data.summary <- ddply(data, .(activity, subject), function(df) {
  data.frame(df[1, 1:3], do.call(cbind, lapply(df[, -(1:3)], mean)))
})
