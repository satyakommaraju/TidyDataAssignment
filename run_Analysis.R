
library(plyr)


merge.trainandtestdatasets = function() {
  ##"Merge training and test datasets"
  
  ##Read data from the working directory where the unzipped dataset exists.
  ##build the file/directory location string removing all spaces.

  message("reading X_train.txt")
  X_train_File<-paste(getwd(),"/UCI HAR Dataset/train/X_train.txt")
  X_train_File<-str_replace_all(string=X_train_File, pattern=" ", repl="")
  training.x <- read.table(X_train_File)
  
  message("reading y_train.txt")
  y_train_File<-paste(getwd(),"/UCI HAR Dataset/train/y_train.txt")
  y_train_File<-str_replace_all(string=y_train_File, pattern=" ", repl="")
  training.y <- read.table(y_train_File)
  
  
  message("reading subject_train.txt")
  
  subject_train_File<-paste(getwd(),"/UCI HAR Dataset/train/subject_train.txt")
  subject_train_File<-str_replace_all(string=subject_train_File, pattern=" ", repl="")
  training.subject <- read.table(subject_train_File)
  
  message("reading X_test.txt")
  X_test_File <-paste(getwd(),"/UCI HAR Dataset/test/X_test.txt")
  X_test_File <-str_replace_all(string=X_test_File, pattern=" ", repl="")
  test.x <- read.table(X_test_File)
  
  message("reading y_test.txt")
  y_test_File<-paste(getwd(),"/UCI HAR Dataset/test/y_test.txt")
  y_test_File<-str_replace_all(string=y_test_File, pattern=" ", repl="")
  test.y <- read.table(y_test_File)
  
  message("reading subject_test.txt")
  
  subject_test_File<-paste(getwd(),"/UCI HAR Dataset/test/subject_test.txt")
  subject_test_File<-str_replace_all(string=subject_test_File, pattern=" ", repl="")
  test.subject <- read.table(subject_test_File)
  # Merge
  merged.x <- rbind(training.x, test.x)
  merged.y <- rbind(training.y, test.y)
  merged.subject <- rbind(training.subject, test.subject)
  # merge train and test datasets and return
 mydf<- list(x=merged.x, y=merged.y, subject=merged.subject)
}

extract.meanandstd = function(df) {
  # Extract only the measurements on the mean
  # and standard deviation for each measurement.
  
  # Read the feature list file
  features_File<-paste(getwd(),"/UCI HAR Dataset/features.txt")
  features_File<-str_replace_all(string=features_File, pattern=" ", repl="")
  features <- read.table(features_File)
  # Find the mean and std columns
  mean.col <- sapply(features[,2], function(x) grepl("mean()", x, fixed=T))
  std.col <- sapply(features[,2], function(x) grepl("std()", x, fixed=T))
  # Extract them from the data
  extracteddf <- df[, (mean.col | std.col)]
  colnames(extracteddf) <- features[(mean.col | std.col), 2]
  extracteddf
}

name.act = function(datf) {
  # Use descriptive activity names to name the activities in the dataset
  colnames(datf) <- "activity"
  datf$act[datf$act == 1] = "WALKING"
  datf$act[datf$act == 2] = "WALKING_UPSTAIRS"
  datf$act[datf$act == 3] = "WALKING_DOWNSTAIRS"
  datf$act[datf$act == 4] = "SITTING"
  datf$act[datf$act == 5] = "STANDING"
  datf$act[datf$act == 6] = "LAYING"
  datf
}

bind.dataxysubjects <- function(x, y, subjects) {
  # Combine mean-std values (x), activities (y) and subjects into one data
  # frame.
  cbind(x, y, subjects)
}

make.tidy.datset = function(dframe) {
  # Given X values, y values and subjects, create an independent tidy dataset
  # with the average of each variable for each activity and each subject.
  tidy <- ddply(dframe, .(subject, activity), function(x) colMeans(x[,1:60]))
  tidy
}

spruce.data = function() {
  ##Function that combines/calls the individual functions for 
  # merging,measuring,describing,cleaning and writing a tidy txt.file 
  #
  #Merge
  message("---Working on merging-----")
  mergedtt <- merge.trainandtestdatasets()
 
  # Extract only the measurements of the mean and standard deviation for each
  # measurement
  message("----working on measuring------")
  cx <- extract.meanandstd(mergedtt$x)
  # Name activities
  message("---working on activities------")
  cy <- name.act(mergedtt$y)
  # Use descriptive column name for subjects
  message("----working on describing columns-----")
  colnames(mergedtt$subject) <- c("subject")
  # Combine data frames into one
  message("---working on building dataframe------")
  combinedall <- bind.dataxysubjects(cx, cy, mergedtt$subject)
  # Create tidy dataset
  message("-----creating tidy set----")
  tidy <- make.tidy.datset(combinedall)
  # Write tidy dataset as txt
  message("---writing to text file------")
  write.table(tidy, "UCIHARSpruced3.txt", row.names=FALSE)
  
}

