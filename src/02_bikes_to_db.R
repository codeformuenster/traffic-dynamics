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
	mutate(date = dmy(date)) %>% 
	mutate(date = as.character(date)) %>% 
	mutate(hour = substring(hour, 1, 2)) %>% 
 	mutate(hour = as.integer(hour)) %>% 
	mutate(vehicle = "bike")


# write 'df' to SQLite database
dir.create("data/database", showWarnings = F)
con <- dbConnect(SQLite(), dbname = "data/database/traffic_data.sqlite")
dbWriteTable(con, "bikes", df, row.names = F, overwrite = T)
dbDisconnect(con)
