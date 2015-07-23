X_test <- read.table("test/X_test.txt")
X_train <- read.table("train/X_train.txt")
y_test <- read.table("test/y_test.txt")
y_train <- read.table("train/y_train.txt")
subject_test <- read.table("test/subject_test.txt")
subject_train <- read.table("train/subject_train.txt")
#step 1
X <- rbind(X_train,X_test)
y <- rbind(y_train,y_test)
subject <- rbind(subject_train,subject_test)

#step 2
features <- read.table("features.txt")
features_mean_list <- which(grepl("mean()",features[,2],fixed=TRUE))
features_std_list <- which(grepl("std()",features[,2],fixed=TRUE))
features_mean <- X[,features_mean_list]
features_std <- X[,features_std_list]
features_mean_std <- cbind(features_mean,features_std)

#step 3
total <- cbind(subject,y,features_mean_std)
activity_mapping <- read.table("activity_labels.txt")
names(total)[2] <- "activity_id"
names(total)[1] <- "subject_id"
total_names <- merge(total,activity_mapping,by.x="activity_id",by.y="V1")

#step 4
names(total_names)[69] <- "activity_name"
names(total_names)[4] <- "V2"
names(total_names)[3:68] <- substr(names(total_names)[3:68],2,nchar(names(total_names[3:68])))
temp <- features[names(total_names)[3:68],2]
temp <- as.character(temp)
names(total_names)[3:68] <- temp
total_names <- total_names[,2:69]

#step 5
tidydata <- aggregate(total_names,by=list(total_names_2$subject_id,total_names_2$activity_name),FUN=mean)
names(tidydata)[2] <- "activity_name"
tidydata <- tidydata[,2:69]