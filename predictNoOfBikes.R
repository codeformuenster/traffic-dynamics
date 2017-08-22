# set working directory to proper directory
# setwd("path/to/here")

bikes = read.csv("bikesNeutor1516.csv")
# ordered factors don't survice .csv storing, so, re-order weekdays:
bikes$weekday = factor(bikes$weekday, ordered = TRUE,
                       levels = c("Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat"))

# look at the data -> see plotData.R
# try to find a proper fitting distribution
library(fitdistrplus)
x = bikes$noOfBikes
x = x[!is.na(x)]
descdist(x, discrete = FALSE)

## Bayesian regression model

library(brms)

# I have the feeling that exgaussian fits better -- but this should be checked ...
# hour seems to be not working correct -- gives a weird regression line ...

bikes$hourC = scale(bikes$hour, center = TRUE, scale = FALSE)

summary(bikes[bikes$year == 2016,]$Wetter)

## have a look at update.brmsfit -> this might be quicker than re-computing all the time!

regressionModel_exgaussian_hours = 
	brm(noOfBikes ~ poly(hour,3), #  * Temperatur...C. * weekday, # Wetter + month + * Windstärke..km.h.,
			cores = 4,
			family = exgaussian,
			data = bikes[bikes$year == 2016, ])

regressionModel_exgaussian_temp = 
	brm(noOfBikes ~ poly(temp, 3), # * weekday, # Wetter + month + * Windstärke..km.h.,
			cores = 4,
			family = exgaussian,
			data = bikes[bikes$year == 2016 & !(is.na(bikes$temp)), ])

regressionModel_exgaussian_wday = 
	brm(noOfBikes ~ weekday, # Wetter + month + * Windstärke..km.h.,
			cores = 4,
			family = exgaussian,
			data = bikes[bikes$year == 2016, ])

regressionModel_exgaussian_wind = 
	brm(noOfBikes ~ poly(wind, 3), # poly is not needed -> the model converges to a straight line
			cores = 4,
			family = exgaussian,
			data = bikes[bikes$year == 2016 & !is.na(bikes$wind), ])


m = regressionModel_exgaussian_wind #temp #hours
pp_check(m)
plot(marginal_effects(m), points = T)#, jitter_width = 0.25)
plot(m)

y = bikes[bikes$year==2016,]$noOfBikes
launch_shiny(regressionModel_exgaussian)

regressionModel_lognormal = 
	brm(noOfBikes ~ hourC, #hour * Temperatur...C. * Windstärke..km.h.,
			cores = 4,
			family = lognormal,
			data = bikes[bikes$year == 2015 & bikes$month == 5, ])

# poisson is totally wrong ...
