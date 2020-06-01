---
title: "Peer-graded Assignment: Getting and Cleaning Data Course Project"


### Dataset
One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

You should create one R script called *run_analysis.R* that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Good luck!

<br/>

---

<br/>

# Here we go!

<br/>

### Preparation Stage

<br/>
Loading required packages
```{r}
library(dplyr)
```
<br/>
Download the dataset
```{r}
filename <- "Coursera_DS3_Final.zip"

# Checking if archieve already exists.
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename)
}  

# Checking if folder exists
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}
```
<br/>
Assigning all data frames
```{r}
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")

subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")
```

<br/>

### Let's start

> "You should create one R script called *run_analysis.R* that does the following:"

<br/>

**Step 1: Merges the training and the test sets to create one data set.**

```{r}
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)

Merged_Data <- cbind(Subject, Y, X)
```

<br/>

**Step 2: Extracts only the measurements on the mean and standard deviation for each measurement.**

```{r}
TidyData <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))
```

<br/>

**Step 3: Uses descriptive activity names to name the activities in the data set.**

```{r}
TidyData$code <- activities[TidyData$code, 2]
```

<br/>

**Step 4: Appropriately labels the data set with descriptive variable names.**

```{r}
names(TidyData)[2] = "activity"
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))
```

<br/>

**Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.**

```{r}
FinalData <- TidyData %>%
    group_by(subject, activity) %>%
    summarise_all(funs(mean))

write.table(FinalData, "FinalData.txt", row.name=FALSE)
```

<br/>

### Final Check Stage

<br/>
Checking variable names
```{r}
str(FinalData)
```

<br/>

Take a look at final data
```{r}
FinalData
```

<br/>

---

<br/>

# Submission

<br/>

### Code Book

<div style= "border: 5px dotted gray; padding: 10px 20px; background-color:#ededed; box-shadow: 0 1px 5px rgba(0, 0, 0, 0.25);">

The `run_analysis.R` script performs the data preparation and then followed by the 5 steps required as described in the course project's definition.

1. **Download the dataset**
    + Dataset downloaded and extracted under the folder called `UCI HAR Dataset`
    
    <br/>
2. **Assign each data to variables**
    + `features` <- `features.txt` : 561 rows, 2 columns <br/>
        *The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ.*
    + `activities` <- `activity_labels.txt` : 6 rows, 2 columns <br/>
        *List of activities performed when the corresponding measurements were taken and its codes (labels)*
    + `subject_test` <- `test/subject_test.txt` : 2947 rows, 1 column <br/>
        *contains test data of 9/30 volunteer test subjects being observed*
    + `x_test` <- `test/X_test.txt` : 2947 rows, 561 columns <br/>
        *contains recorded features test data*
    + `y_test` <- `test/y_test.txt` : 2947 rows, 1 columns <br/>
        *contains test data of activities'code labels*
    + `subject_train` <- `test/subject_train.txt` : 7352 rows, 1 column <br/>
        *contains train data of 21/30 volunteer subjects being observed*
    + `x_train` <- `test/X_train.txt` : 7352 rows, 561 columns <br/>
        *contains recorded features train data*
    + `y_train` <- `test/y_train.txt` : 7352 rows, 1 columns <br/>
        *contains train data of activities'code labels*
   
    <br/>
3. **Merges the training and the test sets to create one data set**
    + `X` (10299 rows, 561 columns) is created by merging `x_train` and `x_test` using **rbind()** function
    + `Y` (10299 rows, 1 column) is created by merging `y_train` and `y_test` using **rbind()** function
    + `Subject` (10299 rows, 1 column) is created by merging `subject_train` and `subject_test` using **rbind()** function
    + `Merged_Data` (10299 rows, 563 column) is created by merging `Subject`, `Y` and `X` using **cbind()** function
   
    <br/>
4. **Extracts only the measurements on the mean and standard deviation for each measurement**
    + `TidyData` (10299 rows, 88 columns) is created by subsetting `Merged_Data`, selecting only columns: `subject`, `code` and the measurements on the `mean` and *standard deviation* (`std`) for each measurement

    <br/>
5. **Uses descriptive activity names to name the activities in the data set**
    + Entire numbers in `code` column of the `TidyData` replaced with corresponding activity taken from second column of the `activities` variable

    <br/>
6. **Appropriately labels the data set with descriptive variable names**
    + `code` column in `TidyData` renamed into `activities`
    +  All `Acc` in column's name replaced by `Accelerometer`
    +  All `Gyro` in column's name replaced by `Gyroscope`
    +  All `BodyBody` in column's name replaced by `Body`
    +  All `Mag` in column's name replaced by `Magnitude`
    +  All start with character `f` in column's name replaced by `Frequency`
    +  All start with character `t` in column's name replaced by `Time`

    <br/>
7. **From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject**
    + `FinalData` (180 rows, 88 columns) is created by sumarizing `TidyData` taking the means of each variable for each activity and each subject, after groupped by subject and activity.
    + Export `FinalData` into `FinalData.txt` file.

</div>

<br/>

### README

<div style= "border: 5px dotted gray; padding: 10px 20px; background-color:#ededed; box-shadow: 0 1px 5px rgba(0, 0, 0, 0.25);">

#### Peer-graded Assignment: Getting and Cleaning Data Course Project

This repository is a **Nunno Nugroho** submission for Getting and Cleaning Data course project. It has the instructions on how to run analysis on Human Activity recognition dataset.

#### Dataset

[Human Activity Recognition Using Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

#### Files

* `CodeBook.md` a code book that describes the variables, the data, and any transformations or work that I performed to clean up the data

* `run_analysis.R` performs the data preparation and then followed by the 5 steps required as described in the course project's definition:
    + Merges the training and the test sets to create one data set.
    + Extracts only the measurements on the mean and standard deviation for each measurement.
    + Uses descriptive activity names to name the activities in the data set
    + Appropriately labels the data set with descriptive variable names.
    + From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
    
* `FinalData.txt` is the exported final data after going through all the sequences described above.


</div>

<br/>

### Review criteria

* The submitted data set is tidy.
<img src="https://cdn1.iconfinder.com/data/icons/interface-elements/32/accept-circle-512.png" alt="check" width="15px" heigth="15px"/>

* The Github repo contains the required scripts.
<img src="https://cdn1.iconfinder.com/data/icons/interface-elements/32/accept-circle-512.png" alt="check" width="15px" heigth="15px"/>

* GitHub contains a code book that modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information.
<img src="https://cdn1.iconfinder.com/data/icons/interface-elements/32/accept-circle-512.png" alt="check" width="15px" heigth="15px"/>

* The README that explains the analysis files is clear and understandable.
<img src="https://cdn1.iconfinder.com/data/icons/interface-elements/32/accept-circle-512.png" alt="check" width="15px" heigth="15px"/>

* The work submitted for this project is the work of the student who submitted it.
<img src="https://cdn1.iconfinder.com/data/icons/interface-elements/32/accept-circle-512.png" alt="check" width="15px" heigth="15px"/>

<br/>

---

<center>**END**</center>

---
