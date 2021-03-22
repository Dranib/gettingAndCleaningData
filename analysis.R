# this is the script for the assignment of the module getting and cleaning a dataset
#remove all elements from the environment
rm(list=ls())

#load packages

library(dplyr)
library(lubridate)
library(stringr)



# citation request by the authors of the data:
#
# "Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013."
#
# download data
#
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destfile <- "archive.zip"
path_zip<-"projectDS3.zip"
path_unzip_test <-"UCI HAR Dataset/test/"
path_unzip_train <-"UCI HAR Dataset/train/"
path_unzip_features <-"UCI HAR Dataset/"

download.file(  url,destfile,method="curl")


#unzip
# unzip(destfile, exdir = path)
unzip(destfile)

# define files to be loaded
files_person<-"subject_test.txt"
files_measures <- "X_test.txt"      #list.files(path = path_unzip_test)
files_acti <- "y_test.txt"      #list.files(path = path_unzip_test)

# load data for test
data_test_person<-read.table(paste(path_unzip_test,files_person,sep = ""))
data_test_measure<-read.table(paste(path_unzip_test,files_measures,sep = ""))
data_test_acti<-read.table(paste(path_unzip_test,files_acti,sep = ""))


# define files to load
files_person<-"subject_train.txt" #name of file diffrent from the test folder
files_measures <- "X_train.txt"      #list.files(path = path_unzip_test)
files_acti <- "y_train.txt"
# load data for train
data_train_person<-read.table(paste(path_unzip_train,files_person,sep = ""))
data_train_measure<-read.table(paste(path_unzip_train,files_measures,sep = ""))
data_train_acti<-read.table(paste(path_unzip_train,files_acti,sep = ""))


# create a vector of activity names
acti_names<-read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)
acit_names_vec<-acti_names[[2]]

# create a vector of features names
data_features<-read.table("./UCI HAR Dataset/features.txt")
data_features_names_vec<-data_features[[2]]#read.table(paste(path_unzip_features,files_features,sep = ""))



# # read data
# data_test<-read.table(paste(path_unzip_test,files_test,sep = ""))
# data_train<-read.table(paste(path_unzip_train,files_train,sep = ""))
# data_features<-read.table(paste(path_unzip_features,files_features,sep = ""))
# data_features_names<-data_features[[2]]#read.table(paste(path_unzip_features,files_features,sep = ""))
#


# merge data sets
data_merged_person<-rbind(data_train_person,data_train_person)
data_merged_measure<-rbind(data_train_measure,data_train_measure)
data_merged_acti<-rbind(data_train_acti,data_train_acti)
names(data_merged_person)<-"personID"
names(data_merged_measure)<-data_features_names_vec
names(data_merged_acti)<-"activity"

# select mean and std and take into account lower and uppser case
data_merged_measure_meanSTD <- str_detect(names(data_merged_measure), "[mM][eE][aA][nN]") | str_detect(names(data_merged_measure), "[sS][tT][dD]")
data_measures_select<-data_merged_measure[data_merged_measure_meanSTD]

#use explicit names for activities
data_merged_acti<-mutate(data_merged_acti, activity = acit_names_vec[activity])


# make the column names understandable for the measure data
colnames(data_measures_select) <- sub("^t", "time", colnames(data_measures_select))
colnames(data_measures_select) <- sub("^f", "frequence", colnames(data_measures_select))

data_total<-cbind(data_merged_person,data_merged_acti,data_measures_select)

#group the data by person and activity
data_total_group <- group_by(data_total, personID, activity)

#calculate the mean per group
data_total_group_summary <- summarize_all(data_total_group, mean)
write.table(data_total_group_summary, "new_data_set.txt", row.names = FALSE)

#clean up the workspace... a bit late
rm(list=ls())
