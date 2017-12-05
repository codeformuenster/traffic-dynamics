# DOWNLOAD OPEN TRAFFIC DATA THAT IS USED BY THIS PIPELINE

library(RCurl)

# CREATE FOLDERS


# DOWNLOAD CAR DATA
# 2015
file = "https://github.com/codeformuenster/open-data/raw/master/verkehrsdaten/kfz/kfzzaehlstellen2015.zip"
download.file(url = file, destfile = "data/raw/kfzzaehlstellen2015.zip")
# 2016
file = "https://github.com/codeformuenster/open-data/raw/master/verkehrsdaten/kfz/kfzzaehlstellen2016.zip"
download.file(url = file, destfile = "data/raw/kfzzaehlstellen2016.zip")

# DOWNLOAD BICYCLE DATA
file = "https://github.com/codeformuenster/open-data/raw/master/verkehrsdaten/fahrrad/Fahrradzaehlstellen-Stundenwerte.csv"
download.file(url = file, destfile = "data/raw/Fahrradzaehlstellen-Stundenwerte.csv")

