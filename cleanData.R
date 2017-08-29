
library(lubridate)

# make a cleaner data file
# set working directory to proper directory
# setwd("path/to/here")

# na.strings: treat empty cells or "technische Störung" as NA
data2015 = read.csv("zaehlstelle_neutor_2015_stundenauswertung.csv", na.strings = c("technische Störung", ""))
data2016 = read.csv("zaehlstelle_neutor_2016_stundenauswertung.csv", na.strings = c("technische Störung", ""))

# remove summary lines
data2015 = data2015[-nrow(data2015),]
# 2016 files has two of those
data2016 = data2016[-nrow(data2016),]
data2016 = data2016[-nrow(data2016),]

# rename columns
data2015$noOfBikes = data2015$Zählung.Neutor
data2016$noOfBikes = data2016$Neutor..gesamt.

data2015 = subset(data2015, select = -c(Zählung.Neutor))
data2016 = subset(data2016, select = -c(Neutor..gesamt.))

# no weather for 2015
data2015$Wetter = NA

bikes = rbind(data2015, data2016)

# rename more columns
bikes$temp = bikes$Temperatur...C.
bikes = subset(bikes, select = -c(Temperatur...C.))
bikes$wind = bikes$Windstärke..km.h.
bikes = subset(bikes, select = -c(Windstärke..km.h.))

# convert to proper date (could also be done by changing the format in LibreOffice Calc; anyway ...)

bikes$date = strptime(bikes$Stunden, format = "%m/%d/%Y %H:%M")
bikes$year = year(bikes$date)
bikes$month = month(bikes$date)
bikes$day = day(bikes$date)
bikes$weekday = wday(bikes$date, label = TRUE)
bikes$hour = hour(bikes$date)


# remove double line in 2015 data set
bikes = bikes[!(bikes$year == 2015 & bikes$month==3 & bikes$day == 29 & bikes$hour == 3),]
any(is.na(bikes$noOfBikes))

nrow(bikes[(is.na(bikes$temp)),])


write.csv(data2015, file = "bikesNeutor2015.csv", row.names = FALSE)
write.csv(data2016, file = "bikesNeutor2016.csv", row.names = FALSE)
write.csv(bikes, file = "bikesNeutor1516.csv", row.names = FALSE)
