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

library(shiny)

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
