# DOWNLOAD OPEN TRAFFIC DATA THAT IS USED BY THIS PIPELINE

library(RCurl)

# CREATE FOLDERS
dir.create("data", showWarnings = F)
dir.create("data/raw", showWarnings = F)

# DOWNLOAD BICYCLE DATA
url = "https://github.com/codeformuenster/open-data/raw/master/verkehrsdaten/fahrrad/Fahrradzaehlstellen-Stundenwerte.csv"
download.file(url = url, destfile = "data/raw/Fahrradzaehlstellen-Stundenwerte.csv")

# DOWNLOAD CAR DATA
# 2015
url = "https://github.com/codeformuenster/open-data/raw/master/verkehrsdaten/kfz/kfzzaehlstellen2015.zip"
download.file(url = url, destfile = "data/raw/kfzzaehlstellen2015.zip")
# 2016
url = "https://github.com/codeformuenster/open-data/raw/master/verkehrsdaten/kfz/kfzzaehlstellen2016.zip"
download.file(url = url, destfile = "data/raw/kfzzaehlstellen2016.zip")

# UNZIP CAR DATA

