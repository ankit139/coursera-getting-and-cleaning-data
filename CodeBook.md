# CodeBook: Getting and Cleaning Data Course Project

This codebook describes the variables, the data, and transformations/work that
were performed to clean up the data using the script `run_analysis.R`.

## Best Coding Practice
In order to reduce the memory footprint of the script, I have decided to remove
large objects that will not be used further. If you intend to inspect these
large objects, please comment the code lines starting with:

    rm(...

## Download the Data Set
This step would download a zip file of size **~ 60 MB** and then unzip the
contents to a folder called `UCI HAR Dataset`. The script is capable of
detecting the system type you are running on and applying appropriate parameters
to download the files. This step might take some time based on your Internet
Speed, so please be patient!!

## Extracting Various Information From Different Files

### Features List

- Extract all 561 features selected for this database which come from the
accelerometer and gyroscope 3-axial raw signals. This data set is recorded in
`features.txt`. For more info on features, look into `features_info.txt`.
- `features` would be a table with 561 rows and 2 columns.

### Activities List

- Extract all the 6 activities: `WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS,`
`SITTING, STANDING, LAYING` performed by all 30 subjects wearing the Samsung
Galaxy S II smartphone on the waist. This data is recorded in 
`activity_labels.txt`.
- "activities" would be a table with 6 rows and 2 columns

### Observations

- The obtained data set has been randomly partitioned into two sets, where 70%
of the subjects were selected for generating the training data and 30% the
test data. In this data set, there are a total of 10,299 observations - 7,352
observations from training data, and 2,947 observations are from test data.

#### Observations on Different Features

- `train/X_train.txt` has the records for 7,352 observations (for different,
subject, activity combinations) for all the 561 features.
- `test/X_test.txt  ` has the records for 2,947 observations (for different,
subject, activity combinations) for all the 561 features.
    
- Read and combine the records for train and test data using `rbind()` into a
complete 10,299 observations (for different subject, activity combinations) for
all the 561 features.

    - `trainSet` would be a table with  7,352 rows and 561 columns.
    - `testSet` would be a table with  2,947 rows and 561 columns.
    - `combinedSet ` would be a table with 10,299 rows and 561 columns.

#### Observations on Different Activities

- `train/y_train.txt` has the records to identify 7,352 activities by different
subjects for the training observation.
- `test/y_test.txt` has the records to identify 2,947 activities by different
subjects for the test observation.

- Read and combine the records for train and test data using `rbind()` into a
complete set to identify 10,299 activities by different subjects for the
complete observation.

    - `trainLabels` would be a table with  7,352 rows and 1 column.
    - `testLabels` would be a table with  2,947 rows and 1 column.
    - `combinedLabels` would be a table with 10,299 rows and 1 column.

- The activity values range from 1 to 6.

#### Observations on Different Subjects

- `train/subject_train.txt` has the records to identify 7,352 subjects who
performed the activity for training observation.
- `test/subject_test.txt` has the records to identify 2,947 subjects who
performed the activity for test observation.

- Read and combine the records for train and test data using `rbind()` into a
complete set to identify 10,299 subjects who performed the activities for the
complete observation.

    - `trainSubject` would be a table with  7,352 rows and 1 column.
    - `testSubject` would be a table with  2,947 rows and 1 column.
    - `combinedSubject` would be a table with 10,299 rows and 1 column.

- The subject values range from 1 to 30.

## STEP 1: Merges the training and test sets to create one data set.

We have three data sets:

- `combinedSubject` Dataset to identify all subjects - 10299 rows, 1 column
- `combinedLabels` Dataset to identify all activities - 10299 rows, 1 column
- `combinedSet` Dataset to identify all observations - 10299 rows, 561 columns

Merge all the three data sets using `cbind()` to create one data set.
- `mergedData` would be a table with 10299 rows and 563 columns.

## STEP 2: Extracts only the measurements on the mean and standard deviation for each measurement.

Create a dataset `tidyData` by selecting only the columns `SubjectCode`,
`ActivityCode`, and the feature observations that have `mean` or `std` in it
from the `mergedData` created in Step 1 using `select()`

- `tidyData` is a table with 10299 rows and 88 columns.

## STEP 3: Uses descriptive activity names to name the activities in the data set.

The dataset `tidyData` has a column named `ActivityCode` and contains activity
codes ranging from values 1 to 6 instead of the descriptive activity names like
`WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING`.
`activities` has these descriptive names against the activity codes.

1. Replace the values in the `ActivityCode` column of `tidyData` with the
descriptive activity names instead of activity codes.
2. Rename the column `ActivityCode` in tidyData to `Activity` using `rename()`

## STEP 4: Appropriately labels the data set with descriptive variable names.

The `tidyData` contains columns with column names that came from the feature
names. These have cryptic names containing abbreviations, special characters
like "(", ")", ".", "-". E.g. tBodyAcc-mean()-X.

In order to make the variable names more descriptive and readable:

1. Retain the camel casing instead of making them all lower case:

    - `Substitute: from       to`
    - `|           "mean"     "Mean"`
    - `|           "std"      "Std"`
    - `|           "angle"    "Angle"`
    - `|           "gravity"  "Gravity"`

2. Replace the abbreviations with full descriptive words.

    - `Substitute: from       to`
    - `|           "Acc"      "Accelerometer"`
    - `|           "Gyro"     "Gyroscope"`
    - `|           "Mag"      "Magnitude"`
    - `|           "tBody"    "TimeBody"`
    - `|           "fBody"    "FrequencyBody"`

3. Replace the time domain signals (starting with t) and frequency domain
signals (starting with f) to denote the domain instead of 't' and 'f'.

    - `Substitute: from       to`
    - `|           "^t"       "Time"`
    - `|           "^f"       "Frequency"`

4. Remove special characters like '(', ')', or '.'.

    - `Substitute: from       to`
    - `|           "[()-.]"   ""`

5. Remove repeating words

    - `Substitute: from       to`
    - `|           "BodyBody" "Body"`

Create a substitution list with all the above policies and replace the names of
the variables in the `tidyData` using `gsub()`.

## STEP 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


The `tidyData` is first grouped by unique (SubjectCode, Activity) pairs using
`group_by()` giving 30 * 6 = 180 unique groups. For all other variables, the
mean is taken for each group and summarised using `summarise_all()` into
`tidyDataAverage`.

- `tidyDataAverage` is the independent tidy data set with 180 rows and 88 columns.

## Export Tidy Data to a File

Export `tidyDataAverage`, the second, independent tidy data set with the average
of each variable for each activity and each subject to a file called
`tidy_data.txt`

- The file has been exported as `.txt` file, to match the format that the original
data set had.
- The file name `tidy_data.txt` is chosen to match the file naming convention
followed in the original data set.
