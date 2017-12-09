# This program is free software.
# You should have received a copy of the GNU General Public License
# along with this program (file COPYING). If not, see <http://www.gnu.org/licenses/>.

# MOVE CAR COUNT DATA TO DATABASE

# load libraries ####
# use 00_install_R_packages.R for installing missing packages
sapply(c("dplyr", "assertthat", "lubridate", "tidyr", "DBI", "RSQLite"), 
       require, character.only = TRUE)

process_df <- function(df) {
  # shift header left and remove last column 
  if (!is.na(colnames(df)[26])) {
    colnames(df) <-
      colnames(df) %>% 
      tail(-1)
    assert_that(df %>% dplyr::select(26) %>% is.na %>% all)
    df <-
      df %>%
      dplyr::select(-26)
  }
  
  # DATE
  # identify date from first column lable
  date <-
    df %>%
    colnames %>%
    .[1] %>%
    ymd(.)
  # add date to new column
  df <- 
    df %>%
    mutate(date = as.character(date))
  # rename first header to 'location'
  colnames(df)[1] <- "location"
  
  # TIME
  # wide to long format
  df <-
    df %>%
    gather(hour, count, -location, -date) %>%
    # 'hour' to integer format
    mutate(hour = substring(hour, 2)) %>% 
    mutate(hour = as.integer(hour))

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
for (raw_file in raw_files) {
  print(paste("processing ", raw_file))
  df_source <- 
    read.csv(paste(data_folder, raw_file, sep = ""),
             sep = ";", row.names = NULL) %>%
    process_df()
  
  # write 'df_source' to SQLite database
  dbWriteTable(con, "cars", df_source, 
               append = T, row.names = F, overwrite = F)
}

dbDisconnect(con)
