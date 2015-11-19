require(data.table)

#1) Parse and Merge
subject <- rbind(read.table("UCI HAR Dataset/test/subject_test.txt"), read.table("UCI HAR Dataset/train/subject_train.txt"))
setnames(subject, "subject")
activity <- rbind(read.table("UCI HAR Dataset/test/y_test.txt"), read.table("UCI HAR Dataset/train/y_train.txt"))
setnames(activity, "activityId")
data <- rbind(read.table("UCI HAR Dataset/test/X_test.txt"), read.table("UCI HAR Dataset/train/X_train.txt"))
subject <- cbind(subject, activity)
data <- cbind(subject, data)

#2) Extract Mean and Standard Deviation
features <- fread("UCI HAR Dataset/features.txt")
setnames(features, names(features), c("featureId", "featureName"))
#4) (Use Descriptive Variable Names)
setnames(data, c("subject", "activityId", features$featureName))
features <- features[grepl("mean\\(\\)|std\\(\\)", featureName)]
select <- c("subject", "activityId", features$featureName)
data <- data[, select]

#3) Set Descriptive Activity Names
activityNames <- fread("UCI HAR Dataset/activity_labels.txt")
setnames(activityNames, names(activityNames), c("activityId", "activityName"))
data <- merge(data, activityNames, by="activityId", all.x=TRUE)

#5) Create Tidy Dataset
size <- ncol(data)
aggregatedData <- aggregate(data[4:size-1], list(activity=data$activityName, subject=data$subject), mean)

#Write Data
write.table(aggregatedData, "data.txt", row.name=FALSE)