# create some high level plots

## load libraries ####
library(ggplot2)
library(dplyr)

## load data ####
bikes <- read.csv("../data/processed/bikesNeutor1516.csv")

# try to find a proper fitting distribution
# library(fitdistrplus)
# x = bikes$noOfBikes
# x = x[!is.na(x)]
# descdist(x, discrete = FALSE)

## plots ####
# heatmap of number of bicycles vs. temperature
bikes$year = as.factor(bikes$year)

ggplot(data = bikes[!is.na(bikes$temp),]) +
  geom_bin2d(aes(x = temp, y = noOfBikes),
                 # no of bins: one bin for two degree celsius
                 bins = (max(bikes$temp, na.rm = T) - min(bikes$temp, na.rm = T) / 2))

# histogram of number of bicycles by year
ggplot(data = NULL, aes(x = noOfBikes, fill = year)) +
	geom_histogram(data = bikes[bikes$year == 2016, ], alpha = 0.5) +
	geom_histogram(data = bikes[bikes$year == 2015, ], alpha = 0.5)

# boxplots of number of bicycles by MONTH
bikes_boxplot <-
  bikes %>%
  filter(year == 2016) %>%
  mutate(month = as.factor(month)) %>%
  mutate(weekday = factor(weekday, 
                          levels = c("Mon", "Tues", "Wed", "Thurs", "Fri", "Sat", "Sun")))

ggplot(data = bikes_boxplot, 
       aes(x = month, y = noOfBikes, group = month)) +
  geom_boxplot()

bikes_boxplot %>%
  group_by(month) %>%
  summarise(mean_month = mean(noOfBikes))


# boxplots of number of bicycles by WEEKDAY
ggplot(data = bikes_boxplot, 
       aes(x = weekday, y = noOfBikes, group = weekday)) +
  geom_boxplot()

bikes_boxplot %>%
  group_by(weekday) %>%
  summarise(mean_month = mean(noOfBikes))
