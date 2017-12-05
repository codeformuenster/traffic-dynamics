# This program is free software.
# You should have received a copy of the GNU General Public License
# along with this program (file COPYING). If not, see <http://www.gnu.org/licenses/>.

# USER INTERFACE OF THE SHINY APP

# load libraries ####
# use 00_install_R_packages.R for installing missing packages
lapply(c("shiny"), 
       require, character.only = TRUE)

shinyUI(
  fluidPage(title = "Anzahl Autos auf der Wolbecker Straße",
  
  sidebarLayout(
    sidebarPanel(
      dateRangeInput("date_range", 
        "Wähle eine Zeitspanne:", 
        min = "2015-01-01", max = "2016-12-31", 
        start = "2015-01-01", end = "2015-12-31",
        format = "dd. MM yyyy", language = "de"),
          sliderInput("hour_range", 
                "Wähle eine Zeitspanne:", 
                min = 0, max = 24, 
                value = c(0, 24))
    ),
    mainPanel(
      
      h3(textOutput("caption")),
      
      plotOutput("plotYear",
                 click = "plot1_click",
                  brush = brushOpts(
                    id = "plot1_brush"
                  )),
      plotOutput("plotDay")
    ),
  ),
  
  hr(),
  print("lizenziert unter der GPLv3,"),
  a("mehr Infos hier", href="https://github.com/codeformuenster/kfzData#rechtliches"),
  HTML("<br>"),
  print("Datenquelle: Stadt Münster (lizenziert unter Datenlizenz Deutschland - Namensnennung - Version 2.0)")
))
