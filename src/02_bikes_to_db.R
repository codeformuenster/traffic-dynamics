# MOVE BIKES DATA TO DATABASE

library(dplyr)
library(DBI)
library(RSQLite)


file = "data/raw/Fahrradzaehlstellen-Stundenwerte.csv"

df <- 
  read.csv(file, sep = ";") %>%
  # renaming columns
  rename(hour = X) %>%
  rename(date = Datum) %>%
  # wide to long format
  gather(location, count, -date, -hour)

# write 'df' to SQLite database
dir.create("data/database", showWarnings = F)
con <- dbConnect(SQLite(), dbname = "data/database/traffic_data.sqlite")
if (dbExistsTable(con, "bikes")) { dbRemoveTable(con, "bikes") }
dbWriteTable(con, "bikes", df, row.names = F)
dbDisconnect(con)

