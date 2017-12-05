# This program is free software.
# You should have received a copy of the GNU General Public License
# along with this program (file COPYING). If not, see <http://www.gnu.org/licenses/>.

neededPackages <- c("dplyr", "assertthat", "lubridate", "tidyr", "DBI", "RSQLite", "ggplot2")
notInstalled <- neededPackages[!(neededPackages %in% installed.packages()[,"Package"])]
install.packages(notInstalled)

