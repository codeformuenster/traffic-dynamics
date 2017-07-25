## sorry for the mess, this is going to get better ...

data2015 = read.csv("zaehlstelle_neutor_2015_stundenauswertung.csv")
data2016 = read.csv("zaehlstelle_neutor_2016_stundenauswertung.csv")

# data2016 has different column names ... TODO
# data = rbind(data2015,data2016)

# remove last summary line
data2015 = data2015[-nrow(data2015),]

# convert to proper date (could also be done by changing the format in LibreOffice Calc; anyway ...)
data2015$date = strptime(data2015$Stunden, format = "%m/%d/%Y %H:%M")

library(lubridate)
# TODO for weekday:
# library(date)
# date.mdy(as.date("29/07/2017", order = "dmy"), weekday = TRUE)
data2015$month = month(data2015$date)
data2015$hour = hour(data2015$date)

# look at the data
p = ggplot(data = data2015) + geom_hist(aes(y = Zählung.Neutor))
p

# try to find a proper fitting distribution
library(fitdistrplus)
x = data2015$Zählung.Neutor
x = x[!is.na(x)]
descdist(x, discrete = FALSE)

## Bayesian regression model

library(brms)

# I have the feeling that exgaussian fits better -- but this should be checked ...
# hour seems to be not working correct -- gives a weird regression line ...

regressionModel_exgaussian = 
	brm(Zählung.Neutor ~ month * Temperatur...C. * Windstärke..km.h.,
			cores = 4,
			family = exgaussian,
			data = data2015)

regressionModel_lognormal = 
	brm(Zählung.Neutor ~ month, #hour * Temperatur...C. * Windstärke..km.h.,
			cores = 4,
			family = lognormal,
			data = data2015)

# poisson is totally wrong ...
