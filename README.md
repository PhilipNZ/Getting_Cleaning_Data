This is a README.md markdown file for Project in Getting and Cleaning Data. 

We are asked to get the data on accelerometers from Samsung Galaxy S smartphone from

   https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

and then create one R script called run_analysis.R that does the following tasks:

1.  Merges the training and the test sets to create one data set.
2.  Extracts only the measurements on the mean and standard deviation for each measurement. 
3.  Uses descriptive activity names to name the activities in the data set
4.  Appropriately labels the data set with descriptive variable names. 
5.  Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 


The process I answer the above questions is as follows:

Step 1. Merge the training  and test data sets to create one data set.

 A) Read in X_test, y_test, subject_test data, X_train, y_train and subject_train etc
 Generate an id column for every data set in order to merge later with this common column
 Replace the names of columns by their proper feature names (descriptive names)
 Then do the same thing for the tainning data.

nameTest<-read.table('./features.txt')
XTest<- data.frame(id=1:2947, read.table("./test/X_test.txt", col.names = nameTest[,2] ) )
XTrain<- data.frame(id=1:7352, read.table("./train/X_train.txt", col.names = nameTest[,2] ) )

labelTest<-data.frame(id=1:2947, read.table("./test/y_test.txt",col.names = "labels"))
subjectTest<-data.frame(id=1:2947, read.table("./test/subject_test.txt", col.names="subjects"))

labelTrain<-data.frame(id=1:7352, read.table("./train/y_train.txt",col.names = "labels"))
subjectTrain<-data.frame(id=1:7352, read.table("./train/subject_train.txt", col.names="subjects"))

B)  Then read in the data sets from  folder 'Inertial Signals' in both  folders 'train' and 'test'.
 Because the data in each file has 128 columns, which is for one time
 window, so we need to prepare proper variable names for each column.
 See run_analysis.R for details of  the names for columns of files in Inertial Signals
 Then read the data from test/Inertial Signals/ folder
......
## Merge all data from test folder together

dfList = list(subjectTest, labelTest, XTest,totalxTest,totalyTest,totalzTest, bodyxTest, bodyyTest,bodyzTest, bodyGxTest, bodyGyTest, bodyGzTest)
allTest<-join_all(dfList)

## Merge all data from train folder together
dfList2 = list(subjectTrain, labelTrain, XTrain,totalxTrain,totalyTrain,totalzTrain, bodyxTrain, bodyyTrain,bodyzTrain, bodyGxTrain, bodyGyTrain, bodyGzTrain)
allTrain<-join_all(dfList2)

## Merge the test data and train data by 'rbind'
allData <- rbind(allTest, allTrain)

Step 2. 

### Extract only the measurements on the mean and standard deviation for each measurement
 I subset the variables containing either 'mean' or 'std' to obtain a
 character vector variableExtracted
 Then extract the data with variables conatining 'mean' or 'std'
dataExtracted <- allData[,variablesExtracted]

Step 3. ### Replace the activity numbers with  descriptive names

First read in the activity_label.txt file and then replace the activity
numbers with the corresponding descriptive names


Step 4. 
### Label the data set with descriptive variable names
Because the tidy data is derived as the group mean according to the
participant and activity, so I assign the name "GroupMean_"+ original
variable name to the corresponding variable.

Step 5. 
use function 'aggregate' to generate a tidy data set with the average of each variable for each activity and each subject
then wWrite the tidy data to a file


Step 6. Prepare  a simple version of  CodeBook.md
