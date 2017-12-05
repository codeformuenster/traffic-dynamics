# set working directory to proper directory
# setwd("path/to/here")

# temporary file to test docker deployment

# load libraries ####
# use 00_install_R_packages.R for installing missing packages
lapply(c("brms", "dplyr"), require, character.only = TRUE)

noOfCores = parallel::detectCores()

# load data
# this assumes the script is called from the root directory of the repository
bikes = read.csv("data/processed/bikes1516.csv")

# ordered factors don't survive .csv storing, so, re-order weekdays:
bikes$weekday = factor(bikes$weekday,
                       ordered = TRUE,
                       levels = c("Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat"))

# look at the data -> see 02_plot_data.R

# filtering data ####
# filter data for valid observations
bikes_commuter_wolbecker <-
  bikes %>%
  dplyr::select(noOfBikes, location, temp, wind_log, wind, weekday, year, month,
                hour, rain) %>%
  filter(wind_log != -Inf,
         location == 'wolbecker',
         year == 2016,
         hour == 7) %>%
  # generate factors
  mutate(rain = as.factor(rain)) %>%
  mutate(month = as.factor(month)) %>%
  mutate(weekday = factor(weekday,
                          levels = c("Mon", "Tues", "Wed", "Thurs", "Fri")))

write.csv(bikes_commuter_wolbecker,
          file = "results/bikesCommuterWolbecker.csv",
          row.names = FALSE)

quit(save = "no")
