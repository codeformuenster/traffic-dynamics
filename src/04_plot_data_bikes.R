# This program is free software.
# You should have received a copy of the GNU General Public License
# along with this program (file COPYING). If not, see <http://www.gnu.org/licenses/>.

# load libraries ####
# use 00_install_R_packages.R for installing missing packages
sapply(c("sqldf", "ggplot2", "gridExtra", "dplyr", 
         "assertthat", "lubridate", "tidyr", "DBI", 
         "RSQLite", "fitdistrplus"), require, character.only = TRUE)

# load data ----
# read from database
con <- dbConnect(SQLite(), dbname = "data/database/traffic_data.sqlite")
bikes <- dbGetQuery(conn = con, "SELECT * FROM bikes_processed")
dbDisconnect(con)
# scale data
bikes <- 
  bikes %>%
  mutate(month = as.factor(month)) %>%
  mutate(weekday = factor(weekday,
                          levels = c("Mo", "Di", "Mi", "Do", "Fr", "Sa", "So")))

# test for distribution
descdist(bikes$count)

## plots ####
# heatmap of number of bicycles vs. temperature
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
  summarise(mean_month = mean(count))


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
  filter(weekend == F & (hour == 7 | hour == 8) & noOfBikes < 300) %>%
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
