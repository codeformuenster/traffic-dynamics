# set working directory to proper directory
# setwd("path/to/here")

# TODO nicer way to load package in a tolerant way

if (require(brms) == FALSE) {
  install.packages("brms")
  require(brms)
}
if (require(dplyr) == FALSE) {
  install.packages("dplyr")
  require(dplyr)
}

noOfCores = parallel::detectCores()

# load data
# this assumes the script is called from the root directory of the repository
bikes = read.csv("data/processed/bikes1516.csv")

# ordered factors don't survive .csv storing, so, re-order weekdays:
bikes$weekday = factor(bikes$weekday, 
                       ordered = TRUE,
                       levels = c("Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat"))

# look at the data -> see 02_plot_data.R

# filtering data ####
# filter data for valid observations
bikes_commuter_wolbecker <-
  bikes %>%
  dplyr::select(noOfBikes, location, temp, wind_log, wind, weekday, year, month, 
                hour, rain) %>%
  filter(location == 'wolbecker',
         weekday != "Sat",
         weekday != "Sun",
         year == 2016,
         (hour == 7 | hour == 8)) %>%
  # generate factors
  mutate(rain = as.factor(rain)) %>%
  mutate(month = as.factor(month)) %>%
  mutate(weekday = factor(weekday, 
                          levels = c("Mon", "Tues", "Wed", "Thurs", "Fri"))) %>%
  mutate(tempC = as.vector(scale(temp, center = TRUE, scale = FALSE))) %>%
  mutate(windC = as.vector(scale(wind, center = TRUE, scale = FALSE)))

# write.csv(bikes_commuter_wolbecker,
#           file = "results/bikesCommuterWolbecker.csv",
#           row.names = FALSE)

# temp test
# quit(save = "no")

# Bayesian commuter models
commuter_model_A = 
  brm(noOfBikes ~ tempC * windC * weekday * month * rain, 
		cores = noOfCores,
    data = bikes_commuter_wolbecker)

commuter_model_B = 
  brm(noOfBikes ~ tempC * windC * weekday * month + rain, 
		cores = noOfCores,
    data = bikes_commuter_wolbecker)

commuter_model_C = 
  brm(noOfBikes ~ tempC * windC * weekday + month + rain, 
		cores = noOfCores,
    data = bikes_commuter_wolbecker)

commuter_model_D = 
  brm(noOfBikes ~ tempC * windC + weekday + month + rain, 
		cores = noOfCores,
    data = bikes_commuter_wolbecker)

commuter_model_E = 
  brm(noOfBikes ~ tempC + windC + weekday + month + rain, 
		cores = noOfCores,
    data = bikes_commuter_wolbecker)

commuter_model_F = 
  brm(noOfBikes ~ tempC + windC * weekday * month * rain, 
		cores = noOfCores,
    data = bikes_commuter_wolbecker)

commuter_model_G = 
  brm(noOfBikes ~ tempC + windC + weekday * month * rain, 
		cores = noOfCores,
    data = bikes_commuter_wolbecker)

commuter_model_H = 
  brm(noOfBikes ~ tempC + windC + weekday + month * rain, 
		cores = noOfCores,
    data = bikes_commuter_wolbecker)

commuter_model_I = 
  brm(noOfBikes ~ tempC * windC * rain + weekday + month,
		cores = noOfCores,
    data = bikes_commuter_wolbecker)

save(commuter_model_A,
     commuter_model_B,
     commuter_model_C,
     commuter_model_D,
     commuter_model_E,
     commuter_model_F,
     commuter_model_G,
     commuter_model_H,
     commuter_model_I,
     file = "results/Bayesian_commuter_models.RData")


## Bayesian regression models

# I have the feeling that exgaussian fits better -- but this should be checked ...
# hour seems to be not working correct -- gives a weird regression line ...

# TODO: do proper scaling of predictors
# bikes$hourC = scale(bikes$hour, center = TRUE, scale = FALSE)

## TODO have a look at update.brmsfit -> this might be quicker than re-computing all the time!

#### exgaussian ####

regressionModel_exgaussian_hours =
	brm(noOfBikes ~ poly(hour,3),
			cores = noOfCores,
			family = exgaussian,
			data = bikes)

regressionModel_exgaussian_temp =
	brm(noOfBikes ~ poly(temp, 3),
			cores = noOfCores,
			family = exgaussian,
			data = bikes[!(is.na(bikes$temp)), ]) # TODO fix this before fitting the model ...

regressionModel_exgaussian_wday =
	brm(noOfBikes ~ weekday,
			cores = noOfCores,
			family = exgaussian,
			data = bikes)

regressionModel_exgaussian_wind =
	brm(noOfBikes ~ wind, # poly is not needed -> the model converges to a straight line
			cores = noOfCores,
			family = exgaussian,
			data = bikes[!is.na(bikes$wind), ])  # TODO fix this before fitting the model ...

regressionModel_exgaussian_weather =
	brm(noOfBikes ~ weather,
			cores = noOfCores,
			family = exgaussian,
			data = bikes)

regressionModel_exgaussian_month =
	brm(noOfBikes ~ month,
			cores = noOfCores,
			family = exgaussian,
			data = bikes)

regressionModel_exgaussian_year =
	brm(noOfBikes ~ year,
			cores = noOfCores,
			family = exgaussian,
			data = bikes)

regressionModel_exgaussian_location =
	brm(noOfBikes ~ location,
			cores = noOfCores,
			family = exgaussian,
			data = bikes)

regressionModel_exgaussian_all =
	brm(noOfBikes ~ hours * temp * wday * wind * weather * month * year * location,
			cores = noOfCores,
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
     file = "results/Bayesian_exgaussian_models.RData")

#### negbinomial ####

regressionModel_negbinom_hours = 
	brm(noOfBikes ~ poly(hour,3),
			cores = noOfCores,
			family = negbinomial,
			data = bikes)

regressionModel_negbinom_temp = 
	brm(noOfBikes ~ poly(temp, 3),
			cores = noOfCores,
			family = negbinomial,
			data = bikes[!(is.na(bikes$temp)), ]) # TODO fix this before fitting the model ...

regressionModel_negbinom_wday = 
	brm(noOfBikes ~ weekday,
			cores = noOfCores,
			family = negbinomial,
			data = bikes)

regressionModel_negbinom_wind = 
	brm(noOfBikes ~ wind, # poly is not needed -> the model converges to a straight line
			cores = noOfCores,
			family = negbinomial,
			data = bikes[!is.na(bikes$wind), ])  # TODO fix this before fitting the model ...

regressionModel_negbinom_weather = 
	brm(noOfBikes ~ weather,
			cores = noOfCores,
			family = negbinomial,
			data = bikes)

regressionModel_negbinom_month = 
	brm(noOfBikes ~ month,
			cores = noOfCores,
			family = negbinomial,
			data = bikes)

regressionModel_negbinom_year = 
	brm(noOfBikes ~ year,
			cores = noOfCores,
			family = negbinomial,
			data = bikes)

regressionModel_negbinom_location = 
	brm(noOfBikes ~ location,
			cores = noOfCores,
			family = negbinomial,
			data = bikes)

regressionModel_negbinom_all = 
	brm(noOfBikes ~ hours * temp * wday * wind * weather * month * year * location,
			cores = noOfCores,
			family = negbinomial,
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
     file = "results/Bayesian_negbinom_models.RData")

# TODO
# lognormal
#regressionModel_lognormal = 
#	brm(noOfBikes ~ hourC,
#			cores = 4,
#			family = lognormal,
#			data = bikes[bikes$year == 2015 & bikes$month == 5, ])

# poisson is totally wrong ...?
