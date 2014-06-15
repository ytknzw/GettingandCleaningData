#set working directory
setwd("./UCI HAR Dataset")
#read data
##features&activities
features <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt",col.names=c("No","Activity"))
##test data
X_test <- read.table("./test/X_test.txt")
names(X_test) <- features[[2]]#variable names
y_test <- read.table("./test/y_test.txt",col.names="Activity.No")
subject_test <- read.table("./test/subject_test.txt",col.names="Subject")
##train data
X_train <- read.table("./train/X_train.txt")
names(X_train) <- features[[2]]#variable names
y_train <- read.table("./train/y_train.txt",col.names="Activity.No")
subject_train <- read.table("./train/subject_train.txt",col.names="Subject")

#merge data sets
##test data
test <- cbind(subject_test,
              merge(y_test,activity_labels,by.x="Activity.No",by.y="No",All.x=TRUE,sort=FALSE),#put activity labels
              X_test)
##train data
train <- cbind(subject_train,
               merge(y_train,activity_labels,by.x="Activity.No",by.y="No",All.x=TRUE,sort=FALSE),#put activity labels
               X_train)

#tidy data 1
dat <- rbind(test,train)
tidy1 <- dat[,c(1:3,grep("(mean|std)\\(\\)",names(dat)))]#extract mean&std
##output
write.table(tidy1,"../tidy1.txt",row.names=FALSE)

#tidy data 2
temp <- data.frame(lapply(tidy1[,4:69],
                          function(x) aggregate(x,
                                                list(tidy1$Subject,tidy1$Activity.No,tidy1$Activity),
                                                mean)))#calc colmeans of tidy1 by Subject&Activity
tidy2 <- temp[,c(1:3,grep("x$",names(temp)))]#extract calculated value columns
names(tidy2) <- names(tidy1)
##output
write.table(tidy2,"../tidy2.txt",row.names=FALSE)
