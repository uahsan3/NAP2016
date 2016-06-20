#Read in Packages 
library(shiny)
library(leaflet)
library(rgdal)
library(magrittr)

#Set Working Directory to NAP folder
#setwd("C:/Users/Jack/Dropbox/MVP")
#setwd("C:/Users/uahsan3/Dropbox/MVP")

#Read in data files 
Apartments <- read.csv( file = "Apartments.csv", header = TRUE, sep = ",") 
schools <- read.csv( file = "Schools.csv", header = TRUE, sep = ",")
TStops <- read.csv( file = "TStops.csv", header = TRUE, sep = ",") 
Aff <- readOGR(".","Afford")
Markets <- read.csv( file = "Markets.csv", header = TRUE, sep = ",")
Faith <- read.csv( file = "Faith.csv", header = TRUE, sep = ",")

#Set Color Palettes
pal1 <- colorNumeric( palette = "GnBu", domain = Aff$blkgrp_med)
pal2 <- colorQuantile( palette = "RdPu", domain = Aff$local_job_)
pal3 <- colorQuantile( palette = "RdPu", domain = Aff$retail_acc)
pal4 <- colorFactor(rainbow(4), schools$Grades)

#Define icons
aptIcon <- makeIcon(
  iconUrl = "apartment-3.png",
  iconWidth = 40, iconHeight = 55,
  iconAnchorX = 5, iconAnchorY = 20
)

shopIcon <- makeIcon(
  iconUrl = "shopping_cart.png",
  iconWidth = 30, iconHeight = 35,
  iconAnchorX = 5, iconAnchorY = 20
)

schoolIcon <- makeIcon(
  iconUrl = ifelse(schools$Grades == "Elementary ", "school-p.png", 
                   ifelse(schools$Grades == "Middle", "school-m.png", 
                          ifelse(schools$Grades == "High", "school-h.png", "school-2.png"))),
  iconWidth = 28, iconHeight = 30,
  iconAnchorX = 5, iconAnchorY = 20
)

# Selecting the correct iconUrl
faithIcons <- icons(
  iconUrl = ifelse(Faith$place_type == "church", "cross-2.png",
                   ifelse(Faith$place_type == "mosque", "mosque.png",
                          ifelse(Faith$place_type == "synagogue", "synagogue-2.png", 
                                 ifelse(Faith$place_type == "hindu_temple", "templehindu.png",
                                        "prayer.png" )))),
  iconWidth = 25, iconHeight = 35,
  iconAnchorX = 5, iconAnchorY = 20
)

#Shiny User Interface 
ui <- fluidPage(
  titlePanel("New American Pathways Housing Scout"),
  sidebarLayout( 
    sidebarPanel(h4("Legend", align = "center"), h5("Schools"), 
                 img(src = "school-p1.png", height = 25, width = 25), "Elementary School", br(),
                 img(src = "school-m1.png", height = 25, width = 25), "Middle School", br(),
                 img(src = "school-h1.png", height = 25, width = 25), "High School", br(),
                 br(), img(src = "apartment-3.png", height = 25, width = 25), "Apartments", br(),
                 img(src = "shopping_cart.png", height = 25, width = 25), "Supermarkets", br(),
                 br(), h5("Places to Worship"), br(), 
                 img(src = "cross-2.png", height = 25, width = 25), "Church", br(), 
                 img(src = "mosque.png", height = 25, width = 25), "Mosque", br(),
                 img(src = "synagogue-2.png", height = 25, width = 25), "Synagogue", br(), 
                 img(src = "templehindu.png", height = 25, width = 25), "Hindu Temple", br(),
                 img(src = "prayer.png", height = 25, width = 25), "Other worship places",
                 width = 3), 
    mainPanel(
    leafletOutput("mymap", height = "580", width = "1100"))
)
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
      addMarkers(lat = ~ latitude, lng = ~longitude,  data = schools, 
                 popup = paste("<a href=", schools$website,
                               "<b>", schools$school_name, "</b>","</a>", "<br>",
                               schools$school_type, "<br>",
                               schools$address, "<br>",
                               schools$phone, "<br>"), 
                 group = "Schools", clusterOptions = markerClusterOptions(), icon = schoolIcon)%>%
      ### Apartment Complexes as Markers 
      addMarkers(lat = ~ latitude, lng = ~ longitude, data = Apartments, 
                 popup = paste("<a href=", Apartments$website_url,  
                               "<b>", Apartments$apartment_name, "</b>","</a>", "<br>",
                               Apartments$phone, "<br>",
                               Apartments$property_address), clusterOptions = markerClusterOptions(),group = "Units", icon = aptIcon)%>%
      #Supermarkets
      addMarkers(lat = ~ latitude, lng = ~ longitude, data = Markets, 
                 popup = paste(Markets$market_name, "<br>",
                               Markets$property_address), 
                 group = "Markets", icon = shopIcon)%>%
      ### Faith Centers
      addMarkers(lat = ~ latitude, lng = ~ longitude, data = Faith, 
                 popup = paste(Faith$place_name, "<br>",
                               Faith$property_address), clusterOptions = markerClusterOptions(),
                 group = "Faith Centers", icon = faithIcons)%>%
      ### Median Income Shape Overlay 
      addPolygons(data = Aff, stroke = FALSE, fillOpacity = 0.5, smoothFactor = 0.5, 
                  group = "Affordability", color = ~pal1(blkgrp_med))%>%
      ### Jobs Layer
      addPolygons(data = Aff, stroke = FALSE, fillOpacity = 0.5, smoothFactor = 0.5,
                  group = "Jobs", color = ~pal2(local_job_))%>%
      ### Retail Layer
      addPolygons(data = Aff, stroke = FALSE, fillOpacity = 0.5, smoothFactor = 0.5,
                  group = "Retail", color = ~pal3(retail_acc))%>%
      ### Layer Toggling 
      addLayersControl(overlayGroups = c("Units", "Transit", "Schools", "Markets"),
                       baseGroups = c( "Default", "Streets", "Affordability", "Jobs", "Retail" )
                       ,options = layersControlOptions(collapsed = FALSE))%>%
      ### Add Legend 
      addLegend("bottomright", pal = pal1, values = Aff$blkgrp_med , title = "Neighborhood Affluence",
                labFormat = labelFormat(prefix = "$"), opacity = 1)%>%
      #addLegend("bottomleft", pal = pal4, value = Schools$Grades, title= "Schools", opacity = 1)%>%
      addLegend("bottomleft", pal = pal2, value = Aff$local_job_, title = "Neighborhood Percentile", opacity = 1)
    
  })
}

shinyApp(ui = ui, server = server)

