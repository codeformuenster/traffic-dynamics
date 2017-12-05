# Copyright © 2017 Thorben Jensen, Thomas Kluth
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program (file COPYING). If not, see <http://www.gnu.org/licenses/>.

# PROCESS DATA

library(dplyr)
library(assertthat)
library(lubridate)
library(tidyr)
library(DBI)
library(RSQLite)


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
data_folder <- "data/raw/"
raw_files <- dir(data_folder)

# connect to database and remove existing table, if exists
system("mkdir -p data/processed")
con <- dbConnect(SQLite(), dbname = "data/processed/kfz_data.sqlite")
if (dbExistsTable(con, "kfz_data")) { dbRemoveTable(con, "kfz_data") }

# EACH source file: read, preprocess, add to 'df_target'
for (raw_file in raw_files) {
  print(paste("processing ", raw_file))
  df_source <- 
    read.csv(paste(data_folder, raw_file, sep = ""),
             sep = ";", row.names = NULL) %>%
    process_df()
  
  # write 'df_source' to SQLite database
  dbWriteTable(con, "kfz_data", df_source, 
               append = T, row.names = F, overwrite = F)
}

dbDisconnect(con)
