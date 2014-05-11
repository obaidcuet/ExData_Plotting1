
## plot2.R
## R Script for plot#2 of Course Project 1
## It has a seperate function to load data which could be in sperate file
## For simplicity of evaluation the function is placed same in the same script
## full script can be run using "source" command as below:
## source("<path to the script>/plot2.R") 


## function "readData()" to read data 
## it reads data for '1/2/2007' & '2/2/2007'
## and converts all the fields with appropriate data types
## retruns the data frame containing the requited data

readData <- function() {
		library(sqldf) # needed for "read.csv.sql()"
        
        # create a subset for the target 2 dates and store it in a new file
        # Here we are using "read.csv.sql()" which allows us to do easy 
        # subset using sql syntax
        subSetData <- read.csv.sql("household_power_consumption.txt", sep=";", 
                                   header=T, colClasses = "character",
                                   sql="select * from file where Date in ('1/2/2007','2/2/2007')")
        
        write.csv(subSetData, file="subSetData.txt", row.names = FALSE, quote=F)
        rm(subSetData) # cleanup memory
        
        # determine the classes of the fileds using sample size of 50
        sampleData <- read.csv("household_power_consumption.txt", sep=";" ,
                               na.strings="?", header=T, nrows= 50)
        classes <- sapply(sampleData, class)
        rm(sampleData) # cleanup memory
        
        # Read from the subset file using the "colClasses = classes"
        # "classes" is a charracter vector created in tha last step 
        data <- read.csv("subSetData.txt", sep="," ,na.strings="?", 
                         header=T, colClasses = classes)
        
        # convert the date and time column
        data$Time <- strptime(paste(data$Date, data$Time),'%d/%m/%Y %H:%M:%S')
        data$Date <- as.Date(data$Date,'%d/%m/%Y')
        
        # return the prepared data frame
        data
}
## end of function "readData()" 


# load the data using the function create above
data <- data <- readData()

# plot it as png
png(filename = "plot2.png", width = 480, height = 480)

plot(data$Time, data$Global_active_power, type="l", 
     ylab ="Global Active Power (kilowatts)", xlab = "")
	 
# close the PNG device
dev.off()
