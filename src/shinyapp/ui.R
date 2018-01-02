# This program is free software.
# You should have received a copy of the GNU General Public License
# along with this program (file COPYING). If not, see <http://www.gnu.org/licenses/>.

# USER INTERFACE OF THE SHINY APP

# load libraries ####
# use 00_install_R_packages.R for installing missing packages
lapply(c("shiny"),
			 require, character.only = TRUE)

shinyUI(
	fluidPage(
		title = "Anzahl Fahrzeuge auf der Wolbecker Straße",
		#sidebarLayout(
		# sidebarPanel(
		fluidRow(
		column(2,
					 wellPanel(
					 	dateRangeInput(
					 		"date_range",
					 		"Wähle eine Zeitspanne:",
					 		min = "2015-01-01",
					 		max = "2016-12-31",
					 		start = "2015-01-01",
					 		end = "2015-12-31",
					 		format = "dd. M yyyy",
					 		language = "de"
					 	),
					 	sliderInput(
					 		"hour_range",
					 		"Wähle eine Zeitspanne:",
					 		min = 0,
					 		max = 24,
					 		value = c(0, 24)
					 	),
					 	selectInput("vehicle", "Verkehrsmittel:", c("Fahrräder" = "bikes", "Autos" = "cars", "Fahrräder & Autos" = "both")),
					 	selectInput("location", "Ort:", c("Neutor" = "'Neutor'", "Wolbecker" = "'Wolbecker.Straße'"))
					 )),
		#mainPanel(
		column(5,
			h3(textOutput("caption")),
			
			plotOutput(
				"plotYear",
				click = "plot1_click",
				brush = brushOpts(id = "plot1_brush")
			)
		),
		column(5,
					 plotOutput("plotDay")
		)
		#),
	),
	fluidRow(
		column(12,
		hr(),
		print("lizenziert unter der GPLv3,"),
		a("mehr Infos hier", href = "https://github.com/codeformuenster/kfzData#rechtliches"),
		HTML("<br>"),
		print(
			"Datenquelle: Stadt Münster (lizenziert unter Datenlizenz Deutschland - Namensnennung - Version 2.0)"
		)
	)
)
)
)
