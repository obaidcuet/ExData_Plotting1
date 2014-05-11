## plot4.R
## R Script for plot#4 of Course Project 1
## It has a seperate function to load data which could be in sperate file
## For simplicity of evaluation the function is placed same in the same script
## full script can be run using "source" command as below:
## source("<path to the script>/plot4.R") 


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
png(filename = "plot4.png", width = 480, height = 480)

par(mfrow = c(2, 2), mar=c(4,4,2,1), oma = c(0, 0, 2, 2), ps=12)
with(data, {
        # 1st plot "Global Active Power"
        plot(data$Time, data$Global_active_power, type="l", 
             ylab ="Global Active Power", xlab = "")
        
        # 2nd plot "Voltage"
        plot(data$Time, data$Voltage, type="l", 
             ylab ="Voltage", xlab = "datetime")
        
        # 3rd plot "Energy sub metering"
        plot(Time, Sub_metering_1, type="l", xlab = "", ylab = "Energy sub metering")
        points(Time, Sub_metering_2, type="l", col = "red")
        points(Time, Sub_metering_3, type="l", col = "blue")
        legend("topright", lty=c(1,1,1), col = c("black", "red", "blue"), bty="n",
               legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
               y.intersp=0.75)
        
        # 4th plot "Global_reactive_power"
        plot(data$Time, data$Global_reactive_power, type="l", 
             ylab ="Global_reactive_power", xlab = "datetime")                		
})

# close the PNG device
dev.off()
