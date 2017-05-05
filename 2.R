Wdata<-subscriptions
library(lubridate)
Wdata$NumSD<-dmy_hms(Wdata$START_DATE,tz = "US/Eastern")
Wdata$NumED<-dmy_hms(Wdata$END_DATE,tz = "US/Eastern")
Copy<-Wdata
Wdata$START_DATE<-NULL
Wdata$END_DATE<-NULL
Wdata$BRAND<-NULL
Wdata$SUB_TERM<-NULL
Wdata$TRIAL_RETEN_SUCCESS_STAT<-as.character(Wdata$TRIAL_RETEN_SUCCESS_STAT)
library(data.table)
TWdata<-setcolorder(setDT(Wdata)[, c(NumED = max(NumED), lapply(.SD, min)), 
                                .SDcols = setdiff(names(Wdata), c("NumED", "SUBBLOCK_ID")),
                                by = SUBBLOCK_ID], names(Wdata))[]
TWdata$BRAND<-"AG"
TWdata$SUB_TERM<-"ANNUAL"
Mdata <- merge(TWdata,first_send,by="SUBSCRIPTION_ID")
Mdata$Active<-ifelse (Mdata$NumED>Sys.time(),1,0)
Mdata$Sub_Dur<-(Mdata$NumED-Mdata$NumSD)/86400
write.csv(Mdata,file = "Appended1.csv")

library(zoo)
Mdata$quarters <- as.yearqtr(Mdata$NumSD, format = "%Y-%m-%d")
Trial<-Mdata
Trial<-separate(Trial, NumSD, into = c("year", "month","date")) 
Trial$date<-NULL
Trial$NumSD<-Mdata$NumSD
Mdata<-Trial
device<-split(Mdata,Mdata$device)
mobiledata.df<-device[2]
dekstopdata<-device[1]

splityear2<-split(Mdata,list(Mdata$device,Mdata$year,Mdata$quarter))


Desktop2013 <- splityear2[seq(1, length(splityear2), 8)]
Desktop2014 <- splityear2[seq(3, length(splityear2), 8)]
Desktop2015 <- splityear2[seq(5, length(splityear2), 8)]
Desktop2016 <- splityear2[seq(7, length(splityear2), 8)]

Mobile2013 <- splityear2[seq(2, length(splityear2), 8)]
Mobile2014 <- splityear2[seq(4, length(splityear2), 8)]
Mobile2015 <- splityear2[seq(6, length(splityear2), 8)]
Mobile2016 <- splityear2[seq(8, length(splityear2), 8)]

m<-as.data.frame(Mobile2013)

list2013<-splityear1[c(1,5,9,13)]
list2014<-splityear1[c(2,6,10,14)]
list2015<-splityear1[c(3,7,11,15)]
list2016<-splityear1[c(4,8,12,16)]

for (i in seq_along(Mobile2013)) {
  filename = paste(names(Mobile2013)[i], ".csv")
  write.csv(data[[i]], filename)
}


qwe.df<-splityear[[1]]
splityearQ <- lapply(splityear, split(splityear,Mdata$quarter))

#splityear<-split(Mdata,Mdata$year)
#splitquarter<-split(Mdata,Mdata$quarter)
#splitdevice<-split(Mdata,Mdata$device)

#for (i in seq_along(splityear)) {
#  yearsplit = paste(i, ".csv")
 # write.csv(data[[i]], yearsplit)
#}


#GWdata <-ddply(Wdata, ~ SUBBLOCK_ID, summarize, StartD = min(NumSD),EndD=max(NumED),
               #firstID=min(SUBSCRIPTION_ID))
#TWdata <-ddply(Wdata, ~ SUBBLOCK_ID,summarize, StartD = min(NumSD),EndD=max(NumED),
               #SUBSCRIPTION_ID=min(SUBSCRIPTION_ID),
               #SUBBLOCK_START_YRMON=min(SUBBLOCK_START_YRMON))

#hool <-ddply(Wdata,~ SUBBLOCK_ID,"",summarize, StartD = min(NumSD),EndD=max(NumED),
#            while (NumSD == min(NumSD)){SUBSCRIPTION_ID=SUBSCRIPTION_ID
#  TRIAL_RETEN_SUCCESS_STAT=TRIAL_RETEN_SUCCESS_STAT
# SUBBLOCK_START_YRMON=SUBBLOCK_START_YRMON})#

