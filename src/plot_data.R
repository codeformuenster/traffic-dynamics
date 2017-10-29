# create some high level plots

## load libraries ----
library(ggplot2)
library(dplyr)
library(DBI)
library(RSQLite)
library(sqldf)


# BICYCLES ----
## load data ####
bikes <- read.csv("data/processed/bikes1516.csv")


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
                          levels = c("Mon", "Tues", "Wed", "Thurs", "Fri", 
                                     "Sat", "Sun")))

# calculate means per month
bikes_boxplot %>%
  group_by(month) %>%
  summarise(mean_month = mean(noOfBikes))


# boxplots of number of bicycles by WEEKDAY
ggplot(data = bikes_boxplot,
       aes(x = weekday, y = noOfBikes, group = weekday)) +
  geom_boxplot()


## lineplot of number of bikes per DAY
# aggregate by day
bikes_location_daily <-
  bikes %>%
  dplyr::filter(year == 2016) %>%
  dplyr::group_by(date, location) %>%
  dplyr::summarise(bikes_per_day = sum(noOfBikes))

ggplot(data = bikes_location_daily,aes(x = date, y = bikes_per_day)) +
  geom_line(aes(group = location, color = location))

# time lines of rides per day
bikes %>%
  filter(location == 'wolbecker') %>%
  select(date, hour, noOfBikes, FR.stadteinwärts, FR.stadtauswärts,
         weekend) %>%
  ggplot(data = .) +
  geom_line(aes(x = hour, y = noOfBikes, group = date, color = weekend), 
            alpha = .4, size = 1)

# examine dates with low morning peaks:
bikes %>%
  filter(location == 'wolbecker') %>%
  select(date, hour, noOfBikes, FR.stadteinwärts, FR.stadtauswärts,
         weekend) %>%
  filter(weekend == F & hour == 7 & noOfBikes < 300) %>%
  select(date)

# compare into town with out of town
bikes %>%
  filter(location == 'wolbecker') %>%
  dplyr::select(date, hour, noOfBikes, FR.stadteinwärts, FR.stadtauswärts,
         weekend) %>%
  # filter(weekend == F) %>%
  ggplot(data = .) +
  geom_line(aes(x = hour, y = FR.stadteinwärts, group = date, 
                color = 'into town', linetype = weekend), 
            alpha = .2, size = 1) +
  geom_line(aes(x = hour, y = FR.stadtauswärts, group = date, 
                color = 'out of town', linetype = weekend), 
            alpha = .2, size = 1) +
  scale_color_discrete(c("Direction"))

# CARS ----
# load data ----
wolbecker <- 
  sqldf("SELECT 
         date, hour, count, location,
         CASE location
           WHEN 'MQ_09040_FV3_G (MQ1034)' THEN 'entering_city'
           WHEN 'MQ_09040_FV1_G (MQ1033)' THEN 'leaving_city'
           END 'direction'
         FROM car_data
         WHERE location LIKE '%09040%'", 
        dbname = "data/database/kfz_data.sqlite") 

# plot data ----
# GROUPED PLOTS
# plot aggregated days over year
wolbecker %>%
  group_by(direction, date) %>%
  summarise(count_day = sum(count)) %>%
  ggplot(data = ., aes(x = date, y = count_day)) +
  geom_line(aes(group = direction, color = direction)) +
  theme_minimal()

# plot days as line plot
wolbecker %>%
  ggplot(data = ., aes(x = hour, y = count)) +
  geom_line(aes(group = interaction(date, direction), color = direction),
            alpha = .2) +
  theme_minimal()

# UN-GROUPED PLOTS
# plot aggregated days over year
wolbecker %>%
  group_by(date) %>%
  summarise(count_day = sum(count)) %>%
  ggplot(data = ., aes(x = date, y = count_day)) +
  geom_line(group = 1) +
  theme_minimal()

# plot days as line plot
wolbecker %>%
  group_by(date, hour) %>%
  summarise(count_sum = sum(count)) %>%
  ggplot(data = ., aes(x = hour, y = count_sum)) +
  geom_line(aes(group = date),
            alpha = .2) +
  theme_minimal()
