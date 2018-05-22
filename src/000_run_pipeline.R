# This program is free software.
# You should have received a copy of the GNU General Public License
# along with this program (file COPYING). If not, see <http://www.gnu.org/licenses/>.

library(envDocument)

# two times dirname() to go to project root
setwd(dirname(dirname(getScriptPath())))

print(getwd())

source("src/00_install_R_packages.R", echo = TRUE)
source("src/01_download_data.R", echo = TRUE)
source("src/02_cars_to_db.R", echo = TRUE)
source("src/02_bikes_to_db.R", echo = TRUE)
# TODO do we need this table / probably convert to weather table?
# source("src/03_temporal_features.R", echo = TRUE)
