#set directory to location of dataset
setwd('/Users/dylan/Desktop/UCI HAR Dataset/')
#list.files(getwd())

##import colnames for data
data_colnames <- readLines('features.txt')
#clean numbering
data_colnames<- gsub('^.+ ','',data_colnames)
##import activity names for data 
activity_names <- readLines('activity_labels.txt')
#clean numbering 
activity_names <- gsub('^.+ ','',activity_names)

#read x_test
x_test <- read.table('test/X_test.txt')
#add colnames to x_test
colnames(x_test) <- data_colnames
#select only mean and std
x_test <- x_test[,grep('mean|std',names(x_test))]
x_test <- x_test[,-grep('meanFreq',names(x_test))]

y_test <- readLines('test/y_test.txt')
sub_test <- readLines('test/subject_test.txt')
#
#bind data into a dataframe
test_data <- cbind(data.frame(subject = sub_test,excercise_id = y_test, activity = ""),x_test)


#read x_train
x_train <- read.table('train/X_train.txt')
#add colnames to x_train
colnames(x_train) <- data_colnames
#select only mean and std
x_train <- x_train[,grep('mean|std',names(x_train))]
x_train <- x_train[,-grep('meanFreq',names(x_train))]
y_train <- readLines('train/y_train.txt')
sub_train <- readLines('train/subject_train.txt')
#
#bind data into a dataframe
train_data <- cbind(data.frame(subject = sub_train,excercise_id = y_train,activity = ""),x_train)


################################
#combind train and test datasets
train_test_data <- rbind(train_data,test_data)
train_test_data$excercise_id <- as.character(train_test_data$excercise_id)
train_test_data$activity <- as.character(train_test_data$activity)
#add activity names
train_test_data$activity[train_test_data$excercise_id == 1] <- activity_names[1]
train_test_data$activity[train_test_data$excercise_id == 2] <- activity_names[2]
train_test_data$activity[train_test_data$excercise_id == 3] <- activity_names[3]
train_test_data$activity[train_test_data$excercise_id == 4] <- activity_names[4]
train_test_data$activity[train_test_data$excercise_id == 5] <- activity_names[5]
train_test_data$activity[train_test_data$excercise_id == 6] <- activity_names[6]
#remove parens from colnames
names(train_test_data) <- gsub(pattern = '\\(|\\)','',names(train_test_data))
library(plyr)
#summarise columns using ddply
independent_summary <- ddply(train_test_data,.variables = c("subject","activity"), numcolwise(mean))
colnames(independent_summary)[3:68] <- paste0("mean of ",colnames(independent_summary)[3:68])
#write 
write.table(independent_summary,row.names= FALSE,file = "independent_summary.txt")


