# This program is free software.
# You should have received a copy of the GNU General Public License
# along with this program (file COPYING). If not, see <http://www.gnu.org/licenses/>.

# SERVER LOGIC FOR THE SHINY APP

# load libraries ####
# use 00_install_R_packages.R for installing missing packages
lapply(c("shiny", "datasets", "RSQLite", "dplyr", "sqldf", "ggplot2"), 
       require, character.only = TRUE)

# wolbecker_cars <- 
#   sqldf("SELECT 
#          date, hour, count, location,
#          CASE location
#            WHEN 'MQ_09040_FV3_G (MQ1034)' THEN 'entering_city'
#            WHEN 'MQ_09040_FV1_G (MQ1033)' THEN 'leaving_city'
#            END 'direction'
#          FROM cars
#          WHERE location LIKE '%09040%'", 
#         dbname = "../../data/database/traffic_data.sqlite") 
# TODO only one dataframe ... shiny-interactive SQL statements?
wolbecker_bikes <- 
  sqldf("SELECT 
         date, hour, count, location
         FROM bikes
         WHERE location LIKE 'Neutor'", 
        dbname = "../../data/database/traffic_data.sqlite")
head(wolbecker_bikes)
wolbecker_bikes$direction = rep("unknown", nrow(wolbecker_bikes))

# Define server logic required to plot
shinyServer(function(input, output) {
  
  # Return the formula text for printing as a caption
  output$caption <- renderText({
    paste("Time scale: ", input$scale)
  })
  
  filteredHourData <- reactive({
    wolbecker_bikes %>% 
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
    wolbecker_bikes %>%
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
