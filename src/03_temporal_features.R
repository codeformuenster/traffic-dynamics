# This program is free software.
# You should have received a copy of the GNU General Public License
# along with this program (file COPYING). If not, see <http://www.gnu.org/licenses/>.

# ENGINEER TEMPORAL FEATURES AND STORE IN DATABASE

# load libraries ####
# if the following fails, you might want to use 00_install_R_packages.R
# to install missing packages
lapply(c("chron", "dplyr", "lubridate"), require, character.only = TRUE)

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
