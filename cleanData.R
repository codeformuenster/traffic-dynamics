# make a cleaner data file

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

data = rbind(data2015, data2016)

# convert to proper date (could also be done by changing the format in LibreOffice Calc; anyway ...)
data$date = strptime(data$Stunden, format = "%m/%d/%Y %H:%M")

library(lubridate)
data$year = year(data$date)
data$month = month(data$date)
data$day = day(data$date)
data$weekday = wday(data$date, label = TRUE)
data$hour = hour(data$date)

write.csv(data2015, file = "bikesNeutor2015.csv", row.names = FALSE)
write.csv(data2016, file = "bikesNeutor2016.csv", row.names = FALSE)
write.csv(data, file = "bikesNeutor1516.csv", row.names = FALSE)
