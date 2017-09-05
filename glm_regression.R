## Simple linear regression

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
bikes$wind_log <- log(bikes$wind)


## filter data for valid observations ####
bikes_filtered <-
  bikes %>%
  dplyr::select(noOfBikes, temp, wind_log, wind, weekday, year, month) %>%
  filter(wind_log != -Inf) %>%
  mutate(month = as.factor(month))


## fit models
# linear regression
fit1 <- lm(noOfBikes ~ temp + wind, data = bikes_filtered)
summary(fit1)

fit <- lm(noOfBikes ~ temp + wind_log, data = bikes_filtered)
summary(fit)

# poisson regression
glm(noOfBikes ~ temp + wind_log + weekday + month, 
    data = bikes_filtered, 
    family = poisson()) %>%
  summary

# negative binomial model (due to potentially high level of dispersion)
glm.nb(noOfBikes ~ temp + wind_log + weekday + month, 
       data = bikes_filtered) %>%
  summary

# weekday effect
glm.nb(noOfBikes ~ weekday, data = bikes_filtered) %>% 
  summary
glm(noOfBikes ~ weekday, data = bikes_filtered, family = poisson()) %>% 
  summary
lm(noOfBikes ~ weekday, data = bikes_filtered) %>% 
  summary
