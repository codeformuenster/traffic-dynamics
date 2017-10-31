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
         FROM car_data
         WHERE location LIKE '%09040%'", 
        dbname = "../../data/database/kfz_data.sqlite") 

p <- list()

p[["year"]][["grouped"]] <-
  wolbecker %>%
  group_by(direction, date) %>%
  summarise(count_day = sum(count)) %>%
  ggplot(data = ., aes(x = date, y = count_day)) +
  geom_line(aes(group = direction, color = direction)) +
  theme_minimal(base_size = 18)

p[["year"]][["ungrouped"]] <-
wolbecker %>%
  group_by(date) %>%
  summarise(count_day = sum(count)) %>%
  ggplot(data = ., aes(x = date, y = count_day)) +
  geom_line(group = 1) +
  theme_minimal(base_size = 18)

p[["day"]][["grouped"]] <-
  wolbecker %>%
  ggplot(data = ., aes(x = hour, y = count)) +
  geom_line(aes(group = interaction(date, direction), color = direction),
            alpha = .2) +
  theme_minimal() +
  theme_minimal(base_size = 18)

p[["day"]][["ungrouped"]] <-
wolbecker %>%
  group_by(date, hour) %>%
  summarise(count_sum = sum(count)) %>%
  ggplot(data = ., aes(x = hour, y = count_sum)) +
  geom_line(aes(group = date),
            alpha = .2) +
  theme_minimal() +
  theme_minimal(base_size = 18)


# Define server logic required to plot
shinyServer(function(input, output) {
  
  # Return the formula text for printing as a caption
  output$caption <- renderText({
    paste("Time scale: ", input$scale)
  })
  
  # Generate a plot of the requested scale
  output$plot <- renderPlot({
    p[[input$scale]][[ifelse(input$grouping, "grouped", "ungrouped")]]
  })
})
