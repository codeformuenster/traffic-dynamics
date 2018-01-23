# This program is free software.
# You should have received a copy of the GNU General Public License
# along with this program (file COPYING). If not, see <http://www.gnu.org/licenses/>.

# MOVE BIKES DATA TO DATABASE

# load libraries ####
# use 00_install_R_packages.R for installing missing packages
sapply(c("dplyr", "DBI", "RSQLite", "tidyr", "lubridate"), 
       require, character.only = TRUE)

file <- "data/raw/Fahrradzaehlstellen-Stundenwerte.csv"

df <- 
  read.csv(file, sep = ";") %>%
  # renaming columns
  rename(hour = X) %>%
  rename(date = Datum) %>%
  # wide to long format
  gather(location, count, -date, -hour) %>%
	mutate(date = as.character(dmy(date))) %>% 
	mutate(hour = as.integer(substring(hour, 1, 2))) %>% 
	mutate(vehicle = "bike") %>% 
	# TODO are the following columns actually used?
	mutate(date_iso = as.character(date(strptime(date, format = "%d/%m/%Y")))) %>% 
	mutate(year = year(date_iso)) %>% 
	mutate(month = month(date_iso)) %>% 
	mutate(day = day(date_iso)) %>% 
	mutate(weekday = wday(bikes$date_iso, label = TRUE)) %>% 
  mutate(weekend = (weekday == 'Sa' | weekday == 'So'))

# write 'df' to SQLite database
dir.create("data/database", showWarnings = F)
con <- dbConnect(SQLite(), dbname = "data/database/traffic_data.sqlite")
dbWriteTable(con, "bikes", df, row.names = F, overwrite = T)
dbExecute(con, "CREATE INDEX timestamp_bikes on bikes (date, hour)")
dbDisconnect(con)
