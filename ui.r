

#Build UI interface
ui = shinyUI(fluidPage(
  dropdownMenu(type = "notifications",
              # notificationItem(
               # text = paste(textOutput("NotificationCount ", " " ,"Crossed Geofence warnings"),
                # icon = shiny::icon("warning")
            #   ),
               notificationItem(
                 text = "12 items delivered",
                 icon("truck"),
                 status = "success"
               )
               
  ),
  
  
  
  
    #Applicaion Title
    div(class = "myTitle",titlePanel(title = "Mission Tracker")),
    
    #Sidebar with slider bar input 
    sidebarPanel(
      textOutput("NotificationID"),
    #Date Range input
    dateRangeInput("dates", "Select Journey date:",startview = "month",start = NULL, end = NULL, min = min(Coordinates$JourneyStartDate), max = max(Coordinates$JourneyStartDate)),
    
    
    #Search bar for Mission ID
    #searchInput("missionID", "Enter your search", placeholder = "Mission ID", btnSearch = icon("search"), btnReset = icon("remove"), width = "100%"),
    selectizeInput("missionID", "Enter mission ID: ",options = list(placeholder = "Mission ID"), choices = unique(Coordinates$MissionID), multiple = T),
   
     #Text Output for Notfication
    
    
     tableOutput('dodaacids'),
    textOutput("Notifications")
    
    #tableOutput("dodaacids")
    #Choices for DoDAAC
    #selectizeInput(inputId = "DODAACID", "Select DoDAAC:", options = list(placeholder = "Enter DoDAAC"), choices = unique(Coordinates$DoDAAC), multiple = T )
    #selectizeInput("missionID", "Enter mission ID: ",options = list(placeholder = "Mission ID"), choices = unique(Coordinates$MissionID), multiple = T)
    #selectizeInput(inputId = "JSDID", "Select JSD:", options = list(placeholder = "Enter Date"), choices = unique(Coordinates$JourneyStartDate), multiple = T )
    #selectizeInput(inputId = "VehicleCost", "Select cost", multiple = T, options = list(placeholder = "Enter cost"), choices = unique(Coordinates$VehicleCost) )
    #Search bar for DoDAAC ID
    #searchInput("DODAACID", "Enter your search", placeholder = "DoDAAC ID", btnSearch = icon("search"), btnReset = icon("remove"), width = "100%")
    
    #Choices for DoDAAC ID1
  #  uiOutput("DODAACIDUI"),
  #  uiOutput("missionIDUI")
  


    
    #Leaflet Output for Mission Coordinates
    #leafletOutput("MissionCoordinates", height = "500"),

    ),
    
    #Leaflet output dynamic
    mainPanel
    (
      #selectizeInput(inputId = "DODAACID", "Select DoDAAC:", options = list(placeholder = "Enter DoDAAC"), choices = unique(Coordinates$DoDAAC), multiple = T ),
      #selectizeInput("missionID", "Enter mission ID: ",options = list(placeholder = "Mission ID"), choices = unique(Coordinates$MissionID), multiple = T),
      #textOutput("NotificationID"),
      leafletOutput("CoordinatesMap"),
      dataTableOutput("Table")
      
     )
    
  )
)


