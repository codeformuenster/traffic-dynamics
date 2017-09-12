## Negative binomial GLM

## load libraries ####
library(dplyr)
library(ggplot2)
library(fitdistrplus)
library(MASS)


## load data ####
bikes <- read.csv("bikesNeutor1516.csv")


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
  dplyr::select(noOfBikes, temp, wind_log, wind, weekday, year, month) %>%
  filter(wind_log != -Inf) %>%
  mutate(month = as.factor(month))


## fit model ####
# negative binomial model (due to potentially high level of dispersion)
fit <-
  glm.nb(noOfBikes ~ temp + wind_log + weekday + month, 
       data = bikes_filtered)

fit %>%
  summary

