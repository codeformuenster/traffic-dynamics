# ENGINEER TEMPORAL FEATURES AND STORE IN DATABASE

library(dplyr)
library(chron)
library(lubridate)

# LOAD DATA ----
bikes <- read.csv(file = "data/processed/bikes1516.csv")

# FEATURE ENGINEERING ----
df <-
  bikes %>% 
  select(date, hour, weather, wind, temp) %>%
  mutate(year = as.integer(year(date))) %>%
  mutate(month = as.integer(month(date))) %>%
  mutate(weekday = wday(date, label = T, abbr = F)) %>%
  mutate(weekend = is.weekend(date)) %>%
  mutate(wind_log = log(wind)) %>%
  mutate(rain = (weather == 'Regen'))

# SAVE TO DATABASE ----
con <- dbConnect(SQLite(), dbname = "data/database/kfz_data.sqlite")
dbWriteTable(conn = con, name = "temporal_features", value = df, overwrite = T)
dbDisconnect(con)
