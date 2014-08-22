#Project for Getting and Cleaning data

### Part I: Merge the training data and the test data to create one data set
require(plyr)
## Read in X_test data and y_test subject_test data
## Generate an id column in order to merge with this common column
## Replace the names of columns by their proper feature names (descriptive names)
## Then do the same thing for the tainning data
nameTest<-read.table('./features.txt')
XTest<- data.frame(id=1:2947, read.table("./test/X_test.txt", col.names = nameTest[,2] ) )
XTrain<- data.frame(id=1:7352, read.table("./train/X_train.txt", col.names = nameTest[,2] ) )
#Check
head(XTest,n=1)


labelTest<-data.frame(id=1:2947, read.table("./test/y_test.txt",col.names = "labels"))
subjectTest<-data.frame(id=1:2947, read.table("./test/subject_test.txt", col.names="subjects"))

labelTrain<-data.frame(id=1:7352, read.table("./train/y_train.txt",col.names = "labels"))
subjectTrain<-data.frame(id=1:7352, read.table("./train/subject_train.txt", col.names="subjects"))

## Prepare the names for columns of the Inertial Signals
totalx<-vector()
totaly<-vector()
totalz<-vector()
bodyx<-vector()
bodyy<-vector()
bodyz<-vector()
bodyGx<-vector()
bodyGy<-vector()
bodyGz<-vector()

for (n in 1:128) {
        totalx[n]<- paste("total_acc_x_", as.character(n), sep="")
        totaly[n]<- paste("total_acc_y_", as.character(n), sep="")
        totalz[n]<- paste("total_acc_z_", as.character(n), sep="")
        bodyx[n]<- paste("body_acc_x_", as.character(n), sep="")
        bodyy[n]<- paste("body_acc_y_", as.character(n), sep="")
        bodyz[n]<- paste("body_acc_z_", as.character(n), sep="")
        bodyGx[n]<- paste("body_gyro_x_", as.character(n), sep="")
        bodyGy[n]<- paste("body_gyro_y_", as.character(n), sep="")
        bodyGz[n]<- paste("body_gyro_z_", as.character(n), sep="")
}

## Read the data from test/Inertial Signals/ folder
totalxTest<- data.frame(id=1:2947, read.table("./test//Inertial Signals/total_acc_x_test.txt", col.names = totalx))
totalyTest<- data.frame(id=1:2947, read.table("./test//Inertial Signals/total_acc_y_test.txt", col.names = totaly))
totalzTest<- data.frame(id=1:2947, read.table("./test//Inertial Signals/total_acc_z_test.txt", col.names = totalz))

bodyxTest <-data.frame(id=1:2947, read.table("./test//Inertial Signals/body_acc_x_test.txt", col.names = bodyx))
bodyyTest <-data.frame(id=1:2947, read.table("./test//Inertial Signals/body_acc_y_test.txt", col.names = bodyy))
bodyzTest <-data.frame(id=1:2947, read.table("./test//Inertial Signals/body_acc_z_test.txt", col.names = bodyz))

bodyGxTest <-data.frame(id=1:2947, read.table("./test//Inertial Signals/body_gyro_x_test.txt", col.names = bodyGx))
bodyGyTest <-data.frame(id=1:2947, read.table("./test//Inertial Signals/body_gyro_y_test.txt", col.names = bodyGy))
bodyGzTest <-data.frame(id=1:2947, read.table("./test//Inertial Signals/body_gyro_z_test.txt", col.names = bodyGz))

## Do the same thing for the taining data
totalxTrain<- data.frame(id=1:7352, read.table("./train//Inertial Signals/total_acc_x_train.txt", col.names = totalx))
totalyTrain<- data.frame(id=1:7352, read.table("./train//Inertial Signals/total_acc_y_train.txt", col.names = totaly))
totalzTrain<- data.frame(id=1:7352, read.table("./train//Inertial Signals/total_acc_z_train.txt", col.names = totalz))

