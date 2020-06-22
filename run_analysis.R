if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")

unzip(zipfile="./data/Dataset.zip",exdir="./data")
path_rf <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)
files

s3  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
t3 <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)

t1 <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
s1  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)

s2  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
t2 <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)


str(s3)
str(t3)
str(s2)
str(t2)
str(s1)
str(t1)

subject=rbind(t1,s1)
x=rbind(t2,s2)
y=rbind(t3,s3)

names(subject)<-c("subject")
names(y)<- c("activity")
xnames <-read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(x)<- xnames$V2

combine <- cbind(subject, y)
data <- cbind(x, combine)

subfeature<-xnames$V2[grep("mean\\(\\)|std\\(\\)", xnames$V2)]

selectednames<-c(as.character(subfeature), "subject", "activity" )
data<-subset(data,select=selectednames)
str(data)

activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)
data$activity=activityLabels[data$activity,2]
head(data$activity,30)

names(data)<-gsub("^t", "time", names(data))
names(data)<-gsub("^f", "frequency", names(data))
names(data)<-gsub("Acc", "Accelerometer", names(data))
names(data)<-gsub("Gyro", "Gyroscope", names(data))
names(data)<-gsub("Mag", "Magnitude", names(data))
names(data)<-gsub("BodyBody", "Body", names(data))
names(data)

library(plyr)
data2<-aggregate(. ~subject + activity, data, mean)
data2<-data2[order(data2$subject,data2$activity),]
write.table(data2, file = "tidydata.txt",row.name=FALSE)

