# create some nice plots
# okay, there are not nice yet ... but this is going to get better hopefully

library(ggplot2)

bikes = read.csv("bikesNeutor1516.csv")

# histogram (?) by ...
# temperature
bikes$year = as.factor(bikes$year)

p = ggplot(data = bikes[!is.na(bikes$temp),]) +
  geom_bin2d(aes(x = temp, y = noOfBikes),
                 # no of bins: one bin for two degree celsius
                 bins = (max(bikes$temp, na.rm = T) - min(bikes$temp, na.rm = T) / 2))
p

# year

p = ggplot(data = NA, aes(x = noOfBikes, fill = year)) +
	geom_histogram(data = bikes[bikes$year == 2016, ], 
	               alpha = 0.5) +
	geom_histogram(data = bikes[bikes$year == 2015, ],
	               alpha = 0.5)
p
