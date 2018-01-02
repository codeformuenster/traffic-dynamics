# This program is free software.
# You should have received a copy of the GNU General Public License
# along with this program (file COPYING). If not, see <http://www.gnu.org/licenses/>.

# SERVER LOGIC FOR THE SHINY APP

# load libraries ####
# use 00_install_R_packages.R for installing missing packages
lapply(c("shiny", "datasets", "RSQLite", "dplyr", "sqldf", "ggplot2"), 
       require, character.only = TRUE)

# Define server logic required to plot
shinyServer(function(input, output) {
  
  # Return the formula text for printing as a caption
  output$caption <- renderText({
    paste("Time scale: ", input$scale)
  })

  load_data_from_db <- reactive({  
  	con <- dbConnect(SQLite(), dbname = "../../data/database/traffic_data.sqlite")
  	
  	if (input$vehicle == "bikes") {
  		sql_table = "bikes"
  		sql_location = input$location
  	} else  { 
  		# default to cars only 
  		# (for selecting both, a second SQL query is added below)
  		sql_table = "cars"
  		if(input$location == "'Wolbecker.Straße'") {
				sql_location = "'%09040%'"
  		} else if(input$location == "'Neutor'") {
  			sql_location = "'%01080%'"
  		}
  	}
  	
		sql_string <- paste0(
			"SELECT date, hour, count, location, vehicle", 
      " FROM ", sql_table,
			" WHERE location LIKE ", sql_location)
		if (input$vehicle == "both") {
	  	# add bikes
			sql_table = "bikes"
  		sql_location = input$location
	  	sql_string <-	paste0(sql_string, 
			" UNION SELECT date, hour, count, location, vehicle",
    	" FROM ", sql_table,
			" WHERE location LIKE ", sql_location)
		}
		print(sql_string)
		
		vehicles <-
	  dbGetQuery(conn = con,
				sql_string)
		
		dbDisconnect(con)
		
		print("unfiltered data")
		print(head(vehicles))
  	
		return(vehicles)
	})

  filteredYearData <- reactive({
  	vehicles <- load_data_from_db()
  	
  	vehicles_filtered <-
	    vehicles %>%
	      filter(
	        hour >= input$hour_range[1] &
	          hour <= input$hour_range[2],
	        date >= as.POSIXct(input$date_range[1]) &
	          date <= as.POSIXct(input$date_range[2])
	      ) %>% 
  			mutate(vehicle = as.factor(vehicle)) %>%
	      group_by(date, vehicle) %>%
	      summarise(count_day = sum(count))
  	
  	print("for year plot:")
  	print(head(vehicles_filtered))
    
    return(vehicles_filtered)
  })

  filteredHourData <- reactive({
  	vehicles <- load_data_from_db()
  	
  	vehicles_filtered <-
			vehicles %>% 
	      filter(
	        hour >= input$hour_range[1] &
	          hour <= input$hour_range[2],
	        date >= as.POSIXct(input$date_range[1]) & 
	          date <= as.POSIXct(input$date_range[2])
	      ) %>% 
  			mutate(vehicle = as.factor(vehicle)) %>% 
	      group_by(date, hour, vehicle) %>%
	      summarise(count_hour = sum(count))
		
	  print("for hour plot:")
	  print(head(vehicles_filtered))
	
  	return(vehicles_filtered)
  })
    
  output$plotYear <- renderPlot({
    ggplot(data = filteredYearData()) +
    geom_line(aes(x = date, y = count_day, group = vehicle, color = vehicle)) +
  	labs(x = "Datum", y = "Anzahl", color = "Verkehrsmittel") +
  	scale_color_manual(labels = c("Fahrräder", "Autos"), values = c("bike" = "blue", "car" = "red")) +
    theme_minimal(base_size = 18)
  })
  
  output$plotDay <- renderPlot({
    ggplot(data = filteredHourData(), aes(x = hour, y = count_hour)) +
    geom_line(aes(group = interaction(vehicle, date), color = vehicle), alpha = 0.2) +
    labs(x = "Stunde", y = "Anzahl", color = "Verkehrsmittel") +
  	scale_color_manual(labels = c("Fahrräder", "Autos"), values = c("bike" = "blue", "car" = "red")) +
    theme_minimal(base_size = 18)
  })
})
