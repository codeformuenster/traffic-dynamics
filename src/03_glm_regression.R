# This program is free software.
# You should have received a copy of the GNU General Public License
# along with this program (file COPYING). If not, see <http://www.gnu.org/licenses/>.

# LINEAR GLM REGRESSION MODEL

# TODOs ####
# TODO: for commuting model, remove public holidays (outliers for weekdays)

# load libraries ####
# use 00_install_R_packages.R for installing missing packages
lapply(c("ggplot2", "dplyr", "sjPlot", "nortest", "sqldf"), 
       require, character.only = TRUE)

# load data ####
bikes <- read.csv("data/processed/bikes1516.csv")


# filtering data ####
# filter data for valid observations
bikes_filtered <-
  bikes %>%
  dplyr::select(noOfBikes, location, temp, wind_log, wind, weekday, year, month,
                hour, rain) %>%
  filter(location == 'wolbecker', # wind_log != -Inf, #this removes all days without wind (see below)
         year == 2016,
         hour == 7) %>%
  # generate factors
  mutate(rain = as.factor(rain)) %>%
  mutate(month = as.factor(month)) %>%
  mutate(weekday = factor(weekday,
                          levels = c("Mon", "Tues", "Wed", "Thurs", "Fri")))


nrow(bikes[bikes$location == "wolbecker" & bikes$wind_log == -Inf,])
nrow(bikes[bikes$location == "wolbecker" & bikes$wind == 0,])
nrow(bikes[bikes$location == "wolbecker",])


# fit model ####
# linear regression
fit <-
  glm(noOfBikes ~ temp + wind + weekday + month + rain,
     data = bikes_filtered)

# analyze residuals ####
fit %>%
  resid() %>%
  ad.test() # not perfect, yet

plot(fit)


# analyze coefficients ####
fit$coefficients %>%
  data.frame()
# predictions compared to data
sjp.glm(fit, type = "pred", vars = c("rain"))
sjp.glm(fit, type = "pred", vars = c("weekday"))
# marginal effects
sjp.glm(fit, type = "eff")


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
        LEFT JOIN temporal_features
          ON (wolbecker.date == temporal_features.date
          AND wolbecker.hour == temporal_features.hour)") %>%
  setNames(make.names(names(.), unique = T))  # makes column names unique

# linear regression
fit2 <-
  wolbecker2 %>%
  dplyr::select(date, temp, wind_log, weekday, month,
                count, hour, count, weekend, direction, rain) %>%
  filter(direction == 'entering_city') %>%
  filter(hour >= 7 & hour <= 8) %>%
  filter(weekend == FALSE) %>%
  filter(complete.cases(.)) %>%
  filter(wind_log != -Inf) %>%
  mutate(month = as.factor(month)) %>%
  mutate(weekday = as.factor(weekday)) %>%
  glm(count ~ rain + temp + wind_log + weekday + month,
      data = .)

fit2$coefficients %>%
  data.frame()

# predictions compared to data
sjp.glm(fit2, type = "pred", vars = c("rain"))
sjp.glm(fit2, type = "pred", vars = c("weekday"))
# marginal effects
sjp.glm(fit2, type = "eff")
