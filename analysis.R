library(dplyr)
library(lubridate)


# download data
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destfile <- "archive.zip"
path_zip<-"projectDS3.zip"
path_unzip_test <-"UCI HAR Dataset/test/"       #"UCI HAR Dataset/test/Inertial Signals/"
path_unzip_train <-"UCI HAR Dataset/train/"      # "UCI HAR Dataset/train/Inertial Signals/"
path_unzip_features <-"UCI HAR Dataset/"      # "UCI HAR Dataset/train/Inertial Signals/"

download.file(  url,destfile,method="curl")

#extract from the zip


library(purrr)





# download zip
# curl::curl_download(url, destfile = paste(path_zip, destfile, sep = "/"))

#unzip
# unzip(destfile, exdir = path)
unzip(destfile)

# list  file
files_test <- "X_test.txt"      #list.files(path = path_unzip_test)
files_train <- "X_train.txt"      #list.files(path = path_unzip_train)
files_features<-"features.txt"

# apply map_df() to iterate read_csv over files
# data_test<-sapply(files_test,function(x)read.table(paste(path_unzip_test,x,sep = "")))
# read data
data_test<-read.table(paste(path_unzip_test,files_test,sep = ""))
data_train<-read.table(paste(path_unzip_train,files_train,sep = ""))
data_features<-read.table(paste(path_unzip_features,files_features,sep = ""))
data_features_names<-data_features[[2]]#read.table(paste(path_unzip_features,files_features,sep = ""))

# merge data
data_merged<-rbind(data_test,data_train)
#change columns names
names(data_merged)<-data_features_names

# select only column with "mean" or "std" in the name
vector_mean_std_position<-which(grepl("mean", names(data_merged), fixed = TRUE) |  grepl("std", names(data_merged), fixed = TRUE))

data_seleted<-select(data_merged,names(data_merged)[vector_mean_std_position])


summary(data_merged)


