# Merges the training and the test sets to create one data set.
training = read.delim("./UCI HAR Dataset/train/X_train.txt",header = FALSE,sep = "")
test = read.csv("./UCI HAR Dataset/test/X_test.txt", header = FALSE, sep = "")
Total = rbind(training, test)
# names each column 
features = read.csv("./UCI HAR Dataset/features.txt",header = FALSE,sep = "")
colnames(Total) = features[, 2]

# Extracts only the measurements on the mean and standard deviation for each measurement.
Total_sub_mean = Total[, grepl("mean()", names(Total), fixed = TRUE)]
Total_sub_std = Total[, grepl("std()", names(Total), fixed = TRUE)]
Total_sub = cbind(Total_sub_mean, Total_sub_std)

# Uses descriptive activity names to name the activities in the data set
training_y = read.delim("./UCI HAR Dataset/train/y_train.txt", header = FALSE, sep = "")
test_y = read.csv("./UCI HAR Dataset/test/y_test.txt", header = FALSE, sep = "")
Total_y = rbind(training_y, test_y)
activity_labels = read.csv("./UCI HAR Dataset/activity_labels.txt", header = FALSE, sep = "")
index = match(Total_y$V1,activity_labels$V1)
Total_y$V2 = activity_labels[index, c(2)]
Total_sub = cbind(Total_y$V2,Total_sub)
colnames(Total_sub)[1] = "Activity"

# Appropriately labels the data set with descriptive variable names.
# done in the first step

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for     each activity and each subject.
# add subject to the data set
subject_training = read.delim("./UCI HAR Dataset/train/subject_train.txt", header = FALSE, sep = "")
subject_test = read.csv("./UCI HAR Dataset/test/subject_test.txt", header = FALSE, sep = "")
Total_subject = rbind(subject_training, subject_test)
Total_sub = cbind(Total_subject[,1], Total_sub)
colnames(Total_sub)[1] = "Subject"
# get the average of each variable for each activity and each subject
aggdata = aggregate(. ~ Activity + Subject, Total_sub, mean)

# output the result as .txt file
write.table(aggdata, "./HumanActivity.txt", row.names = FALSE, col.names = TRUE, sep = "\t", eol = "\n",)