# Downloading the raw data --------------------------------------------------------------------
# Data is downloaded to the current working directory and respective subdirectories

fileURL <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
if(!file.exists('./data'))
      dir.create('data')
if(!file.exists('./data/UCI HAR Dataset.zip'))
      download.file(url = fileURL, destfile = './data/UCI HAR Dataset.zip')
unzip('./data/UCI HAR Dataset.zip', exdir = './data')

# Reading the training and test datasets ------------------------------------------------------
train.dir <- "./data/UCI HAR Dataset/train/"
test.dir  <- "./data/UCI HAR Dataset/test/"
train.signal.dir <- "./data/UCI HAR Dataset/train/Inertial Signals/"
test.signal.dir  <- "./data/UCI HAR Dataset/test/Inertial Signals/"

features <- read.table("./data/UCI HAR Dataset/features.txt", sep = " ", 
                       row.names = 1, stringsAsFactors = FALSE)

activity.names <- read.table("./data/UCI HAR Dataset/activity_labels.txt", sep = " ", 
                             stringsAsFactors = FALSE, 
                             col.names = c("Activity.Num", "Activity.Name"))

test.subject  <- read.table( paste0(test.dir,  "subject_test.txt") , sep = " ")
test.x  <- read.table( paste0( test.dir, "X_test.txt", sep = " "))
test.y  <- read.table( paste0( test.dir, "y_test.txt", sep = " "))
## Reading Inertial Data is not needed for this assignment
# test.body_acc_x   <- read.table(paste0(test.signal.dir,  "body_acc_x_test.txt", sep = " "))
# test.body_acc_y   <- read.table(paste0(test.signal.dir,  "body_acc_y_test.txt", sep = " "))
# test.body_acc_z   <- read.table(paste0(test.signal.dir,  "body_acc_z_test.txt", sep = " "))
# test.body_gyro_x  <- read.table(paste0(test.signal.dir,  "body_gyro_x_test.txt", sep = " "))
# test.body_gyro_y  <- read.table(paste0(test.signal.dir,  "body_gyro_y_test.txt", sep = " "))
# test.body_gyro_z  <- read.table(paste0(test.signal.dir,  "body_gyro_z_test.txt", sep = " "))
# test.total_acc_x  <- read.table(paste0(test.signal.dir,  "total_acc_x_test.txt", sep = " "))
# test.total_acc_y  <- read.table(paste0(test.signal.dir,  "total_acc_y_test.txt", sep = " "))
# test.total_acc_z  <- read.table(paste0(test.signal.dir,  "total_acc_z_test.txt", sep = " "))

train.subject  <- read.table( paste0(train.dir,  "subject_train.txt") , sep = " ")
train.x  <- read.table( paste0( train.dir, "X_train.txt", sep = " "))
train.y  <- read.table( paste0( train.dir, "y_train.txt", sep = " "))
## Reading Inertial Data is not needed for this assignment
# train.body_acc_x   <- read.table(paste0(train.signal.dir,  "body_acc_x_train.txt", sep = " "))
# train.body_acc_y   <- read.table(paste0(train.signal.dir,  "body_acc_y_train.txt", sep = " "))
# train.body_acc_z   <- read.table(paste0(train.signal.dir,  "body_acc_z_train.txt", sep = " "))
# train.body_gyro_x  <- read.table(paste0(train.signal.dir,  "body_gyro_x_train.txt", sep = " "))
# train.body_gyro_y  <- read.table(paste0(train.signal.dir,  "body_gyro_y_train.txt", sep = " "))
# train.body_gyro_z  <- read.table(paste0(train.signal.dir,  "body_gyro_z_train.txt", sep = " "))
# train.total_acc_x  <- read.table(paste0(train.signal.dir,  "total_acc_x_train.txt", sep = " "))
# train.total_acc_y  <- read.table(paste0(train.signal.dir,  "total_acc_y_train.txt", sep = " "))
# train.total_acc_z  <- read.table(paste0(train.signal.dir,  "total_acc_z_train.txt", sep = " "))

# Combining the data --------------------------------------------------------------------------

subject     <- rbind(test.subject, train.subject)
x           <- rbind(test.x,       train.x)
y           <- rbind(test.y,       train.y)

colnames(subject) <- "Subject"
colnames(y) <- 'Activity.Num'
colnames(x) <- features$V2

df <- cbind(subject, y, x, index = seq(along = y$Activity.Num))

df <- merge(activity.names, df, by = 'Activity.Num', all = TRUE, sort = FALSE)
df <- df[order(df$index),]
df$Activity.Num <- NULL

rm(list = c('test.x', 'test.y', 'train.x', 'train.y', 'test.subject', 'train.subject',
            'subject', 'y', 'x', 'activity.names', 'test.dir', 'train.dir', 
            'test.signal.dir', 'train.signal.dir'))

## Removing all data in the 'x' part of 'df' that do not correspond to a mean or std deviation.
## We still keep the the activity name and subject number as part of the dataset
keep <- c(grep(pattern = 'mean', x = colnames(df)), 
          grep(pattern = 'std',  x = colnames(df)))

keep <- c(1, 2, keep[order(keep)])

df <- df[,keep]

## Calculates the average of each variable for each subject and activity type
require(dplyr)
df2 <- df %>%
      group_by(Activity.Name, Subject) %>%      # perform operations on each Activity + Subject
      summarise_each(funs(mean))                # summary function 

## write the summarized tidy data above to a txt file
write.table(df2, file = 'summarized_data.txt', row.names = FALSE)