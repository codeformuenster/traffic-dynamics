## Negative binomial GLM

# TODO: for commuting model, remove public holidays
# TODO: add weather feature

## load libraries ####
library(dplyr)
library(ggplot2)
library(sjPlot)
library(nortest)


## load data ####
bikes <- read.csv("../data/processed/bikes1516.csv")


## filtering data ####
# filter data for valid observations
bikes_filtered <-
  bikes %>%
  dplyr::select(noOfBikes, location, temp, wind_log, wind, weekday, year, month, 
                hour) %>%
  filter(wind_log != -Inf,
         location == 'wolbecker',
         year == 2016,
         hour == 7) %>%
  mutate(month = as.factor(month)) %>%
  mutate(weekday = factor(weekday, 
                          levels = c("Mon", "Tues", "Wed", "Thurs", "Fri")))

## fit model ####
# linear regression
fit <- 
  glm(noOfBikes ~ temp + wind_log + weekday + month, 
     data = bikes_filtered)

# analyze residuals
fit %>%
  resid() %>%
  ad.test() # not perfect, yet

plot(fit)

# coefficients
fit$coefficients %>%
  data.frame()

# predictions compared to data
sjp.glm(fit, type = "pred", vars = c("month", "weekday"))
sjp.glm(fit, type = "pred", vars = c("weekday"))
# marginal effects
sjp.glm(fit, type = "eff")
