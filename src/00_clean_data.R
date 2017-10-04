# make a cleaner data file

## load libraries ############
require(lubridate)


## load data ############
# na.strings: treat empty cells or "technische Störung" as NA
data2015Neutor <-
  read.csv("../data/raw/zaehlstelle_neutor_2015_stundenauswertung.csv",
           na.strings = c("technische Störung", ""))
data2016Neutor <-
  read.csv("../data/raw/zaehlstelle_neutor_2016_stundenauswertung.csv",
           na.strings = c("technische Störung", ""))
data2016Wolbecker <-
  read.csv("../data/raw/zaehlstelle_wolbecker_2016_stundenauswertung.csv",
           na.strings = c("technische Störung", ""))


## preprocess data ###########
# remove summary lines
data2015Neutor <- data2015Neutor[-nrow(data2015Neutor),]
# 2016Neutor files has two of those
data2016Neutor <- data2016Neutor[-nrow(data2016Neutor),]
data2016Neutor <- data2016Neutor[-nrow(data2016Neutor),]
# 2016Wolbecker has also two lines too much
data2016Wolbecker <- data2016Wolbecker[-nrow(data2016Wolbecker),]
data2016Wolbecker <- data2016Wolbecker[-nrow(data2016Wolbecker),]

# rename columns (and delete the old column)
data2015Neutor$noOfBikes <- data2015Neutor$Zählung.Neutor
data2015Neutor <- subset(data2015Neutor, select = -c(Zählung.Neutor))
data2016Neutor$noOfBikes <- data2016Neutor$Neutor..gesamt.
data2016Neutor <- subset(data2016Neutor, select = -c(Neutor..gesamt.))
data2016Wolbecker$noOfBikes <- data2016Wolbecker$Wolbecker.Straße..gesamt.
data2016Wolbecker <- subset(data2016Wolbecker, select = -c(Wolbecker.Straße..gesamt.))

# add column for location
data2015Neutor$location <- "neutor"
data2016Neutor$location <- "neutor"
data2016Wolbecker$location <- "wolbecker"

# no weather for 2015Neutor
data2015Neutor$Wetter <- NA

bikes <- rbind(data2015Neutor, data2016Neutor, data2016Wolbecker)

# rename more columns
bikes$temp <- bikes$Temperatur...C.
bikes <- subset(bikes, select = -c(Temperatur...C.))
bikes$wind <- bikes$Windstärke..km.h.
bikes <- subset(bikes, select = -c(Windstärke..km.h.))
bikes$weather <- bikes$Wetter
bikes <- subset(bikes, select = -c(Wetter))

# convert to proper date (could also be done by changing the format in
# LibreOffice Calc; anyway ...)

bikes$timestamp <- strptime(bikes$Stunden, format = "%m/%d/%Y %H:%M")
bikes$date <- lubridate::date(bikes$timestamp)
bikes$year <- year(bikes$date)
bikes$month <- month(bikes$date)
bikes$day <- day(bikes$date)
bikes$weekday <- wday(bikes$date, label = TRUE)
bikes$hour <- hour(bikes$date)

## feature generation ####
# log of wind speed (due to log-normal distribution)
bikes$wind_log <- log(bikes$wind)

## write processed data to file ####
write.csv(data2015Neutor,
          file = "../data/processed/bikesNeutor2015.csv",
          row.names = FALSE)
write.csv(data2016Neutor,
          file = "../data/processed/bikesNeutor2016.csv",
          row.names = FALSE)
write.csv(data2016Wolbecker,
          file = "../data/processed/bikesWolbecker2016.csv",
          row.names = FALSE)
write.csv(bikes,
          file = "../data/processed/bikes1516.csv",
          row.names = FALSE)
