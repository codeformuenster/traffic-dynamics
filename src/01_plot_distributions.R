# create some plots of data distributions, preparing the modeling

## load libraries ####
library(dplyr)
library(fitdistrplus)
library(ggplot2)

## load data ####
bikes <- 
  read.csv("../data/processed/bikesNeutor1516.csv") %>%
  filter(wind_log != -Inf,
         year == 2016,
         hour < 20,
         hour > 6)

## distribution of target variable ####
# number of bicycles - errors probably not normally distributed
ggplot(data = bikes, aes(bikes$noOfBikes)) + 
  geom_histogram()

descdist(bikes$noOfBikes)
shapiro.test(bikes$noOfBikes)
# => can assume normal distribution

## distribution of features ####
# temperature: approx. normally distributed
ggplot(data = bikes, aes(bikes$temp)) + 
  geom_histogram()
# wind: lognormal
ggplot(data = bikes, aes(bikes$wind_log)) + 
  geom_histogram()
