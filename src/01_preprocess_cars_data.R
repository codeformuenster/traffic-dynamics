# PREPROCESS CARS DATA

# load libraries ####
# use 00_install_R_packages.R for installing missing packages
lapply(c("assertthat", "dplyr", "lubridate", 
         "tidyr", "DBI", "RSQlite"), require, character.only = TRUE)

process_df <- function(df) {
  # shift header left and remove last column
  if (!is.na(colnames(df)[26])) {
    colnames(df) <-
      colnames(df) %>%
      tail(-1)
    assert_that(df %>% select(26) %>% is.na %>% all)
    df <-
      df %>%
      select(-26)
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
data_folder <- "data/raw/kfz-data/"
raw_csv_files <- dir(data_folder, pattern = "*.csv")

# connect to database and remove existing table, if exists
con <- dbConnect(SQLite(), dbname = "data/database/kfz_data.sqlite")
if (dbExistsTable(con, "car_data")) { dbRemoveTable(con, "car_data") }

# EACH source file: read, preprocess, add to 'df_target'
for (raw_file in raw_csv_files) {
  print(paste("processing ", raw_file))
  df_source <-
    read.csv(paste(data_folder, raw_file, sep = ""),
             sep = ";", row.names = NULL) %>%
    process_df()

  # write 'df_source' to SQLite database
  dbWriteTable(con, "car_data", df_source,
               append = T, row.names = F, overwrite = F)
}

dbDisconnect(con)
