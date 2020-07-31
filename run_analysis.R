################################################################################
##
## Script Name: run_analysis.R
##
## Data Set:
##     Human Activity Recognition Using Smartphones Dataset
##     Version 1.0
##     <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>
##
## Dataset Summary:
##     The experiments have been carried out with a group of 30 volunteers
##     within an age bracket of 19-48 years. Each person performed six
##     activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING,
##     STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist
##     using its embedded accelerometer and gyroscope.
##
##     The obtained dataset has been randomly partitioned into two sets, where
##     70% of the volunteers was selected for generating the training data and
##     30% the test data.
##
## Dataset License:
##     Use of this dataset in publications must be acknowledged by referencing
##     the following publication [1] 
##
##         [1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and
##             Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones
##             using a Multiclass Hardware-Friendly Support Vector Machine.
##             International Workshop of Ambient Assisted Living (IWAAL 2012).
##             Vitoria-Gasteiz, Spain. Dec 2012
##
##     This dataset is distributed AS-IS and no responsibility implied or
##     explicit can be addressed to the authors or their institutions for its
##     use or misuse. Any commercial use is prohibited.
##
##     Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita.
##     November 2012.
## 
## Description:
##     This script does all the heavy lifting of reading and collecting the data
##     from the training and test sets and performs the following steps as
##     required by the course project.
##
##         STEP 1. Merging the training and the test sets to create one data set.
##         STEP 2. Extracting only the measurements on the mean and standard
##                 deviation for each measurement.
##         STEP 3. Using descriptive activity names to name the activities in
##                 the data set.
##         STEP 4. Appropriately labeling the data set with descriptive variable
##                 names.
##         STEP 5. From the data set in step 4, creating a second, independent
##                 tidy data set with the average of each variable for each 
##                 activity and each subject.
##
## Best Coding Practice:
##     In order to reduce the memory footprint of the script, I have decided to
##     remove large objects that will not be used further. If you intend to
##     inspect these large objects, please comment the code lines starting with:
##         rm(...
##
################################################################################
##
################################################################################

################################################################################
##
## Load the required library
##
################################################################################
library(dplyr)

################################################################################
##
## DOWNLOAD the data set from the "Human Activity Recognition Using Smartphones".
##
## This step would download a zip file of size ~ 60 MB and then unzip the
## contents to a folder called "UCI HAR Dataset".
##
## The script is capable of detecting the system type you are running on and
## apply appropriate parameters to download the files.
##
## This step might take some time based on your Internet Speed, so please be
## patient!!
##
################################################################################
dataFolder <- "UCI HAR Dataset"
if(!file.exists(dataFolder)) {
    fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    if(Sys.info()["sysname"] == "Windows") {
        download.file(fileUrl, destfile = "./UCI HAR Dataset.zip",
                      mode = "wb")
    } else {
        download.file(fileUrl, destfile = "./UCI HAR Dataset.zip",
                      method = "curl")
    }
    unzip("./UCI HAR Dataset.zip")    
}

################################################################################
##
## Extract all 561 features selected for this database which come from the
## accelerometer and gyroscope 3-axial raw signals. This data set is recorded in
## "features.txt". For more info on features, look into "features_info.txt".
##
## "features" would be a table with 561 rows and 2 columns.
##
################################################################################
features <- read.table(file.path(dataFolder, "features.txt"),
                       col.names = c("FeatureCode", "Feature"))

################################################################################
##
## Extract all the 6 activities: WALKING,
##                               WALKING_UPSTAIRS,
##                               WALKING_DOWNSTAIRS,
##                               SITTING,
##                               STANDING,
##                               LAYING
## performed by all 30 subjects wearing the Samsung Galaxy S II smartphone on
## the waist. This data is recorded in activity_labels.txt.
##
## "activities" would be a table with 6 rows and 2 columns
##
################################################################################
activities <- read.table(file.path(dataFolder, "activity_labels.txt"),
                             col.names = c("ActivityCode", "Activity"))

