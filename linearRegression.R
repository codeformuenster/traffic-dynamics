## Simple linear regression

library(dplyr)
library(ggplot2)
library(fitdistrplus)
library(MASS)

# load data
bikes <- read.csv("bikesNeutor1516.csv")

## check values for their distribution
# number of bicycles
descdist(bikes$noOfBikes, discrete = FALSE)
# scale data
bikes$noOfBikes_norm <- bikes$noOfBikes / (max(bikes$noOfBikes) + 10) + 0.001
x <- dbeta(bikes$noOfBikes_norm, 0.927726829, 3.610553699)
ggplot(data = bikes, aes(x)) + 
  geom_histogram()
fit.beta <- fitdistr(bikes$noOfBikes_norm, "beta", 
                    list(shape1 = 2, shape2 = 5))
ggplot(data = bikes, aes(bikes$noOfBikes_norm)) + 
  geom_histogram()
# TODO: clean transformation to normal distribution

# temperature: approx. normally distributed
ggplot(data = bikes, aes(bikes$temp)) + 
  geom_histogram()
# wind: lognormal
ggplot(data = bikes, aes(log(bikes$wind + 1))) + 
  geom_histogram()
bikes$wind_log <- log(bikes$wind + 1)

# fit regression model
fit <- lm(noOfBikes ~ temp + wind_log, 
          data = bikes)

# evaluate
summary(fit)
