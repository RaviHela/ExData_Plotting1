#read data from working directory, process dates and clean
hpc.df <-read.table("household_power_consumption.txt", header = TRUE, sep = ";", stringsAsFactors = FALSE)

#create DateTime variable
hpc.df$DateTime <- paste(hpc.df$Date, hpc.df$Time )
hpc.df$DateTime <- strptime(hpc.df$DateTime, "%d/%m/%Y %H:%M:%S")

#convert Date variable from char type to Date type
hpc.df$Date <- as.Date(hpc.df$Date, "%d/%m/%Y" )

#clean data of missing values and remove extra dates
hpc_sub_cleaned.df <- subset(hpc.df, Date %in% as.Date(c("2007-02-02", "2007-02-01"))& hpc.df1$Global_active_power != "?")

#plot1 histogram and print in PNG
png(file = "plot1.png", width = 480, height = 480, units = "px")

with(hpc_sub_cleaned.df,
     hist(as.numeric(Global_active_power), 
          main= "Global Active Power", 
          xlab = "Global Active Power (kilowattts)", col = "red"))

dev.off()

