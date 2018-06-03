#Load libraries
library(shiny)
library(shinyWidgets)
library(leaflet)
library(shinydashboard)

#Load the Coordinates file
Coordinates = read.csv('DoDAAC and Ping Coordinates.csv')
Coordinates$DoDAAC = ifelse(is.na(Coordinates$DoDAAC), "NULL", as.character(Coordinates$DoDAAC))
Coordinates$JourneyStartDate = as.Date(Coordinates$JourneyStartDate, "%m/%d/%Y")
Coordinates$DoDAAC = as.factor(Coordinates$DoDAAC)

#Build Server Interface
server = shinyServer(function(input, output, session)
{
  group <- reactive({
     if(!is.null(input$missionID))
      {
    Coordinates[Coordinates$MissionID == input$missionID,]
     }
    
    else if (!is.null(input$dates))
    {
    Coordinates[Coordinates$JourneyStartDate >= input$dates[1] & Coordinates$JourneyStartDate <= input$dates[2] ,]
    }
      
    else if(!is.null(input$DODAACID))
    {
    Coordinates[Coordinates$DoDAAC == input$DODAACID,]
    }
    
    else if(!is.null(input$missionID) & !is.null(input$DODAACID))
    {
    Coordinates[(Coordinates$DoDAAC == input$DODAACID) & (Coordinates$MissionID == input$missionID),]
    }
    
    else if(!is.null(input$missionID) & !is.null(input$DODAACID) & !is.null(input$dates))
    {
     Coordinates[Coordinates$DoDAAC == input$DODAACID & Coordinates$MissionID == input$missionID & Coordinates$JourneyStartDate >= input$dates[1] & Coordinates$JourneyStartDate <= input$dates[2],]
    }
    
  #  else if(!is.null(input$VehicleCost))
   # {
  #    Coordinates[Coordinates$VehicleCost == input$VehicleCost,]
  #  }
    else
      Coordinates[1,]
    }
  )
  
 #Table Output Reactive 
output$dodaacids <-  renderTable({
  filtereddata = group()
  unique(as.character(filtereddata[filtereddata$DoDAAC!= 'NULL',4]))},
  caption.placement = getOption("xtable.caption.placement", "top"),
  caption.width = getOption("xtable.caption.width", NULL),
  bordered = T,stripped = T, caption = "<font face = 'Helvetica' color = 'black'><h5><b>DODAACs:</b></h5></font>")
  
    #selectizeInput(inputId = "DODAACID", "Select DoDAAC:", options = list(placeholder = "Enter DoDAAC"), choices = as.list(unique(filtereddata$DoDAAC)), multiple = T )
    #selectizeInput("missionID", "Enter mission ID: ",options = list(placeholder = "Mission ID"), choices = unique(Coordinates$MissionID), multiple = T),
    

#output$NotificationID <- renderText({
#  filtereddata <- group()
#  if(((filtereddata$Lat>35) & (filtereddata$Lng>67)))
# "Crossed Geofence"
 # else
#    "Within Geofence"
#})
  

  
#output$text <- renderText({ input$DODAACID})
  
#  output$missionIDUI  = renderUI
 # (
  #  {
  #    if(is.null(input$missionID) & !is.null(input$DODAACID))
  #    {
   #     selectizeInput("missionIDreactive", "Select mission IDs related to the DoDAAC selected:", choices = unique(Coordinates[Coordinates$DoDAAC == input$DODAACID,3]), multiple = T)
#      }
 #   }
#  )
  
#  output$DODAACIDUI  = renderUI
#  (
#    {
#      if(is.null(input$missionID) & !is.null(input$DODAACID))
#      {
#        selectizeInput("DODAACIDreactive", "Select DODAAC IDs related to the missions selected:", choices = unique(Coordinates[Coordinates$MissionID == input$missionID,4]), multiple = T)
#      }
#    }
#  )
  #NotificationCount <- reactiveValues(counter = 0)
  


#output$Notifications<-  renderText({
 #paste("Crossed Geofence Notifications is:", NotificationCount$counter)
  #})
    
  #Display Map Reactive
  output$CoordinatesMap = renderLeaflet(
    {
      #Create Truck Icon
      Icon = makeIcon(iconUrl = 'http://feedus.media/wp/wp-content/uploads/leaflet-maps-marker-icons/foodtruck_pin.png', iconWidth = 40, iconHeight = 70, iconAnchorX = 25, iconAnchorY = 25)
      
      
      #Leaflet Map output
   leaflet() %>%
   addTiles('http://{s}.tile.thunderforest.com/transport/{z}/{x}/{y}.png?apikey=b853f4f2a0e64a6e9a60ba632ac775ff')  %>%
   fitBounds(min(Coordinates$Lng), min(Coordinates$Lat), max(Coordinates$Lng), max(Coordinates$Lat)) 
      }
  )
  
  

  observe ({
    filtereddata <- group()
      map = leafletProxy("CoordinatesMap", data= filtereddata) %>%
        clearMarkers() %>%
      #, data = filtereddata()) %>%
     addMarkers(lat = filtereddata$Lat, lng = filtereddata$Lng, icon = Icon,  popup = paste("<b>Mission ID:    </b>", unique(filtereddata$MissionID), "<br>", "<b>Vehicle Cost:    </b>$", unique(filtereddata$VehicleCost),"<br>","<b>Total Security Cost:    </b>$", unique(filtereddata$TotalSecurityCost),"<br>", "<b>Total Pallets:    </b>", unique(filtereddata$TotalPallets),"<br>", "<b> Total Cases:    </b>", unique(filtereddata$TotalCases),"<br>", "<b> Cost Per Pallet:    </b>$", unique(filtereddata$CostPerPallet),"<br>", "<b>Cost Per Case:    </b>$", unique(filtereddata$CostPerCase),"<br>", "<b>Total Customers:    </b>", unique(filtereddata$TotalCustomers), "<br>", "<b>Journey Start Date:   </b>",filtereddata$JourneyStartDate)) # %>%
      addMarkers(map,lat = filtereddata[filtereddata$DoDAAC!= 'NULL', 1], lng = filtereddata[filtereddata$DoDAAC!= 'NULL', 2], popup = paste("<b>DoDAAC:</b>", filtereddata$DoDAAC,"<br>", "<b> Mission ID </b>", filtereddata$MissionID))
      addCircleMarkers(map,lat = runif(10, min = 31.5,max = 37), lng = runif(10, min = 64, max = 71), radius = runif(10, min = 10, max = 40), color = "blue", fillOpacity = 0.2, popup = "Geofence")
      #addRectangles(map, lat1 = runif(10, min = 31.5,max = 37), lng1 = runif(10, min = 64, max = 71), lat2 =runif(10, min = 33.5,max = 35) , lng2 = runif(10, min = 65.5, max = 67) , color = "red", fillOpacity = 0.2)
      #addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5, opacity = 1.0, fillOpacity = 0.5)
   ifelse(filtereddata$Lat>35 & filtereddata$Lng>65,showNotification("Crossed the Geofence!", duration = 4, type = "error"),showNotification("Within the Geofence!", duration = 4, type = "message"))
          }) 
   
    
    
  

  #obsserve({
   # filtereddata <- group()
  #  if(filtereddata$Lat>36 & filtereddata$Lng>65)
   #   output$NotificationID <- renderText("Crossed the geofence!")
  #})
  
  #Display Table filled with data about the options selected
  output$Table = renderDataTable(group())
  }
)


 


