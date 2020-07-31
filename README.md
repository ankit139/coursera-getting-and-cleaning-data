## Getting and Cleaning Data Course Project

One of the most exciting areas in all of data science right now is wearable
computing. Companies like Fitbit, Nike, and Jawbone Up are racing to develop the
most advanced algorithms to attract new users.

The purpose of this project is to collect and clean the raw data collected from
the accelerometers of the Samsung Galaxy S smartphone. The output is a tidy data
set which could be potentially used for further analysis and research.

## Data Set
[Human Activity Recognition Using Smartphones Version 1](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

## Dataset Summary
The experiments have been carried out with a group of 30 volunteers within an
age bracket of 19-48 years. Each person performed six activities (WALKING,
WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a
smartphone (Samsung Galaxy S II) on the waist using its embedded accelerometer
and gyroscope.

The obtained dataset has been randomly partitioned into two sets, where 70% of
the volunteers was selected for generating the training data and 30% the test
data.

## License
Use of this dataset in publications must be acknowledged by referencing the
following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L.
Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass
Hardware-Friendly Support Vector Machine. International Workshop of Ambient
Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can
be addressed to the authors or their institutions for its use or misuse. Any
commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.

## Files

- `CodeBook.md` describes the variables, the data, and any transformations or
work that was performed to clean up the data.
- `run_analysis.R` is the script that does all the heavylifting of reading and
collecting the data from the training and test sets and performs the following
steps as required by the course project.
    1. Merging the training and the test sets to create one data set.
    2. Extracting only the measurements on the mean and standard deviation for
    each measurement.
    3. Using descriptive activity names to name the activities in the data set
    4. Appropriately labeling the data set with descriptive varialbe names.
    5. From the data set in step 4, creating a second, independent tidy data set
    with the average of each variable for each activity and each subject.
- `tidy_data.txt` is the tidy data set that was arrived to by processing the raw
dataset by the `run_analysis.R` script exported to a file.
