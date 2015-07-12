## This R script will produce a simple histogram graph according to Coursera
## Exploratory Data Analysis Peer Assignment 1. The goal is to examine data
## from 1/2/2007 to 2/2/2007 (dd/mm/yyyy format)

# Cleaning Global Environment
rm(list=ls())

# Loading appropriate libraries
library(data.table)
library(sqldf)
library(dplyr)

# To download a file from URL
# file URL is from
# https://archive.ics.uci.edu/ml/datasets/Individual+household+electric+power+consumption
fileurl <- "https://d396qusza40orc.cloudfront.net/exdata/data/household_power_consumption.zip"
# extract base name of file from url e.g. myfile.csv
filesaved <- basename(fileurl)

# Only download file if file does not exist
if(!file.exists(filesaved))
        {download.file(fileurl,destfile=filesaved,mode="wb")}

# Unzip the file, does not overwrite if file exists
unzip(filesaved, overwrite = FALSE)
filelist <- unzip(filesaved, list = TRUE) #list name of file names in zip
filename <- as.character(filelist["Name"]) #Name of unzipped file

# Read file into dataset
dataset <- read.csv2(filename,colClasses="character",na.strings="?")
# Select only data from 1/2/2007 or 2/2/2007
selectdata <- sqldf("select * from dataset where Date IN ('1/2/2007','2/2/2007')")

# Convert columns 3 to 9 to numeric values from character classes
for (i in seq(3,9)) {
        selectdata[,i]<-as.numeric(selectdata[,i])
}

## Saving Plot1 as PNG file with 480x480 pixels (standard)
png("plot1.png")
hist(selectdata[,3], col="red",
     xlab="Global Active Power (kilowatts)",
     main="Global Active Power")
dev.off()
