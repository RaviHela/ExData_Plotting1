#read data from working directory, process dates and clean
hpc.df <-read.table("household_power_consumption.txt", header = TRUE, sep = ";", stringsAsFactors = FALSE)

#create DateTime variable
hpc.df$DateTime <- paste(hpc.df$Date, hpc.df$Time )
hpc.df$DateTime <- strptime(hpc.df$DateTime, "%d/%m/%Y %H:%M:%S")

#convert Date variable from char type to Date type
hpc.df$Date <- as.Date(hpc.df$Date, "%d/%m/%Y" )

#clean data of missing values and remove extra dates
hpc_sub_cleaned.df <- subset(hpc.df, Date %in% as.Date(c("2007-02-02", "2007-02-01"))& hpc.df1$Global_active_power != "?")


png(file = "plot4.png", width = 480, height = 480, units = "px")

#set up multiplot frame and set margins
par(mfcol=c(2,2))
par(mar = c(4,4,1,1))

#plot global active power
with(hpc_sub_cleaned.df, 
     plot(x=(DateTime), 
          y= as.numeric(Global_active_power),
          type= "l", ylab = "Global Active Power", xlab=""
     )
)

#Subset relevant data and correct data type for plot Energy submetering
sub_meter <- subset(hpc_sub_cleaned.df,
                    select= c(DateTime,
                              Sub_metering_1,
                              Sub_metering_2,
                              Sub_metering_3
                    )
)

sub_meter[,2] <- as.numeric(sub_meter[,2])
sub_meter[,3] <- as.numeric(sub_meter[,3])
sub_meter[,4] <- as.numeric(sub_meter[,4])

#Restructure data for plotting
sub_meter <- melt(sub_meter, id= "DateTime")

#Plot the Energy submetering data
with(sub_meter, plot(x=DateTime, y=value, type = "n", ylab= "Energy sub metering", xlab =""))

with(subset(sub_meter, variable == "Sub_metering_1"),
     points(x=DateTime, y=value, type = "l" , col = "black"))

with(subset(sub_meter, variable == "Sub_metering_2"),
     points(x=DateTime, y=value, type = "l", col = "red"))

with(subset(sub_meter, variable == "Sub_metering_3"),
     points(x=DateTime, y=value, type = "l", col = "blue"))

legend("topright", lwd=1, 
       col = c("black", "red", "blue"),cex=0.5,
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
)



#plot voltage data
with(hpc_sub_cleaned.df, 
     plot(x=(DateTime), 
          y= as.numeric(Voltage),
          type= "l", ylab = "Voltage", xlab= "datetime"
     )
)


#plot global reactive power data
with(hpc_sub_cleaned.df, 
     plot(x=(DateTime), 
          y= as.numeric(Global_reactive_power),
          type= "l", ylab = "Global_reactive_power", xlab ="datetime"
     )
)

dev.off()
