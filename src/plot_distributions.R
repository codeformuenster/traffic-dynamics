# create some plots of data distributions, preparing the modeling

# LIBRARIES ----
library(dplyr)
library(fitdistrplus)
library(ggplot2)
library(sqldf)

# BIKES ----
# load data ----
bikes <- 
  read.csv("data/processed/bikes1516.csv") %>%
  filter(wind_log != -Inf,
         year == 2016,
         hour < 20,
         hour > 7)

# distribution of target variable ----
# number of bicycles - errors probably not normally distributed
ggplot(data = bikes, aes(bikes$noOfBikes)) + 
  geom_histogram()

descdist(bikes$noOfBikes)
# => can assume normal distribution

# distribution of features ----
# temperature: approx. normally distributed
ggplot(data = bikes, aes(bikes$temp)) + 
  geom_histogram()
# wind: lognormal
ggplot(data = bikes, aes(bikes$wind_log)) + 
  geom_histogram()


# CARS ----
# load data
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

temporal_features <-
  sqldf("SELECT * FROM temporal_features", 
        dbname = "data/database/kfz_data.sqlite") 

wolbecker2 <-
  sqldf("SELECT * 
        FROM wolbecker
        JOIN temporal_features
          ON (wolbecker.date == temporal_features.date 
          AND wolbecker.hour == temporal_features.hour)") %>%
  setNames(make.names(names(.), unique = T))  # makes column names unique

# distribution of target variable
wolbecker2 %>%
  dplyr::select(date, hour, count, weekend, direction, rain) %>%
  filter(direction == 'entering_city') %>%
  filter(hour >= 7 & hour <= 8) %>%
  filter(weekend == FALSE) %>%
  ggplot(data = ., aes(x = count)) +
  geom_histogram()

