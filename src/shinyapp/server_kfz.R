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
library(datasets)
library(RSQLite)
library(sqldf)
library(dplyr)
library(ggplot2)

wolbecker <- 
  sqldf("SELECT 
         date, hour, count, location,
         CASE location
           WHEN 'MQ_09040_FV3_G (MQ1034)' THEN 'entering_city'
           WHEN 'MQ_09040_FV1_G (MQ1033)' THEN 'leaving_city'
           END 'direction'
         FROM kfz_data
         WHERE location LIKE '%09040%'", 
        dbname = "../../data/processed/kfz_data.sqlite") 

# Define server logic required to plot
shinyServer(function(input, output) {
  
  # Return the formula text for printing as a caption
  output$caption <- renderText({
    paste("Time scale: ", input$scale)
  })
  
  filteredHourData <- reactive({
    wolbecker %>% 
      filter(
        hour > input$hour_range[1] &
          hour < input$hour_range[2],
        date > as.POSIXct(input$date_range[1]) & 
          date < as.POSIXct(input$date_range[2])
      ) %>% 
      group_by(date, direction, hour) %>%
      summarise(count_sum = sum(count))
    })
    
  filteredYearData <- reactive({
    wolbecker %>%
      filter(
        hour > input$hour_range[1] &
          hour < input$hour_range[2],
        date > as.POSIXct(input$date_range[1]) &
          date < as.POSIXct(input$date_range[2])
      ) %>% 
      group_by(date, direction) %>%
      summarise(count_day = sum(count))
  })

  output$plotYear <- renderPlot({
    ggplot(data = filteredYearData(), aes(x = date, y = count_day)) +
    geom_line(aes(group = direction, color = direction)) +
    theme_minimal(base_size = 18)
  })
  
  output$plotDay <- renderPlot({
    ggplot(data = filteredHourData(), aes(x = hour, y = count_sum)) +
    geom_line(aes(group = interaction(date, direction), color = direction), alpha = .2) +
    theme_minimal(base_size = 18)
  })
})
