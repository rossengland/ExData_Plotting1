

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

#Plot histogram of Global Active Power and save to png file
png(filename = "plot1.png", width = 480, heigh = 480, units = "px")
hist(x = hpc$Global_active_power, main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)", col = "red", breaks = 15, yaxt = "n", cex.axis = 0.65)
axis(side = 2, at = seq(0,1200,by=200), labels = c("0","200","400","600","800","1000","1200"), cex.axis = 0.65)
dev.off()