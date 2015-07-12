## This R script will produce a simple histogram graph according to Coursera
## Exploratory Data Analysis Peer Assignment 1. The goal is to examine data
## from 1/2/2007 to 2/2/2007 (dd/mm/yyyy format)

# Cleaning Global Environment
rm(list=ls())

# Loading appropriate libraries
library(data.table)
library(sqldf)
library(dplyr)
library(lubridate)

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

## Converting two columns of date and time data to single column
selectdata$Date<-strptime(selectdata$Date, "%d/%m/%Y ")
selectdata <- within(selectdata, {datetime=as.POSIXct(paste(Date,Time))})

## Saving plot4 as PNG file with 480x480 pixels (standard)
png("plot4.png")

mypar <- par(mfcol=c(2,2), mar=c(4,4,3,1),oma=c(1,0,1,0))
with(selectdata, {
        # Plot Set #1 - Plotting the Global Active Power vs. datetime
        plot(selectdata$datetime, selectdata[,3], pch=20, type="l", xlab="",
             ylab="Global Active Power (kilowatts)")

        # Plot Set #2
        # Plotting Sub_metering_1 with default black line
        plot(selectdata$datetime, selectdata[, 7], type="l", xlab="",
             ylab="Energy sub metering")
        # Plotting Sub_metering_2 with red lines
        points(selectdata$datetime, selectdata[, 8], type="l", col="red")
        # Plotting Sub_metering_3 with blue lines
        points(selectdata$datetime, selectdata[, 9], type="l", col="blue")
        # Inserting 3 legends with respective colours
        legname <-c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3") 
        legcol <- c("black","red", "blue") 
        legend("topright", legend=legname,col=legcol,lwd = 1)
        
        # Plot 3 - Plotting Voltage vs. datetie
        plot(selectdata$datetime, selectdata$Voltage, type="l",
             xlab="datetime", ylab="Voltage")
        
        # Plot 4 - Plotting Global_reactive_power vs. datetime
        plot(selectdata$datetime, selectdata$Global_reactive_power,
             type="l", xlab="datetime", ylab="Global_reactive_power")
        
})

# Close file device
dev.off()
