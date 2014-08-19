This is a README.md markdown file for Project in Getting and Cleaning Data. 

We are asked to get the data on accelerometers from Samsung Galaxy S smartphone from

   https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

and then create one R script called run_analysis.R that does the following tasks:

1.  Merges the training and the test sets to create one data set.
2.  Extracts only the measurements on the mean and standard deviation for each measurement. 
3.  Uses descriptive activity names to name the activities in the data set
4.  Appropriately labels the data set with descriptive variable names. 
5.  Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

Step 1. Merge the training  and test data sets to create one data set.

## Read in X_test, y_test, subject_test data, X_train, y_train and subject_train etc
## Generate an id column for every data set in order to merge later with this common column
## Replace the names of columns by their proper feature names (descriptive names)
## Then do the same thing for the tainning data
nameTest<-read.table('./features.txt')
XTest<- data.frame(id=1:2947, read.table("./test/X_test.txt", col.names = nameTest[,2] ) )
XTrain<- data.frame(id=1:7352, read.table("./train/X_train.txt", col.names = nameTest[,2] ) )

labelTest<-data.frame(id=1:2947, read.table("./test/y_test.txt",col.names = "labels"))
subjectTest<-data.frame(id=1:2947, read.table("./test/subject_test.txt", col.names="subjects"))

labelTrain<-data.frame(id=1:7352, read.table("./train/y_train.txt",col.names = "labels"))
subjectTrain<-data.frame(id=1:7352, read.table("./train/subject_train.txt", col.names="subjects"))

## Then read in the data sets from  folder 'Inertial Signals' in both ' folders train' and 'test'
## Prepare the names for columns of the Inertial Signals
## Read the data from test/Inertial Signals/ folder
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
variablesExtracted <- vector()
chars1 <- "mean"
chars2 <- "std"
for (n in seq(along=allTest[1,])) {
    ##Extract the variables that contains 'mean' or 'std'
    if (grepl(chars1,names(allTest)[n]) | grepl(chars2, names(allTest)[n])) {
        variablesExtracted <- c(variablesExtracted, names(allTest)[n])
        
    }
    
}
# Extract the data with variables conatining 'mean' or 'std'
dataExtracted <- allData[,variablesExtracted]

Step 3. ### Replace the activity numbers with  descriptive names

## Augment the subjects and labels columns
dataExtractedAugmented <- allData[,c("subjects","labels", variablesExtracted)]
activityLabels <- read.table("./activity_labels.txt")
## Replace the activity numbers with descriptive names
for(k in seq(along=activityLabels[,1])) {
    dataExtractedAugmented$labels[dataExtractedAugmented$labels == activityLabels[k,1]] <- as.character(activityLabels[k,2])
}


Step 4. 
### Label the data set with descriptive variable names
for (k in 3:length(dataExtractedAugmented[1,]) ){
    names(dataExtractedAugmented)[k] <- paste("GroupMean_", names(dataExtractedAugmented)[k],sep="")
}

Step 5. 
generate a tidy data set with the average of each variable for each activity and each subject

## Generate the first 3 columns of 'subjects', 'labels' and 'tBodyAcc-mean()-X'
dataFinal <- aggregate(formula = dataExtractedAugmented[,3] ~ subjects + labels,
                       data = dataExtractedAugmented,
                       FUN = mean)
names(dataFinal)[3] <- "tBodyAcc.mean...X"

## Generate the rest means 
for (k in 4:length(dataExtractedAugmented[1,])) {
     dataOutput <- aggregate(formula = dataExtractedAugmented[,names(dataExtractedAugmented)[k]] ~ subjects + labels,
                            data = dataExtractedAugmented,
                            FUN = mean)
     names(dataOutput)[3] <- names(dataExtractedAugmented)[k]
     dataFinal <- merge(dataFinal,dataOutput, by=c("subjects","labels"))
     
 }
## Write the tidy data to a file
write.table(dataFinal,file="tidy_data_set.txt",sep="\t",row.names=FALSE, col.names=TRUE)


Step 6. Prepare the CodeBook.md
