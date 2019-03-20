

    setwd("C:/Users/parkjeongah/Desktop/working/UCI HAR Dataset/")
    
    
    features = read.table("./features.txt")
    activityLabel = read.table("./activity_labels.txt")    
    subjectTrain = read.table("./train/subject_train.txt")
    xTrain = read.table("./train/X_train.txt")    
    yTrain = read.table("./train/y_train.txt")    
    
    colnames(activityLabel) = c("activityId","activityType")
    colnames(subjectTrain) = "subId"    
    colnames(xTrain) = features[,2]    
    colnames(yTrain) = "activityId"  
    
    trainData = cbind(yTrain, subjectTrain,xTrain)
    
    
    
    subjectTest = read.table("./test/subject_test.txt")    
    xTest = read.table("./test/X_test.txt")
    yTest = read.table("./test/y_test.txt")
    
    colnames(subjectTest) = "subId"
    colnames(xTest) = features[,2]
    colnames(yTest) = "activityId"
    
    testData = cbind(yTest, subjectTest, xTest)
    
    
    
    # 1. Merge the train and test data.
    
    finalData = rbind(trainData, testData)
    colNames = colnames(finalData)    
    
    
    #2. Extract only the measurements on the mean and standard deviation for each measurement
    
    mean.std <-finalData[,grepl("mean|std|subject|activityId",colnames(finalData))]
    
    #3. Uses descriptive activity names to name the activities in the data set
    
    library(plyr)
    mean.data = join(mean.std , activityLabel, by="activityId", match="first")    
    mean.data = mean.data[,-1]
    
    
    
    #4. Appropriately labels the data set with descriptive variable names
    
    names(data_mean_std) = make.names(names(mean.std))
    names(mean.std) = gsub("Acc","Acceleration", names(mean.std))
    names(mean.std) = gsub("^t", "Time", names(mean.std))
    names(mean.std) = gsub("^f", "Frequency", names(mean.std))
    names(mean.std) = gsub("BodyBody", "Body", names(mean.std))
    names(mean.std) = gsub("mean", "Mean", names(mean.std))
    names(mean.std) = gsub("std", "Std", names(mean.std))
    names(mean.std) = gsub("Freq", "Frequency", names(mean.std))
    names(mean.std) = gsub("Mag", "Magnitutde", names(mean.std))
    
    tidydata_avergae_sub <- ddply(mean.std,c("subject","activityId"),numcolwise(mean))
   write.table (tidydata_avergae_sub, file="tidydata.txt" )
    