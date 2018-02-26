# This program is free software.
# You should have received a copy of the GNU General Public License
# along with this program (file COPYING). If not, see <http://www.gnu.org/licenses/>.

# DOWNLOAD OPEN TRAFFIC DATA THAT IS USED BY THIS PIPELINE

library(RCurl)

# CREATE FOLDERS
dir.create("data", showWarnings = F)
dir.create("data/raw", showWarnings = F)
dir.create("data/raw/cars_unzipped", showWarnings = F)

# DOWNLOAD BICYCLE DATA
url = "https://github.com/codeformuenster/open-data/raw/master/verkehrsdaten/fahrrad/Fahrradzaehlstellen-Stundenwerte.csv"
download.file(url = url,
              destfile = "data/raw/Fahrradzaehlstellen-Stundenwerte.csv")

# DOWNLOAD CAR DATA
# 2015
url = "https://github.com/codeformuenster/open-data/raw/master/verkehrsdaten/kfz/kfzzaehlstellen2015.zip"
download.file(url = url, destfile = "data/raw/kfzzaehlstellen2015.zip")
# 2016
url = "https://github.com/codeformuenster/open-data/raw/master/verkehrsdaten/kfz/kfzzaehlstellen2016.zip"
download.file(url = url, destfile = "data/raw/kfzzaehlstellen2016.zip")
# 2017
url = "https://github.com/codeformuenster/open-data/raw/master/verkehrsdaten/kfz/kfzzaehlstellen2017.zip"
download.file(url = url, destfile = "data/raw/kfzzaehlstellen2017.zip")
# 2018
url = "https://github.com/codeformuenster/open-data/raw/master/verkehrsdaten/kfz/kfzzaehlstellen2018.zip"
download.file(url = url, destfile = "data/raw/kfzzaehlstellen2018.zip")

# UNZIP CAR DATA
unzip(zipfile = "data/raw/kfzzaehlstellen2015.zip", 
      exdir = "data/raw/cars_unzipped/")
unzip(zipfile = "data/raw/kfzzaehlstellen2016.zip", 
      exdir = "data/raw/cars_unzipped/")
unzip(zipfile = "data/raw/kfzzaehlstellen2017.zip", 
      exdir = "data/raw/cars_unzipped/")
unzip(zipfile = "data/raw/kfzzaehlstellen2018.zip", 
      exdir = "data/raw/cars_unzipped/")
