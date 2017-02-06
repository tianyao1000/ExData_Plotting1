rm(list = ls())
library(data.table)
library(lubridate)
library(ggplot2)
filename<-"household_power_consumption.txt"
date<-fread(filename,select = c(1))
date<-date$Date
date<-dmy(date)

##Get column names
column_names<-colnames(fread(filename,nrows=1))

# The assumption is the data is listed in
#chronological order
## get two dates in order to extract the contents from date1 to date2
date1<-ymd("2007-02-01")
date2<-ymd("2007-02-03")
skip_row_index<-min(which(date==date1))
last_row_index<-min(which(date==date2))
read_row_num<-last_row_index-skip_row_index 

## load the data
content<-fread(filename,skip=skip_row_index,nrow=read_row_num)

colnames(content)<-column_names


##Convert to date class
date_time<-mapply(paste,content$Date,content$Time)
content$data_time<-dmy_hms(date_time,tz="America/los_angeles")

## plot the data

dimension<-480
png("Plot4.png",width=dimension,height=dimension)
par(mfrow=c(2,2))
plot(content$data_time,content$Global_active_power,type='l',,xlab="",ylab = "Global Active_Power (kilowatts)")

plot(content$data_time,content$Voltage,type='l',xlab="datetime",ylab = "Voltage")

plot(content$data_time,content$Sub_metering_1,type='n',col="black",xlab="", ylab = "Energy sub metering")
lines(content$data_time,content$Sub_metering_1,type='l',col="black")
lines(content$data_time,content$Sub_metering_2,type='l',col="red")
lines(content$data_time,content$Sub_metering_3,type='l',col="blue")
legend("topright", legend=c("sub_metering_1","sub_metering_2","sub_metering_3"),
       col=c("black", "red","blue"), lty=c(1,1,1), cex=0.5)

plot(content$data_time,content$Global_reactive_power,type='l',xlab="datetime",ylab = "Global_reactive_power")

dev.off()



