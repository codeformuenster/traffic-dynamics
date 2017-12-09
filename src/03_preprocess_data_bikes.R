# This program is free software.
# You should have received a copy of the GNU General Public License
# along with this program (file COPYING). If not, see <http://www.gnu.org/licenses/>.

# load libraries ----
# use 00_install_R_packages.R for installing required packages
sapply(c("lubridate", "dplyr"), require, character.only = TRUE)

# load data ----
con <- dbConnect(SQLite(), dbname = "data/database/traffic_data.sqlite")
bikes <-
  dbGetQuery(conn = con,
             "SELECT
             date, hour, location, count
             FROM bikes")
dbDisconnect(con)

# feature engineering ----
bikes$date_iso <- as.character(date(strptime(bikes$date, format = "%d/%m/%Y")))
bikes$year <- year(bikes$date_iso)
bikes$month <- month(bikes$date_iso)
bikes$day <- day(bikes$date_iso)
bikes$weekday <- wday(bikes$date_iso, label = TRUE)
bikes$hour_int <- hour(as.POSIXlt(bikes$hour, format="%H:%M"))

bikes <-
  bikes %>%
  mutate(weekend = (weekday == 'Sa' | weekday == 'So'))

# write processed data to file ----
con <- dbConnect(SQLite(), dbname = "data/database/traffic_data.sqlite")
dbWriteTable(con, "bikes_processed", bikes, row.names = F, overwrite = T)
dbDisconnect(con)
