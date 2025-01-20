#install lubridate if not already installed
if(!require("lubridate")) install.packages("lubridate")

#load lubridate
library(lubridate)

#read in household_power_consumption.txt file into data frame called hpc
hpc <- read.table("household_power_consumption.txt", header=TRUE, sep=";")

#subset only dates "1/2/2007" and "2/2/2007" and free unused memory
subset1 <- subset(hpc, Date == "1/2/2007")
subset2 <- subset(hpc, Date == "2/2/2007")
hpc <- rbind(subset1, subset2)
subset1 <- NULL
subset2 <- NULL
gc()

#reclassify Date variable (currently character class) to Date class
hpc$Date <- as.Date(hpc$Date, format = "%d/%m/%Y")

#Add a Date/Time columnn (DateTime) as column 1
DateTime <- data.frame(DateTime = ymd_hms(paste(as.character(hpc$Date), hpc$Time)))
hpc <- cbind(DateTime,hpc)

#Make measurement values numeric
hpc[,4:9] <- as.numeric(unlist(hpc[,4:9]))

#Plot objects containing the Thu, Fri, Sat time points
xmed <- median(hpc$DateTime)
xmax <- max(hpc$DateTime)
xmin <- min(hpc$DateTime)



png(filename = "plot4.png", width = 480, heigh = 480, units = "px")

par(mfcol = c(2,2))

#plot1
plot(x = hpc$DateTime,y = hpc$Global_active_power, 
ylab = "Global Active Power (kilowatts)", xlab = "", xaxt = "n", type="l")
axis(side = 1, at = c(xmin,xmed,xmax), labels = c("Thu", "Fri", "Sat"),)

#plot2
plot(x = hpc$DateTime,y = hpc$Sub_metering_1, ylab = "Energy sub metering", type = "l",
     col = "black", xlab = "", xaxt = "n")
points(x = hpc$DateTime, y = hpc$Sub_metering_2, type = "l", col = "red")
points(x = hpc$DateTime, y = hpc$Sub_metering_3, type = "l", col = "blue")
axis(side = 1, at = c(xmin,xmed,xmax), labels = c("Thu", "Fri", "Sat"),)
legend("topright", lty = "solid", col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

#plot3
plot(x = hpc$DateTime, y = hpc$Voltage, ylab = "Voltage", type = "l",
     xlab = "datetime", xaxt = "n")
axis(side = 1, at = c(xmin,xmed,xmax), labels = c("Thu", "Fri", "Sat"),)

#plot4
plot(x = hpc$DateTime, y = hpc$Global_reactive_power, ylab = "Global_reactive_power", type = "l",
     xlab = "datetime", xaxt = "n")
axis(side = 1, at = c(xmin,xmed,xmax), labels = c("Thu", "Fri", "Sat"),)

dev.off()