################################################################################
##
## The obtained data set has been randomly partitioned into two sets, where 70%
## of the subjects were selected for generating the training data and 30% the
## test data. In this data set, there are a total of 10,299 observations - 
## 7,352 observations from training data, and 2,947 observations are from test
## data.
##
## "train/X_train.txt" has the records for 7,352 observations (for different,
##                     subject, activity combinations) for all the 561 features.
## "test/X_test.txt"   has the records for 2,947 observations (for different,
##                     subject, activity combinations) for all the 561 features.
##
## Read and COMBINE the records for train and test data into a complete 10,299
## observations (for different subject, activity combinations) for all the 561
## features.
##
## "trainSet"    would be a table with  7,352 rows and 561 columns.
## "testSet"     would be a table with  2,947 rows and 561 columns.
## "combinedSet" would be a table with 10,299 rows and 561 columns.
##
################################################################################
trainSet <- read.table(file.path(dataFolder, "train", "X_train.txt"),
                       col.names = features$Feature)
testSet  <- read.table(file.path(dataFolder, "test", "X_test.txt"),
                       col.names = features$Feature)
combinedSet <- rbind(trainSet, testSet)
rm(trainSet, testSet, features)

################################################################################
##
## "train/y_train.txt" has the records to identify 7,352 activities by different
##                     subjects for the training observation.
## "test/y_test.txt"   has the records to identify 2,947 activities by different
##                     subjects for the test observation.
##
## Read and COMBINE the records for train and test data into a complete set to
## identify 10,299 activities by different subjects for the complete observation.
##
## "trainLabels"    would be a table with  7,352 rows and 1 column.
## "testLabels"     would be a table with  2,947 rows and 1 column.
## "combinedLabels" would be a table with 10,299 rows and 1 column.
##
## The activity values range from 1 to 6.
##
################################################################################
trainLabels <- read.table(file.path(dataFolder, "train", "y_train.txt"),
                          col.names = "ActivityCode")
testLabels  <- read.table(file.path(dataFolder, "test", "y_test.txt"),
                          col.names = "ActivityCode")
combinedLabels <- rbind(trainLabels, testLabels)
rm(trainLabels, testLabels)


################################################################################
##
## "train/subject_train.txt" has the records to identify 7,352 subjects who
##                           performed the activity for training observation.
## "test/subject_test.txt"   has the records to identify 2,947 subjects who
##                           performed the activity for test observation.
##
## Read and COMBINE the records for train and test data into a complete set to
## identify 10,299 subjects who performed the activities for the complete
## observation.
##
## "trainSubject"    would be a table with  7,352 rows and 1 column.
## "testSubject"     would be a table with  2,947 rows and 1 column.
## "combinedSubject" would be a table with 10,299 rows and 1 column.
##
## The subject values range from 1 to 30.
##
################################################################################
trainSubject <- read.table(file.path(dataFolder, "train", "subject_train.txt"),
                           col.names = "SubjectCode")
testSubject  <- read.table(file.path(dataFolder, "test", "subject_test.txt"),
                           col.names = "SubjectCode")
combinedSubject <- rbind(trainSubject, testSubject)
rm(trainSubject, testSubject)


################################################################################
##
## STEP 1: Merges the training and test sets to create one data set.
##
## Merge all the data sets:
##      "subject" Dataset to identify all subjects     - 10299 X   1
##      "labels"  Dataset to identify all activities   - 10299 X   1
##      "set"     Dataset to identify all observations - 10299 X 561
##
## "mergedData" would be a table with 10299 rows and 563 columns.
##
################################################################################
mergedData <- cbind(combinedSubject, combinedLabels, combinedSet)
rm(combinedSubject, combinedLabels, combinedSet)

################################################################################
##
## STEP 2: Extracts only the measurements on the mean and standard deviation for
##         each measurement.
##
## Create a dataset "tidyData" by selecting only the columns - SubjectCode,
## ActivityCode, and the feature observations that have "mean" or "std" in it
## from the mergedData created in Step 1.
##
## "tidyData" is a table with 10299 rows and 88 columns.
##
################################################################################
tidyData <-
    mergedData %>%
        select(SubjectCode, ActivityCode, contains("mean"), contains("std"))
