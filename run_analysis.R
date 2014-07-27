##
## Text of assignment instructions follows
##
##    Merges the training and the test sets to create one data set.
##    Extracts only the measurements on the mean and standard deviation for each measurement. 
##    Uses descriptive activity names to name the activities in the data set
##    Appropriately labels the data set with descriptive variable names. 
##    Creates a second, independent tidy data set with the average of each 
##      variable for each activity and each subject. 

################################################################################
## Merge test and training into a single dataset
##
## 
##   Prepare data common to both test and training to be used below
##     
##     activity_labels
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt",col.names=c("activityId","activity"))
##     
##     features
featuresDF <- read.table("UCI HAR Dataset/features.txt")

##
## function to read and structure the data sets
readUCIdata <- function (yFile, xFile, subjectFile) {
  ##      Read yFile (rows say the activity during which corresponding row in 
  ##      xFile was collected). 
  y_ <- read.table(yFile,col.names="activityId")
  ##
  ##      Read xFile (rows are feature vectors for the activity, so assign 
  ##      col.names appropriate during the read then clean them up a bit).
  x_ <- read.table(xFile,col.names=featuresDF$V2)
  ##      Cleanup - replace the "..." inserted to replace secial characters
  ##         with a single "." changes "()-" from txt file to "." effectively
  colnames(x_)<-gsub("[.][.][.]",".",colnames(x_))
  ##      Cleanup - remove the ".." inserted to replace "()" from txt file with
  ##        "" as they are meaningless here.
  colnames(x_)<-gsub("[.][.]","",colnames(x_))  
  ##
  ##      Read subjectFile (rows are subject id for the activity in the 
  ##      corresponding row of xFile. 
  subject_ <- read.table(subjectFile,col.names="subjectId")
  ##
  ##      Combine subject_, y_, and x_ to produce a data frame with
  ##      rows corresponding to (subject, activity_id, feature vector), that is, a
  ##      single observation
  observations <- cbind(subject_, y_, x_);
  
  ##
  ##      trainslate activity ids originally from y_train into meaningful 
  ##      activity labels using data from activity_labels.txt.
  observations <- merge(activity_labels,observations,by.x="activityId",by.y="activityId")
}

##   Starting with training data
##
training_obs <- readUCIdata(
  "UCI HAR Dataset/train/Y_train.txt", 
  "UCI HAR Dataset/train/X_train.txt", 
  "UCI HAR Dataset/train/subject_train.txt")

##   then read testing data
##
testing_obs <- readUCIdata(
  "UCI HAR Dataset/test/Y_test.txt", 
  "UCI HAR Dataset/test/X_test.txt", 
  "UCI HAR Dataset/test/subject_test.txt")

##   Combining into a single set of observations
##
observations<-rbind(training_obs,testing_obs)

################################################################################
## Extract only the measurements on the mean and standard deviation for each 
## measurement.
##
## These are the columns with feature names containing "mean" or "std".  Note 
## the columns conctaining "meanFreq" are _not_ to be included, hence the "[^F]"
## in the grep expression.
## Include 2 and 3 in the select vector to pick up the activity name and subject
## id (respectively).
pattern<-"mean[^F]|mean$|std"
meansAndStds <- subset(observations, select=c(2,3,grep(pattern,colnames(observations))))

################################################################################
##    Uses descriptive activity names to name the activities in the data set
## This is satisfied by merging activity_labels.txt with the observation frame 
## earlier in this script. Specifically, this line from earlier in this script
##
##    observations <- merge(activity_labels,observations,by.x="activityId",by.y="activityId")
##
## adds the descriptive name as the eventual column 2.

################################################################################
##    Appropriately labels the data set with descriptive variable names. 
## This is satisfied by using the features.txt rows for column names when reading
## the X_* files. Column (variable) names correspond to the feature names for the
## measurements they represent. Specifically, this line from earlier in this 
## script
##
##      x_ <- read.table(xFile,col.names=featuresDF$V2)
##
## adds the descriptive variables names for columns, which are then cleaned 
## slightly in the following lines.

################################################################################
##    Creates a second, independent tidy data set with the average of each 
##      variable for each activity and each subject. 
##
## Assuming this builds on the previous step, (consistent with the discussion 
## here: https://class.coursera.org/getdata-005/forum/thread?thread_id=23 )
## the variables to be averaged are those means and standard deviations from the
## data frame I have called "observations"
##
## contruct the dataset using ddply from plyr to calculate the colMeans for each
## column for each unique combination of subjectId and activity. The outpur is a
## dataframe with columns 
## 1 - subjectId
## 2 - activity (descriptive name)
## 3:68 - corresponding to the columns from meansAndStds constructed above
##
require( plyr )
tidyDataSet <- ddply(meansAndStds,.(subjectId,activity),function(df) 
    colMeans(subset(df,select=3:ncol(df))))
  
##
## Write the dataset in a form that can be submitted to coursera (.txt).
## to read and recreate this, use the following:
##
##   tidyDataSet<-read.table("./tidyDataSet.txt",header=TRUE,sep=" ")
##
write.table(tidyDataSet,"./tidyDataSet.txt",row.names=FALSE)


