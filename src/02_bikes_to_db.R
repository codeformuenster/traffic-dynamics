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
  read.csv(file, sep = ";", na.strings = "technische Störung") %>%
  # renaming columns
  rename(hour = X) %>%
  rename(date = Datum) %>%
	rename(weather = Wetter) %>% 
	rename(temperature = Temperatur...C.) %>% 
	rename(windspeed = Windstärke..km.h.) %>% 
  # wide to long format
  gather(location, count, -date, -hour, -weather, -temperature, -windspeed) %>%
	mutate(date = as.character(dmy(date))) %>% 
	mutate(hour = as.integer(substring(hour, 1, 2))) %>% 
	mutate(vehicle = "bike") #%>% 

# write 'df' to SQLite database
dir.create("data/database", showWarnings = F)
con <- dbConnect(SQLite(), dbname = "data/database/traffic_data.sqlite")
dbWriteTable(con, "bikes", df, row.names = F, overwrite = T)

dbExecute(con, "CREATE INDEX timestamp_bikes on bikes (date, hour)")

# add the same weather to cars table
# weather
dbExecute(con, "ALTER TABLE cars ADD COLUMN weather TEXT")
dbExecute(con, "UPDATE cars SET weather = :weather where date = :date and hour = :hour",
          params = data.frame(weather = as.character(df$weather),
                            date = df$date,
          									hour = df$hour))

# windspeed
dbExecute(con, "ALTER TABLE cars ADD COLUMN windspeed REAL")
dbExecute(con, "UPDATE cars SET windspeed = :windspeed where date = :date and hour = :hour",
          params = data.frame(windspeed = df$windspeed,
                            date = df$date,
          									hour = df$hour))

# temperature
dbExecute(con, "ALTER TABLE cars ADD COLUMN temperature REAL")
dbExecute(con, "UPDATE cars SET temperature = :temperature where date = :date and hour = :hour",
          params = data.frame(temperature = df$temperature,
                            date = df$date,
          									hour = df$hour))

dbDisconnect(con)
