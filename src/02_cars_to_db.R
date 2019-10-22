# This program is free software.
# You should have received a copy of the GNU General Public License
# along with this program (file COPYING). If not, see <http://www.gnu.org/licenses/>.

# MOVE CAR COUNT DATA TO DATABASE

# load libraries ####
# use 00_install_R_packages.R for installing missing packages
sapply(c("dplyr", "assertthat", "lubridate", "chron", "tidyr", "DBI", "RSQLite"), 
       require, character.only = TRUE)

process_df <- function(df, filename) {
  
  # shift header left and remove last column, if necessary
  if (!is.na(colnames(df)[26])) {
    # second if does not fit in the first expression due to non-short-circuit R
    # (if there is no 26'th column, the expression will fail ...)
    if (all(is.na(df[26]))) {
      colnames(df) <-
        c(colnames(df), "NA") %>%
        tail(-1)
      assert_that(df %>% dplyr::select(26) %>% is.na %>% all)
      df <-
        df %>%
        dplyr::select(-26)
    }
  }
  
  # remove whole column even if classification seems to work for two junctions
  # see https://github.com/codeformuenster/traffic-dynamics/issues/13
  if ("X" %in% colnames(df)) {
    df <-
      df %>%
      dplyr::select(-X)
  }
  # from Oct 2018 onwards
  if ("Klasse" %in% colnames(df)) {
    df <-
      df %>%
      dplyr::select(-Klasse)
  }
  # from mid-december onwards: wrong naming of columns (see raw files)
  # crude measure: remove supoosed classification column, if there are too many "500"s
  if (sum(df[,2] == 500, na.rm = T) > 510) {
    df <-
      df %>%
      dplyr::select(-2)
  }
  
  # not NA if is needed for empty files
  if (!is.na(df[1, 1])) {
    # remove metadata about not happening classification (from August 2018 onwards)
    if (startsWith(as.character(df[1, 1]), "Datum")) {
      df <- df[-seq(1,12), ]
    }
  }
  
  # DATE
  # identify date from filename
  date_from_filename <- ymd(substr(filename, 1, 10))
  # add date from filename to new column
  df <- 
    df %>%
    mutate(date = as.character(date_from_filename))
  # rename first header to 'location'
  colnames(df)[1] <- "location"
  
  # filter to only add relevant location to the database 
  # as of now: Roxel and all locations where also bicycles are counted
  relevant_locations <-
  	c(# locations where (closeby) also bicycles are counted, in the same order as http://www.stadt-muenster.de/verkehrsplanung/verkehr-in-zahlen/radverkehrszaehlungen.html
  		"01080", # Neutor
  		"09040", # Wolbecker Straße / Dortmunder Straße
  		"01123", # Hüfferstraße / Badstraße
  		"07030", # Hammer Straße 1
  		"07080", # Hammer Straße / Kreuzung Geiststraße; TODO Fahrspurfilterung)
  		"04051", # Eisenbahnstraße
  		"04073", # Gartenstraße
  		"03160", # Gartenstraße Kreuzung Ring: TODO Fahrspurfilterung
  		"04061", # Warendorfer Straße
  		"04010", # Hafenstraße
  		"01190", # Weseler Straße / Kolde-Ring
  		"03290" # Hansaring / Albersloher-Weg
  	)
  
  df <-
  	df %>% 
  	filter(grepl(paste(relevant_locations, collapse = "|"), location))
  
  # TIME
  # wide to long format
  df <-
    df %>%
    gather(hour, count, -location, -date) %>%
    mutate(year = as.integer(year(date))) %>%
    mutate(month = as.integer(month(date))) %>%
    mutate(day = as.integer(day(date))) %>%
    # subtract 1 because sqlite counts Sun = 0 but lubridate Sun = 1
    mutate(weekday = wday(date, label = F) - 1) %>%
    mutate(weekend = is.weekend(date)) %>%
    # 'hour' to integer format
    mutate(hour = substring(hour, 2)) %>%
    mutate(hour = as.integer(hour)) %>%
  	mutate(vehicle = "car")

  return(df)
}

# get all files
data_folder <- "data/raw/cars_unzipped/"
raw_files <- dir(data_folder, recursive = T)

# connect to database and remove existing table, if exists
dir.create("data/database", showWarnings = F)
con <- dbConnect(SQLite(), dbname = "data/database/traffic_data.sqlite")
if (dbExistsTable(con, "cars")) { dbRemoveTable(con, "cars") }

# EACH source file: read, preprocess, add to 'df_target'
for (raw_file_name in raw_files) {
  print(paste("processing ", raw_file_name))
  df_source <- 
    read.csv(paste(data_folder, raw_file_name, sep = ""),
             sep = ";", row.names = NULL)
  
  df_processed <- process_df(df_source, strsplit(raw_file_name, "/")[[1]][2])
  
  # write 'df_source' to SQLite database
  dbWriteTable(con, "cars", df_processed, 
               append = T, row.names = F, overwrite = F)
}

dbExecute(con, "CREATE INDEX timestamp_cars on cars (date, hour)")
dbExecute(con, "CREATE INDEX year_month_day_cars on cars (year, month, day, hour)")
dbExecute(con, "CREATE INDEX location_cars on cars (location)")
dbDisconnect(con)
