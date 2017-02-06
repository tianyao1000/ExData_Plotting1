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

##load the data
content<-fread(filename,skip=skip_row_index,nrow=read_row_num)

## set the column names
colnames(content)<-column_names



##Convert to date class
date_time<-mapply(paste,content$Date,content$Time)
content$data_time<-dmy_hms(date_time,tz="America/los_angeles")


##plot the data
par(mfrow=c(1,1))
dimension<-480
png("Plot2.png",width=dimension,height=dimension)
plot(content$data_time,content$Global_active_power,type='l',xlab="",ylab = "Global Active_Power (kilowatts)")


dev.off()

