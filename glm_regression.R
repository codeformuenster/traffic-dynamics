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
  dplyr::select(noOfBikes, temp, wind_log, wind) %>%
  filter(wind_log != -Inf)


## regression model without transformation ####
fit1 <- lm(noOfBikes ~ temp + wind, data = bikes_filtered)
summary(fit1)

## fit regression model ####
fit <- lm(noOfBikes ~ temp + wind_log, data = bikes_filtered)
summary(fit)

## fit poisson regression (no transformation)
fit1 <- glm(noOfBikes ~ temp + wind, 
            data = bikes_filtered, 
            family = poisson())
summary(fit1)

## fit negative binomial model (due to potentially high level of dispersion)
fit2 <- glm.nb(noOfBikes ~ temp + wind, 
               data = bikes_filtered)
summary(fit2)

## fit poisson regression (wind log-transformed)
fit <- glm(noOfBikes ~ temp + wind_log, 
           data = bikes_filtered,
           family = poisson())
summary(fit)

