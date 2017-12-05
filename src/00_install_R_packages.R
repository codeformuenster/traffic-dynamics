# This program is free software.
# You should have received a copy of the GNU General Public License
# along with this program (file COPYING). If not, see <http://www.gnu.org/licenses/>.

packages <- c("dplyr", "assertthat", "lubridate", "tidyr", "DBI",
              "RSQLite", "ggplot2")

installed_packages <- installed.packages()[,"Package"]

needed_packages <- packages[!(packages %in% installed_packages)]

install.packages(needed_packages)
