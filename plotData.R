# create some plots

library(ggplot2)

# load data
bikes <- read.csv("bikesNeutor1516.csv")

# heatmap of number of bicycles vs. temperature
bikes$year = as.factor(bikes$year)

p = ggplot(data = bikes[!is.na(bikes$temp),]) +
  geom_bin2d(aes(x = temp, y = noOfBikes),
                 # no of bins: one bin for two degree celsius
                 bins = (max(bikes$temp, na.rm = T) - min(bikes$temp, na.rm = T) / 2))
p

# histogram of number of bicycles by year
p = ggplot(data = NA, aes(x = noOfBikes, fill = year)) +
	geom_histogram(data = bikes[bikes$year == 2016, ], alpha = 0.5) +
	geom_histogram(data = bikes[bikes$year == 2015, ], alpha = 0.5)
p
