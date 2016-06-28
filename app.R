#Read in Packages 

if (!require('devtools')) install.packages('devtools')
devtools::install_github('byzheng/leafletplugins')  
devtools::install_github('byzheng/leaflet')
library(leaflet)
library(leafletplugins)
library(shiny)
library(rgdal)
library(magrittr)
library(raster)
 
  
  #Read in data files 
  source("./readData.R")
  
  #Set Color Palettes
  #pal1 <- colorNumeric( palette = "GnBu", domain = Aff$Rent)
  binpal <- colorBin("Blues", Rent$Rent, 6, pretty = TRUE)
  pal2 <- colorQuantile( palette = "RdPu", domain = Aff$local_job_)
  pal3 <- colorQuantile( palette = "RdPu", domain = Aff$retail_acc)
  pal4 <- colorFactor(rainbow(4), schools$Grades)
  
  # Add in the icons
  source("./makeIcons.R")
  
  #Shiny User Interface 
  ui <- fluidPage(
    titlePanel("New American Pathways Housing Scout"),
    sidebarLayout( 
      sidebarPanel(
        checkboxGroupInput(
          "CheckOptions", "Show:",
          c("Apartment Complexes" = "apt",
            "Transit" = "tran",
            "Schools" = "skl",
            "Supermarkets" = "sup",
            "Faith Centers" = "faith",
            "ESL Resources" = "esl",
            "DDS Offices" = "dds",
            "DFCS Offices" = "dfacs",
            "SSN Offices" = "ssn",
            "Hospitals" = "hosp")
        ),
        #selectizeInput(
        #'e1', 'Search', choices = Apartments, multiple = TRUE),
        h4("Legend", align = "center"), h5("Schools"), 
        
                   img(src = "school-p1.png", height = 25, width = 25), "Elementary School", br(),
                   img(src = "school-m1.png", height = 25, width = 25), "Middle School", br(),
                   img(src = "school-h1.png", height = 25, width = 25), "High School", br(),
                   img(src = "school-21.png", height = 25, width = 25), "Other Schools", br(),
                   br(), img(src = "apartment-3.png", height = 35, width = 25), "Apartments", br(),
                   img(src = "shopping_cart.png", height = 25, width = 25), "Supermarkets", br(),
                  img(src = "SSN.png", height = 25, width = 25), "SSN Offices", br(),
                  img(src = "esl.png", height = 25, width = 25), "ESL Classes", br(),
                  img(src = "DMV.png", height = 25, width = 25), "DDS Offices", br(),
                  img(src = "dfacs.png", height = 25, width = 25), "DFCS Offices", br(),
                  img(src = "hospital-2.png", height = 25, width = 25), "Hospitals", br(),
                   br(), h5("Places to Worship"),
                   img(src = "cross-2.png", height = 25, width = 25), "Church", br(), 
                   img(src = "mosque.png", height = 25, width = 25), "Mosque", br(),
                   img(src = "synagogue-2.png", height = 25, width = 25), "Synagogue", br(), 
                   img(src = "templehindu.png", height = 25, width = 25), "Hindu Temple", br(),
                   img(src = "prayer.png", height = 25, width = 25), "Other worship places",
                   width = 3), 
      
      
      mainPanel(
      leafletOutput("mymap", height = "580", width = "1000"))
  )
  )
  
  #Shiny Server
  server <- function(input, output, session) {
    output$mymap <- renderLeaflet({
      leaflet() %>%
        ### Street Tiles 
        addTiles(group = "Streets")%>%
        #addControlFullScreen()%>%
        
        ### Grey Basemap 
        addTiles(urlTemplate = "http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png", "Default") %>% 
        ### Set Default View to Atlanta 
        setView(-84.3851808,33.785859,  zoom = 10)%>%
        
        ### Average Rent Shape Overlay 
        addPolygons(data = Rent, stroke = FALSE, fillOpacity = 0.5, smoothFactor = 0.5, 
                    group = "Affordability", color = ~binpal(Rent))%>%
        ### Crime layer
        addRasterImage(Crime, colors = "YlOrRd", opacity = 0.5, group = "Crime")%>%
        
        ### Jobs Layer
        addPolygons(data = Aff, stroke = FALSE, fillOpacity = 0.5, smoothFactor = 0.5,
                    group = "Jobs", color = ~pal2(local_job_))%>%
        ### Retail Layer
        addPolygons(data = Aff, stroke = FALSE, fillOpacity = 0.5, smoothFactor = 0.5,
                    group = "Retail", color = ~pal3(retail_acc))%>%
        
        ### Apartment Complexes as Markers 
        addMarkers(lat = ~ latitude, lng = ~ longitude, data = Apartments, 
                   popup = paste("<a href=", Apartments$website_url,  
                                 "<b>", Apartments$apartment_name, "</b>","</a>", "<br>",
                                 Apartments$phone, "<br>",
                                 Apartments$property_address, "<br>",
                                 "Approximate Travel Time to NAP office:", Apartments$duration_text
                            ), clusterOptions = markerClusterOptions(iconCreateFunction=JS("function (cluster) {    
      var childCount = cluster.getChildCount(); 
      var c = ' marker-cluster-';  
                               if (childCount < 100) {  
                               c += 'large';  
                               } else if (childCount < 1000) {  
                               c += 'medium';  
                               } else { 
                               c += 'small';  
                               }    
                               return new L.DivIcon({ html: '<div><span>' + childCount + '</span></div>', className: 'marker-cluster' + c, iconSize: new L.Point(40, 40) });
                                                                                                                           
    }")),group = "Units", 
                   icon = aptIcon)%>%
      
        ### Bus Stops 
        addCircles(lat = ~ Lat, lng = ~ Lon, data = TStops, color = "#ffa500", weight = 1, 
                 popup = paste(TStops$name, "<br>",
                               TStops$agency, "<br>"), group = "Transit")%>%
      
        ### Schools 
        addMarkers(lat = ~ latitude, lng = ~longitude,  data = schools, 
                 popup = paste("<a href=", schools$website,
                               "<b>", schools$school_name, "</b>","</a>", "<br>",
                               schools$school_type, "<br>",
                               schools$address, "<br>",
                               schools$phone, "<br>",
                               "Free and Reduced Lunch (%): ", schools$freeandreducedLunch, "<br>"), 
                 group = "Schools", icon = schoolIcon)%>%
      
        #Supermarkets
        addMarkers(lat = ~ latitude, lng = ~ longitude, data = Markets, 
                   popup = paste(Markets$place_name, "<br>",
                                 Markets$property_address), 
                   group = "Markets", icon = shopIcon)%>%
        
        #SSN Offices
        addMarkers(lat = ~ latitude, lng = ~ longitude, data = SSNs, 
                   popup = paste(SSNs$place_name, "<br>",
                                 SSNs$property_address, "<br>",
                                 SSNs$phone), 
                   group = "SSNs", icon = ssnIcon)%>%
        
        #Hospitals
        addMarkers(lat = ~ latitude, lng = ~ longitude, data = Hospitals, 
                   popup = paste(Hospitals$place_name, "<br>",
                                 Hospitals$property_address, "<br>",
                                 Hospitals$phone, "<br>",
                                 Hospitals$opening_hours), 
                   group = "Hospitals", icon = hospitalIcon)%>%
        
        #ESL Resources
        addMarkers(lat = ~ latitude, lng = ~ longitude, data = ESL, 
                   popup = paste(ESL$place_name, "<br>",
                                 ESL$property_address, "<br>",
                                 ESL$phone), 
                   group = "ESL", icon = eslIcon)%>%
        
        #DDS Offices
        addMarkers(lat = ~ latitude, lng = ~ longitude, data = DDS, 
                   popup = paste(DDS$place_name, "<br>",
                                 DDS$property_address, "<br>",
                                 DDS$phone), 
                   group = "DDS", icon = ddsIcon)%>%
        
        #DFACS Offices
        addMarkers(lat = ~ latitude, lng = ~ longitude, data = DFACs, 
                   popup = paste(DFACs$place_name, "<br>",
                                 DFACs$property_address, "<br>",
                                 DFACs$phone), 
                   group = "DFACS", icon = dfacsIcon)%>%
        
        
        ### Faith Centers
        addMarkers(lat = ~ latitude, lng = ~ longitude, data = Faith, 
                   popup = paste(Faith$place_name, "<br>",
                                 Faith$property_address),
                   group = "Faith Centers", icon = faithIcons)%>%
        
        # Search Layer
        #addSearchMarker('marker', position='topleft', propertyName = 'popup')%>%
        
        ### Layer Toggling 
        addLayersControl(baseGroups = c( "Default", "Streets", "Affordability", "Jobs", "Retail", "Crime" )
                         ,options = layersControlOptions(collapsed = FALSE))%>%
        ### Add Legend 
        addLegend("bottomright", pal = binpal, values = Aff$Rent , title = "Average Rent",
                  labFormat = labelFormat(prefix = "$"), opacity = 1)%>%
        #addLegend("bottomleft", pal = pal4, value = Schools$Grades, title= "Schools", opacity = 1)%>%
        addLegend("bottomleft", pal = pal2, value = Aff$local_job_, title = "Neighborhood Percentile", opacity = 1)
      
    })
    
    observe({
      
      proxy <- leafletProxy("mymap")
      
      if ('apt' %in% input$CheckOptions) {
        proxy %>%  showGroup("Units") } else {
          leafletProxy("mymap") %>% hideGroup("Units") }
      
          
      if ('tran' %in% input$CheckOptions) {
        proxy %>% showGroup("Transit") } else {
          leafletProxy("mymap") %>% hideGroup("Transit") }
      
      if ('skl' %in% input$CheckOptions) {
        proxy %>%  showGroup("Schools") } else {
          leafletProxy("mymap") %>% hideGroup("Schools") }
      
      if ('hosp' %in% input$CheckOptions) {
        proxy %>%  showGroup("Hospitals") } else {
          leafletProxy("mymap") %>% hideGroup("Hospitals") }
      
        
      if('sup' %in% input$CheckOptions) {
          proxy %>%  showGroup("Markets") } else {
            leafletProxy("mymap") %>% hideGroup("Markets") }
      
      if('esl' %in% input$CheckOptions) {
        proxy %>%  showGroup("ESL") } else {
          leafletProxy("mymap") %>% hideGroup("ESL") }
      
      if('dfacs' %in% input$CheckOptions) {
        proxy %>%  showGroup("DFACS") } else {
          leafletProxy("mymap") %>% hideGroup("DFACS") }
      
      if('dds' %in% input$CheckOptions) {
        proxy %>%  showGroup("DDS") } else {
          leafletProxy("mymap") %>% hideGroup("DDS") }
      
      if('ssn' %in% input$CheckOptions) {
        proxy %>%  showGroup("SSNs") } else {
          leafletProxy("mymap") %>% hideGroup("SSNs") }
        
        
        if ('faith' %in% input$CheckOptions) {
          proxy %>%  showGroup("Faith Centers") } else {
            leafletProxy("mymap") %>% hideGroup("Faith Centers") }
    })
  }
  
  shinyApp(ui = ui, server = server)
  
