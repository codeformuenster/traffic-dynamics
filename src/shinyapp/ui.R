library(shiny)

# Define UI for miles per gallon application
shinyUI(fluidPage(theme = "bootstrap.css",
  
  # Application title
  headerPanel("Cars on 'Wolbecker Str.'"),
  
  sidebarPanel(

    helpText("Show historical time series"),

    radioButtons("scale", "Time scale:",
                 c("Year" = "year",
                   "Day" = "day")),

    checkboxInput("grouping", "Group by direction"),

    helpText("Predict new time lines"),
    
    # TODO: remove blue bar from slider
    sliderInput("month", "Month (JAN - DEC)", min = 1, max = 12, value = 6,
                ticks = T),
    sliderInput("weekday", "Day of week (MON - SUN)", min = 1, max = 7, 
                value = 3, ticks = T),
    selectInput("weather", "Weather", c("Rain" = "rain", "Snow" = "snow")),
    actionButton("button", "Predict traffic!")
  ),

  mainPanel(

    h3(textOutput("caption")),

    plotOutput("plot")
    # TODO: plot both cyclists and cars (in one plot each)
  )
))
