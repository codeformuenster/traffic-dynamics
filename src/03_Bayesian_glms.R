# set working directory to proper directory
# setwd("path/to/here")

if(require(brms) == FALSE){
  install.packages("brms")
}

# load data
bikes = read.csv("../data/processed/bikes1516.csv")

# ordered factors don't survive .csv storing, so, re-order weekdays:
bikes$weekday = factor(bikes$weekday, 
                       ordered = TRUE,
                       levels = c("Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat"))

# look at the data -> see 02_plot_data.R

## Bayesian regression models

# I have the feeling that exgaussian fits better -- but this should be checked ...
# hour seems to be not working correct -- gives a weird regression line ...

# TODO: do proper scaling of predictors
# bikes$hourC = scale(bikes$hour, center = TRUE, scale = FALSE)

## TODO have a look at update.brmsfit -> this might be quicker than re-computing all the time!

#### exgaussian ####

regressionModel_exgaussian_hours = 
	brm(noOfBikes ~ poly(hour,3),
			cores = 4,
			family = exgaussian,
			data = bikes)

regressionModel_exgaussian_temp = 
	brm(noOfBikes ~ poly(temp, 3),
			cores = 4,
			family = exgaussian,
			data = bikes[!(is.na(bikes$temp)), ]) # TODO fix this before fitting the model ...

regressionModel_exgaussian_wday = 
	brm(noOfBikes ~ weekday,
			cores = 4,
			family = exgaussian,
			data = bikes)

regressionModel_exgaussian_wind = 
	brm(noOfBikes ~ wind, # poly is not needed -> the model converges to a straight line
			cores = 4,
			family = exgaussian,
			data = bikes[!is.na(bikes$wind), ])  # TODO fix this before fitting the model ...

regressionModel_exgaussian_weather = 
	brm(noOfBikes ~ weather,
			cores = 4,
			family = exgaussian,
			data = bikes)

regressionModel_exgaussian_month = 
	brm(noOfBikes ~ month,
			cores = 4,
			family = exgaussian,
			data = bikes)

regressionModel_exgaussian_year = 
	brm(noOfBikes ~ year,
			cores = 4,
			family = exgaussian,
			data = bikes)

regressionModel_exgaussian_location = 
	brm(noOfBikes ~ location,
			cores = 4,
			family = exgaussian,
			data = bikes)

regressionModel_exgaussian_all = 
	brm(noOfBikes ~ hours * temp * wday * wind * weather * month * year * location,
			cores = 4,
			family = exgaussian,
			data = bikes)

save(regressionModel_exgaussian_hours, 
     regressionModel_exgaussian_temp, 
     regressionModel_exgaussian_wday, 
     regressionModel_exgaussian_wind, 
     regressionModel_exgaussian_weather,
     regressionModel_exgaussian_month,
     regressionModel_exgaussian_year,
     regressionModel_exgaussian_location,
     regressionModel_exgaussian_all,
     file = "exgaussian_models.RData")

#### negbinomial ####

regressionModel_negbinom_hours = 
	brm(noOfBikes ~ poly(hour,3),
			cores = 4,
			family = negbinom,
			data = bikes)

regressionModel_negbinom_temp = 
	brm(noOfBikes ~ poly(temp, 3),
			cores = 4,
			family = negbinom,
			data = bikes[!(is.na(bikes$temp)), ]) # TODO fix this before fitting the model ...

regressionModel_negbinom_wday = 
	brm(noOfBikes ~ weekday,
			cores = 4,
			family = negbinom,
			data = bikes)

regressionModel_negbinom_wind = 
	brm(noOfBikes ~ wind, # poly is not needed -> the model converges to a straight line
			cores = 4,
			family = negbinom,
			data = bikes[!is.na(bikes$wind), ])  # TODO fix this before fitting the model ...

regressionModel_negbinom_weather = 
	brm(noOfBikes ~ weather,
			cores = 4,
			family = negbinom,
			data = bikes)

regressionModel_negbinom_month = 
	brm(noOfBikes ~ month,
			cores = 4,
			family = negbinom,
			data = bikes)

regressionModel_negbinom_year = 
	brm(noOfBikes ~ year,
			cores = 4,
			family = negbinom,
			data = bikes)

regressionModel_negbinom_location = 
	brm(noOfBikes ~ location,
			cores = 4,
			family = negbinom,
			data = bikes)

regressionModel_negbinom_all = 
	brm(noOfBikes ~ hours * temp * wday * wind * weather * month * year * location,
			cores = 4,
			family = negbinom,
			data = bikes)

save(regressionModel_negbinom_hours, 
     regressionModel_negbinom_temp, 
     regressionModel_negbinom_wday, 
     regressionModel_negbinom_wind, 
     regressionModel_negbinom_weather,
     regressionModel_negbinom_month,
     regressionModel_negbinom_year,
     regressionModel_negbinom_location,
     regressionModel_negbinom_all,
     file = "negbinom_models.RData")

# TODO
# lognormal
#regressionModel_lognormal = 
#	brm(noOfBikes ~ hourC,
#			cores = 4,
#			family = lognormal,
#			data = bikes[bikes$year == 2015 & bikes$month == 5, ])

# poisson is totally wrong ...?
