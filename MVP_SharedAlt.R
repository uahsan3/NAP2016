#Read in Packages 
library(shiny)
library(leaflet)
library(rgdal)
library(magrittr)

#Set Working Directory to NAP folder
setwd("C:/Users/Jack/Dropbox/MVP")

#Read in data files 
Apartments <- read.csv( file = "Apartments.csv", header = TRUE, sep = ",") 
Schools <- read.csv( file = "Schools.csv", header = TRUE, sep = ",")
TStops <- read.csv( file = "TStops.csv", header = TRUE, sep = ",") 
Aff <- readOGR(".","Afford")
Faith <- read.csv( file = "Faith.csv", header = TRUE, sep = ",")
Markets <- read.csv( file = "Markets.csv", header = TRUE, sep = ",")

#Set Color Palettes
pal1 <- colorQuantile( palette = "RdPu", domain = Aff$blkgrp_med)
pal2 <- colorQuantile( palette = "RdPu", domain = Aff$local_job_)
pal3 <- colorQuantile( palette = "RdPu", domain = Aff$retail_acc)
pal4 <- colorFactor(rainbow(4), Schools$Grades)

#Shiny User Interface 
ui <- fluidPage(
  titlePanel("New American Pathways Housing Scout"),
  
  mainPanel(
    leafletOutput("mymap", height = "580", width = "1320"))
)

#Shiny Server
server <- function(input, output, session) {
  output$mymap <- renderLeaflet({
    leaflet() %>%
      ### Street Tiles 
      addTiles(group = "Streets")%>%
      ### Grey Basemap 
      addTiles(urlTemplate = "http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png", "Default") %>% 
      ### Set Default View to Atlanta 
      setView(-84.3851808,33.785859,  zoom = 10)%>%
      ### Bus Stops 
      addCircles(lat = ~ Lat, lng = ~ Lon, data = TStops, color = "#ffa500", weight = 1, group = "Transit")%>%
      ### Schools 
      addCircles(lat = ~ latitude, lng = ~longitude, stroke = TRUE, data = Schools, color = ~pal4(Grades) , weight = 5,  popup = Schools$school_name, group = "Schools")%>%
      ### Markets 
      addCircles(lat = ~ latitude, lng = ~longitude, stroke = TRUE, data = Markets, color = "#ffff00" , weight = 5,  popup = Markets$market_name, group = "Markets")%>%
      ### Faith Centers
      addCircles(lat = ~ latitude, lng = ~longitude, stroke = TRUE, data = Faith, color = "#ff00ff" , weight = 5,  popup = Faith$place_name, group = "Faith Centers")%>%
      ### Apartment Complexes as Markers 
      addMarkers(lat = ~ latitude, lng = ~ longitude, data = Apartments, popup = Apartments$apartment_name, clusterOptions = markerClusterOptions(), group = "Units")%>%
      ### Median Income Shape Overlay 
      addPolygons(data = Aff, stroke = FALSE, fillOpacity = 0.5, smoothFactor = 0.5, group = "Affordability", color = ~pal1(blkgrp_med))%>%
      ### Jobs Layer
      addPolygons(data = Aff, stroke = FALSE, fillOpacity = 0.5, smoothFactor = 0.5, group = "Jobs", color = ~pal2(local_job_))%>%
      ### Retail Layer
      addPolygons(data = Aff, stroke = FALSE, fillOpacity = 0.5, smoothFactor = 0.5, group = "Retail", color = ~pal3(retail_acc))%>%
      ### Layer Toggling 
      addLayersControl(overlayGroups = c("Units", "Transit", "Schools", "Faith Centers", "Markets"), baseGroups = c( "Default", "Streets", "Affordability", "Jobs", "Retail" ),options = layersControlOptions(collapsed = FALSE))%>%
      ### Add Legend 
      addLegend("bottomright", pal = pal1, values = Aff$blkgrp_med , title = "Neighborhood Percentile", labFormat = labelFormat(prefix = "$"), opacity = 1)%>%
      addLegend("bottomleft", pal = pal4, value = Schools$Grades, title= "Schools", opacity = 1)
    
  })
}

shinyApp(ui = ui, server = server)

