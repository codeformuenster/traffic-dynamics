## Negative binomial GLM

## load libraries ####
library(dplyr)
library(ggplot2)
library(fitdistrplus)
library(MASS)
library(sjPlot)


## load data ####
bikes <- read.csv("../data/processed/bikesNeutor1516.csv")


## check distributions ####
# number of bicycles - errors probably not normally distributed
ggplot(data = bikes, aes(bikes$noOfBikes)) + 
  geom_histogram()
# temperature: approx. normally distributed
ggplot(data = bikes, aes(bikes$temp)) + 
  geom_histogram()
# wind: lognormal
ggplot(data = bikes, aes(log(bikes$wind))) + 
  geom_histogram()


## preprocessing data ####
# log of wind speed (due to log-normal distribution)
bikes$wind_log <- log(bikes$wind)
# filter data for valid observations
bikes_filtered <-
  bikes %>%
  dplyr::select(noOfBikes, temp, wind_log, wind, weekday, year, month, hour) %>%
  filter(wind_log != -Inf) %>%
  mutate(month = as.factor(month)) %>%
  filter(year == 2016) %>%
  mutate(weekday = factor(weekday, 
                          levels = c("Mon", "Tues", "Wed", "Thurs", "Fri", "Sat", "Sun"))) %>%
  filter(hour < 20) %>%
  filter(hour > 7)

## fit model ####
# negative binomial model (due to potentially high level of dispersion)
fit <-
  glm.nb(noOfBikes ~ temp + wind_log + weekday + month, 
       data = bikes_filtered)

fit$coefficients %>%
  exp() %>%
  data.frame()

## visualize fitted model against data ####
plot(fit)

# effect ranking of independent variables? (effects of months odd)
sjp.glm(fit)
# predictions
sjp.glm(fit, type = "pred", vars = c("month", "weekday"))
sjp.glm(fit, type = "pred", vars = c("month"))
# marginal effects
sjp.glm(fit, type = "eff")