rm(mergedData)

################################################################################
##
## STEP 3: Uses descriptive activity names to name the activities in the data
##         set.
##
## The dataset "tidyData" has a column named "ActivityCode" and contains
## activity codes ranging from values 1 to 6 instead of the descriptive activity
## names like WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING,
## and LAYING.
##
## "activities" has these descriptive names against the activity codes.
##     1. Replace the values in the "ActivityCode" column of "tidyData" with
##        the descriptive activity names instead of activity codes.
##     2. Rename the column "ActivityCode" in tidyData to "Activity"
##
################################################################################
tidyData$ActivityCode <- activities[tidyData$ActivityCode, "Activity"]
tidyData <- rename(tidyData, Activity = ActivityCode)
rm(activities)

################################################################################
##
## STEP 4: Appropriately labels the data set with descriptive variable names.
##
## The "tidyData" contains columns with column names that came from the feature
## names. These have cryptic names containing abbreviations, special characters
## like "()", ".", "-". E.g. tBodyAcc-mean()-X.
##
## In order to make the variable names more descriptive and readable:
##     1. Retain the camel casing instead of making them all lower case:
##        Substitute: from       to
##                    "mean"     "Mean"         
##                    "std"      "Std"          
##                    "angle"    "Angle"        
##                    "gravity"  "Gravity" 
##     2. Replace the abbreviations with full descriptive words.
##        Substitute: from       to
##                    "Acc"      "Accelerometer"
##                    "Gyro"     "Gyroscope" 
##                    "Mag"      "Magnitude" 
##                    "tBody"    "TimeBody"     
##                    "fBody"    "FrequencyBody"
##     3. Replace the time domain signals (starting with t) and frequency domain
##        signals (starting with f) to denote the domain instead of 't' and 'f'.
##        Substitute: from       to
##                    "^t"       "Time"         
##                    "^f"       "Frequency"
##     4. Remove special characters like '(', ')', or '.'.
##        Substitute: from       to
##                    "[()-.]"   ""
##
##     5. Remove repeating words.
##        Substitute: from       to
##                    "BodyBody"       "Body"
##
## Create a substitution list with all the above policies and replace the names
## of the variables in the "tidyData" using gsub().
##
################################################################################
subsList <- rbind(c("mean",     "Mean"),
                  c("std",      "Std"),
                  c("angle",    "Angle"),
                  c("gravity",  "Gravity"),
                  c("Acc",      "Accelerometer"),
                  c("Gyro",     "Gyroscope"),
                  c("Mag",      "Magnitude"),
                  c("tBody",    "TimeBody"),
                  c("fBody",    "FrequencyBody"),
                  c("^t",       "Time"),
                  c("^f",       "Frequency"),
                  c("[()-.]",   ""),
                  c("BodyBody", "Body"))
colnames(subsList) <- c("from", "to")
for(i in 1:nrow(subsList)) {
    names(tidyData) <- gsub(subsList[i, "from"], subsList[i, "to"],
                            names(tidyData))
}

################################################################################
##
## STEP 5: From the data set in step 4, creates a second, independent tidy data
##         set with the average of each variable for each activity and each
##         subject.
##
## The "tidyData" is first grouped by unique (SubjectCode, Activity) pairs
## giving 30 * 6 = 180 unique groups. For all other variables, the mean is taken
## for each group and summarised into "tidyDataAverage".
##
## "tidyDataAverage" is the independent tidy data set with 180 rows and 88
##                   columns.
##
################################################################################
tidyDataAverage <-
    tidyData %>%
        group_by(SubjectCode, Activity) %>%
        summarise_all(mean)

################################################################################
##
## Export "tidyDataAverage", the second, independent tidy data set with the
## average of each variable for each activity and each subject to a file called
## "tidy_data.txt"
##
## The file has been been exported to a ".txt" file, to match the format that
## the original data set had.
##
## The file name "tidy_data.txt" is chosen to match the file naming convention
## followed in the original data set.
##
################################################################################
write.table(tidyDataAverage, "tidy_data.txt", row.names = FALSE)
