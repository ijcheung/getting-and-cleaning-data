#Code Walkthrough

    subject <- rbind(read.table("UCI HAR Dataset/test/subject_test.txt"), read.table("UCI HAR Dataset/train/subject_train.txt"))
    setnames(subject, "subject")
    activity <- rbind(read.table("UCI HAR Dataset/test/y_test.txt"), read.table("UCI HAR Dataset/train/y_train.txt"))
    setnames(activity, "activityId")
    data <- rbind(read.table("UCI HAR Dataset/test/X_test.txt"), read.table("UCI HAR Dataset/train/X_train.txt"))
    subject <- cbind(subject, activity)
    data <- cbind(subject, data)

This code will read in the raw data containing the subject id, activity id, and feature data using `read.table`. Then, it will bind the test and train data together using `rbind`. Finally, it will merge the three tables together using `cbind`.

    features <- fread("UCI HAR Dataset/features.txt")
    setnames(features, names(features), c("featureId", "featureName"))
    setnames(data, c("subject", "activityId", features$featureName))
    features <- features[grepl("mean\\(\\)|std\\(\\)", featureName)]
    select <- c("subject", "activityId", features$featureName)
    data <- data[, select]

This code will read in the feature names using `fread` and apply them as column names to the existing dataset. Then, it will filter the features using `grepl`, keeping only features with "mean()" or "std()". The dataset is similarly reduced to the "subject", "activityId", and remaining features.

    activityNames <- fread("UCI HAR Dataset/activity_labels.txt")
    setnames(activityNames, names(activityNames), c("activityId", "activityName"))
    data <- merge(data, activityNames, by="activityId", all.x=TRUE)

This code will read in the activity names and using `fread` and use the resulting list to create another column in the dataset, mapping the activity id to the activity name.

    size <- ncol(data)
    aggregatedData <- aggregate(data[4:size-1], list(activity=data$activityName, subject=data$subject), mean)

This code creates an aggregated dataset with the mean of each variable for each activity and each subject. `size` is used to drop the "activityId", "subject", and "activityName" columns.

    write.table(aggregatedData, "data.txt", row.name=FALSE)

This code will write the results to a file: "data.txt".