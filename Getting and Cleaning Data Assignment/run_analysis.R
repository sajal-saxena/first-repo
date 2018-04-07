
## Reading labels
activity_labels <- as.character(read.table("./UCI HAR Dataset/activity_labels.txt")) 
features <- as.character(read.table("./UCI HAR Dataset/features.txt")[,2])

######  Getting the Train data set #########

train_subject <- read.table("./UCI HAR Dataset//train/subject_train.txt" )
train_set <- read.table("./UCI HAR Dataset//train/X_train.txt" )
train_labels <- read.table("./UCI HAR Dataset//train/y_train.txt" )
train_data <- data.frame(train_subject,train_labels,train_set) 
names(train_data)  <- c('subject','activity',features) 

######  Getting the Test data set #########

test_subject <- read.table("./UCI HAR Dataset//test/subject_test.txt" )
test_set <- read.table("./UCI HAR Dataset//test/X_test.txt" )
test_labels <- read.table("./UCI HAR Dataset//test/y_test.txt" )
test_data <- data.frame(test_subject,test_labels,test_set) 
names(test_data)  <- c('subject','activity',features) 

#### Merge Train and Test data set ###

merged_data <- rbind(train_data,test_data)

#### Extracts only the measurements on the mean and standard deviation for each measurement

mean_std_names <- grep('mean|std', features)
filter_data <- merged_data[ , c(1,2, mean_std_names +2)]

### Uses descriptive activity names to name the activities in the data setde

filter_data$activity <- activity_labels[filter_data$activity]

### Appropriately labels the data set with descriptive variable names

names_data_set <- names(filter_data)
names_data_set <- gsub("[(][)]", "", names_data_set)
names_data_set <- gsub("-", " ", names_data_set)
names_data_set <- gsub("^t", "Time Domain ", names_data_set)
names_data_set <- gsub("^f", "Frequency Domain ", names_data_set)
names_data_set <- gsub("Acc", " Accelerometer", names_data_set)
names_data_set <- gsub("Gyro", " Gyroscope", names_data_set)
names_data_set <- gsub("std", "Standard deviation", names_data_set)
names_data_set <- gsub("Freq$", " frequency ", names_data_set)
names_data_set <- gsub("Jerk", " Jerk", names_data_set)
names_data_set <- gsub("Mag", " Magnitude", names_data_set)
names_data_set <- gsub("BodyBody", "Body Body", names_data_set)

names(filter_data) <- names_data_set

### creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidy_data <- aggregate(filter_data[,3:81], by = list(subject = filter_data$subject, activity = filter_data$activity), FUN = mean)
write.table(x = tidy_data, file = "tidydata.txt")