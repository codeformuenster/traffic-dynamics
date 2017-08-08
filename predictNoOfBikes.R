data = read.csv("bikesNeutor1516.csv")

# look at the data
library(ggplot2)
data$year = as.factor(data$year)
p = ggplot() +
	geom_histogram(data = data[data$year == 2015 & data$month == 5 & data$weekday == 4, ], aes(x = noOfBikes, fill = year), alpha = 0.5) #+
	#geom_histogram(data = data[data$year==2016, ], aes(x = noOfBikes, fill = year), alpha = 0.5)
p

# try to find a proper fitting distribution
library(fitdistrplus)
x = data$noOfBikes
x = x[!is.na(x)]
descdist(x, discrete = FALSE)

## Bayesian regression model

library(brms)

# I have the feeling that exgaussian fits better -- but this should be checked ...
# hour seems to be not working correct -- gives a weird regression line ...

data$hourC = scale(data$hour, center = TRUE, scale = FALSE)

summary(data[data$year == 2016,]$Wetter)

## have a look at update.brmsfit -> this might be quicker than re-computing all the time!

regressionModel_exgaussian = 
	brm(noOfBikes ~ poly(hour,3) * Temperatur...C. * weekday, # Wetter + month + * Windstärke..km.h.,
			cores = 4,
			family = exgaussian,
			data = data[data$year == 2016, ])

pp_check(regressionModel_exgaussian)
plot(marginal_effects(regressionModel_exgaussian), points = T, jitter_width = 0.25)

y = data[data$year==2016,]$noOfBikes
launch_shiny(regressionModel_exgaussian)


regressionModel_lognormal = 
	brm(noOfBikes ~ hourC, #hour * Temperatur...C. * Windstärke..km.h.,
			cores = 4,
			family = lognormal,
			data = data[data$year == 2015 & data$month == 5, ])

# poisson is totally wrong ...
