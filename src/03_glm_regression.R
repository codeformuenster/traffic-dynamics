# LINEAR GLM REGRESSION MODEL

# TODOs ####
# TODO: for commuting model, remove public holidays (outliers for weekdays)

# load libraries ####
library(dplyr)
library(ggplot2)
library(sjPlot)
library(nortest)


# load data ####
bikes <- read.csv("../data/processed/bikes1516.csv")


# filtering data ####
# filter data for valid observations
bikes_filtered <-
  bikes %>%
  dplyr::select(noOfBikes, location, temp, wind_log, wind, weekday, year, month, 
                hour, rain) %>%
  filter(location == 'wolbecker', # wind_log != -Inf, #this removes all days without wind (see below)
         year == 2016,
         hour == 7) %>%
  # generate factors
  mutate(rain = as.factor(rain)) %>%
  mutate(month = as.factor(month)) %>%
  mutate(weekday = factor(weekday, 
                          levels = c("Mon", "Tues", "Wed", "Thurs", "Fri")))


nrow(bikes[bikes$location == "wolbecker" & bikes$wind_log == -Inf,])
nrow(bikes[bikes$location == "wolbecker" & bikes$wind == 0,])
nrow(bikes[bikes$location == "wolbecker",])


# fit model ####
# linear regression
fit <- 
  glm(noOfBikes ~ temp + wind + weekday + month + rain, 
     data = bikes_filtered)

# analyze residuals ####
fit %>%
  resid() %>%
  ad.test() # not perfect, yet

plot(fit)


# analyze coefficients ####
fit$coefficients %>%
  data.frame()
# predictions compared to data
sjp.glm(fit, type = "pred", vars = c("rain"))
sjp.glm(fit, type = "pred", vars = c("weekday"))
# marginal effects
sjp.glm(fit, type = "eff")
