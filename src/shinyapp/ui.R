library(shiny)

# Define UI for miles per gallon application
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Cars on 'Wolbecker Str.'"),
  
  sidebarPanel(
    selectInput("scale", "Time scale:",
                list("Year" = "year",
                     "Day" = "day")),
    
    checkboxInput("grouping", "Group by direction")
  ),
  
  mainPanel(
    
    h3(textOutput("caption")),
    
    plotOutput("plot")
  )
))