bodyxTrain <-data.frame(id=1:7352, read.table("./train//Inertial Signals/body_acc_x_train.txt", col.names = bodyx))
bodyyTrain <-data.frame(id=1:7352, read.table("./train//Inertial Signals/body_acc_y_train.txt", col.names = bodyy))
bodyzTrain <-data.frame(id=1:7352, read.table("./train//Inertial Signals/body_acc_z_train.txt", col.names = bodyz))

bodyGxTrain <-data.frame(id=1:7352, read.table("./train//Inertial Signals/body_gyro_x_train.txt", col.names = bodyGx))
bodyGyTrain <-data.frame(id=1:7352, read.table("./train//Inertial Signals/body_gyro_y_train.txt", col.names = bodyGy))
bodyGzTrain <-data.frame(id=1:7352, read.table("./train//Inertial Signals/body_gyro_z_train.txt", col.names = bodyGz))

## Merge all data from test folder together

dfList = list(subjectTest, labelTest, XTest,totalxTest,totalyTest,totalzTest, bodyxTest, bodyyTest,bodyzTest, bodyGxTest, bodyGyTest, bodyGzTest)
allTest<-join_all(dfList)

## Merge all data from train folder together
dfList2 = list(subjectTrain, labelTrain, XTrain,totalxTrain,totalyTrain,totalzTrain, bodyxTrain, bodyyTrain,bodyzTrain, bodyGxTrain, bodyGyTrain, bodyGzTrain)
allTrain<-join_all(dfList2)

## Merge the test data and train data by 'rbind'
allData <- rbind(allTest, allTrain)

### Part II
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
head(dataExtracted,n=1)

### Part III
### Replace the activity numbers with  descriptive names

## Augment the subjects and labels columns
dataExtractedAugmented <- allData[,c("subjects","labels", variablesExtracted)]
activityLabels <- read.table("./activity_labels.txt")
## Replace the activity numbers with descriptive names
for(k in seq(along=activityLabels[,1])) {
    dataExtractedAugmented$labels[dataExtractedAugmented$labels == activityLabels[k,1]] <- as.character(activityLabels[k,2])
}
# Check
str(dataExtractedAugmented)

### Part IV
### Label the data set with descriptive variable names
for (k in 3:length(dataExtractedAugmented[1,]) ){
    names(dataExtractedAugmented)[k] <- paste("GroupMean_", names(dataExtractedAugmented)[k],sep="")
}


### Part V: generate a tidy data set with the average of each variable for each activity and each subject

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

## Generate a simple codebook for 'tidy_data_set.txt'
codebook <- matrix( , nrow=length(dataFinal[1,]), ncol=5)
## Assigning directly the columns names for the codebook seems not working well,
## so assign the variable namse as its first row
codebook[1,] <-c("Variable Name","Type","Meaning","Range of Variable","Unit")
#the first two variables
codebook[2,] <- c("subjects", "Integer", "volunter/participant", " 1 ~ 30 ","1")
codebook[3,] <- c("activity", "Character", "labels of activity","WALKING, LAYING, STANDING, SITTING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS"," ")
#For the rest of variables
for (k in 4:length(dataFinal[1,]) ) {
    codebook[k,1]  <- names(dataFinal)[k]
    codebook[k,2]  <- "Numeric"
    codebook[k,3] <- paste("Group mean of '", substring(names(dataFinal)[k],11), "' according to subject and activity", sep="")
    codebook[k,4] <- "[-1,1]"
    if (grepl("Acc", names(dataFinal)[k] )) {
        codebook[k,5] <- "g"
        print(codebook[k,5])
    } else 
    {
      codebook[k,5] <-""
   
}
}
## Use the write.fwf from package 'gdata' to write file 'CodeBook.md'
require(gdata)
write.fwf(as.data.frame(codebook),file="CodeBook.md",width=c(41,20,81,72,11), colnames=FALSE,quote=FALSE, justify="left")

