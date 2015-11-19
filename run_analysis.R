library(plyr)

#1. Merges the training and the test sets to create one data set.

####Get the x and merge
test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
merge_xx <- rbind(train,test)

####Get the y (activity label) and merge

test_y <- read.table("UCI HAR Dataset/test/Y_test.txt", header = FALSE)
train_y <- read.table("UCI HAR Dataset/train/Y_train.txt", header = FALSE)
merge_yy <- rbind(train_y,test_y) 
names(merge_yy) <- "id"

####Get the subject and merge
test_sub <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
train_sub <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
merge_sub <- rbind(train_sub,test_sub) 
names(merge_sub) <- "subject"

#Extracts only the measurements on the mean and standard deviation for each measurement. 

###Clean up and rename the features to give the data frame titles

features <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)[,2]
features <- gsub('[-()]', '', features)

what_we_want <- grepl("mean|std", features)
merge_xx <- merge_xx[what_we_want]

#Uses descriptive activity names to name the activities in the data set

###Get them all together

messy_data <- cbind(merge_sub,merge_yy,merge_xx)
names(messy_data) <- c("subject","id",features[what_we_want])

#Appropriately labels the data set with descriptive variable names. 

activities <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)[,2]
my_df <- data.frame(id = 1:6, activities)

tidy_data <- join(messy_data, my_df, by = "id", type = "left", match = "all")
tidy_data <-select(tidy_data,-id)

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

write.table(tidy_data, "tidy_data.txt", sep="\t", row.name=FALSE)
