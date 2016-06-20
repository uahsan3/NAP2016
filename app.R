  #Read in Packages 
  library(shiny)
  library(leaflet)
  library(rgdal)
  library(magrittr)
  
  
  #Read in data files 
  source("./readData.R")
  
  #Set Color Palettes
  #pal1 <- colorNumeric( palette = "GnBu", domain = Aff$Rent)
  binpal <- colorBin("Blues", Aff$Rent, 6, pretty = TRUE)
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
            "Faith Centers" = "faith")
        ),
        selectizeInput(
        'e1', 'Search', choices = Apartments, multiple = TRUE),
        h4("Legend", align = "center"), h5("Schools"), 
                   img(src = "school-p1.png", height = 25, width = 25), "Elementary School", br(),
                   img(src = "school-m1.png", height = 25, width = 25), "Middle School", br(),
                   img(src = "school-h1.png", height = 25, width = 25), "High School", br(),
                   img(src = "school-21.png", height = 25, width = 25), "Other Schools", br(),
                   br(), img(src = "apartment-3.png", height = 25, width = 25), "Apartments", br(),
                   img(src = "shopping_cart.png", height = 25, width = 25), "Supermarkets", br(),
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
        ### Grey Basemap 
        addTiles(urlTemplate = "http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png", "Default") %>% 
        ### Set Default View to Atlanta 
        setView(-84.3851808,33.785859,  zoom = 10)%>%
        
        ### Average Rent Shape Overlay 
        addPolygons(data = Aff, stroke = FALSE, fillOpacity = 0.5, smoothFactor = 0.5, 
                    group = "Affordability", color = ~binpal(Rent))%>%
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
                                 Apartments$property_address), clusterOptions = markerClusterOptions(iconCreateFunction=JS("function (cluster) {    
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
                   popup = paste(Markets$market_name, "<br>",
                                 Markets$property_address), 
                   group = "Markets", icon = shopIcon)%>%
        
        
        ### Faith Centers
        addMarkers(lat = ~ latitude, lng = ~ longitude, data = Faith, 
                   popup = paste(Faith$place_name, "<br>",
                                 Faith$property_address),
                   group = "Faith Centers", icon = faithIcons)%>%
        
        ### Layer Toggling 
        addLayersControl(baseGroups = c( "Default", "Streets", "Affordability", "Jobs", "Retail" )
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
      
        
      if('sup' %in% input$CheckOptions) {
          proxy %>%  showGroup("Markets") } else {
            leafletProxy("mymap") %>% hideGroup("Markets") }
        
        
        if ('faith' %in% input$CheckOptions) {
          proxy %>%  showGroup("Faith Centers") } else {
            leafletProxy("mymap") %>% hideGroup("Faith Centers") }
    })
  }
  
  shinyApp(ui = ui, server = server)
  
