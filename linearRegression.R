## Simple linear regression

library(dplyr)
library(ggplot2)

# load data
bikes <- read.csv("bikesNeutor1516.csv")

## check features for normal distribution
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
