## Poisson Regression

## load libraries ####
library(dplyr)
library(ggplot2)
library(MASS)

## load data ####
bikes <- read.csv("bikesNeutor1516.csv")

## processing
bikes$wind_log <- log(bikes$wind)

bikes_filtered <-
  bikes %>%
  dplyr::select(noOfBikes, temp, wind_log, wind) %>%
  filter(wind_log != -Inf)

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
