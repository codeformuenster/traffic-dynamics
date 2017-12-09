# This program is free software.
# You should have received a copy of the GNU General Public License
# along with this program (file COPYING). If not, see <http://www.gnu.org/licenses/>.

# load libraries ####
# if the following fails, you might want to use 00_install_R_packages.R
# to install missing packages
lapply(c("chron", "dplyr", "lubridate"), require, character.only = TRUE)

# LOAD DATES AND HOURS ----
con <- dbConnect(SQLite(), dbname = "data/database/traffic_data.sqlite")
temporal_features <-
  dbGetQuery(conn = con, 
             "SELECT DISTINCT * FROM (
               SELECT date, hour FROM cars
               UNION ALL
               SELECT date_iso as date, hour_int as hour FROM bikes_processed
             ) ORDER BY date ASC, hour ASC")
dbDisconnect(con)


# FEATURE ENGINEERING ----
temporal_features <-
  temporal_features %>%
  mutate(year = as.integer(year(date))) %>%
  mutate(month = as.integer(month(date))) %>%
  mutate(weekday = wday(date, label = T, abbr = T)) %>%
  mutate(weekend = is.weekend(date))

# TODO: add weather from Dark Sky API

# SAVE TO DATABASE ----
con <- dbConnect(SQLite(), dbname = "data/database/traffic_data.sqlite")
dbWriteTable(conn = con, name = "temporal_features", value = temporal_features,
             overwrite = T)
dbDisconnect(con)
