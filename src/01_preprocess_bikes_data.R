# This program is free software.
# You should have received a copy of the GNU General Public License
# along with this program (file COPYING). If not, see <http://www.gnu.org/licenses/>.

# make a cleaner data file

# load libraries ####
library(lubridate)
library(dplyr)

# load data ####
data2015Neutor <-
  read.csv("../data/raw/zaehlstelle_neutor_2015_stundenauswertung.csv",
           na.strings = c("technische Störung", "")) %>%
  head(., -1)  # remove summary lines at end of file
data2016Neutor <-
  read.csv("../data/raw/zaehlstelle_neutor_2016_stundenauswertung.csv",
           na.strings = c("technische Störung", "")) %>%
  head(., -2)  # remove summary lines at end of file
data2016Wolbecker <-
  read.csv("../data/raw/zaehlstelle_wolbecker_2016_stundenauswertung.csv",
           na.strings = c("technische Störung", "")) %>%
  head(., -2)  # remove summary lines at end of file


# rename columns, add location ####
data2015Neutor <-
  data2015Neutor %>%
  rename(noOfBikes = Zählung.Neutor) %>%
  mutate(location = 'neutor') %>%
  mutate(Wetter = NA)  # no weather data

data2016Neutor <-
  data2016Neutor %>%
  rename(noOfBikes = Neutor..gesamt.) %>%
  mutate(location = 'neutor')

data2016Wolbecker <-
  data2016Wolbecker %>%
  rename(noOfBikes = Wolbecker.Straße..gesamt.) %>%
  mutate(location = 'wolbecker')


# combine data sources, rename columns ####
bikes <- 
  rbind(data2015Neutor, data2016Neutor, data2016Wolbecker) %>%
  rename(temp = Temperatur...C.) %>%
  rename(wind = Windstärke..km.h.) %>%
  rename(weather = Wetter) %>%
  mutate(rain = (weather == 'Regen'))

bikes$timestamp <- as.POSIXct(strptime(bikes$Stunden, 
                                       format = "%m/%d/%Y %H:%M"))
bikes$date <- lubridate::date(bikes$timestamp)
bikes$year <- year(bikes$date)
bikes$month <- month(bikes$date)
bikes$day <- day(bikes$date)
bikes$weekday <- wday(bikes$date, label = TRUE)
bikes$hour <- hour(bikes$timestamp)

bikes <-
  bikes %>%
  mutate(weekend = (weekday == 'Sat' | weekday == 'Sun')) %>%
  mutate(wind_log = log(wind))  # log of wind speed (due to distribution)


# write processed data to file ####
write.csv(bikes,
          file = "../data/processed/bikes1516.csv",
          row.names = FALSE)
