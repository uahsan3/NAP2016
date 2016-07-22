#Shiny Server
server <- function(input, output, session) {
  output$mymap <- renderLeaflet({
    leaflet() %>%
      ### Street Tiles
      addTiles(group = "Streets") %>%
      #addControlFullScreen()%>%
      
      ### Grey Basemap
      addTiles(urlTemplate = "http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png", "Default") %>%
      ### Set Default View to Atlanta
      setView(-84.3851808,33.785859,  zoom = 10) %>%
      
      ### Average Rent Shape Overlay
      addPolygons(
        data = Rent, stroke = FALSE, fillOpacity = 0.5, smoothFactor = 0.5,
        group = "Affordability", color = ~ binpal(Rent)
      ) %>%
      ### Crime layer
      addRasterImage(Crime, colors = "YlOrRd", opacity = 0.5, group = "Crime") %>%
      
      ### Jobs Layer
      addPolygons(
        data = Aff, stroke = FALSE, fillOpacity = 0.5, smoothFactor = 0.5,
        group = "Jobs", color = ~ pal2(local_job_)
      ) %>%
      ### Retail Layer
      addPolygons(
        data = Aff, stroke = FALSE, fillOpacity = 0.5, smoothFactor = 0.5,
        group = "Retail", color = ~ pal3(retail_acc)
      ) %>%
      
      ### Apartment Complexes as Markers
      addMarkers(
        lat = ~ latitude, lng = ~ longitude, data = Apartments,
        popup = paste(
          "<a href=", Apartments$website_url,
          "<b>", Apartments$apartment_name, "</b>","</a>", "<br>",
          Apartments$phone, "<br>",
          Apartments$property_address, "<br>",
          "Approximate Travel Time to NAP office: ", Apartments$duration_text, "<br>",
          "Travel time to nearest school: ", Times$School_Time, "<br>",
          "Travel time to nearest supermarket: ", Times$Market_Time
        ), clusterOptions = markerClusterOptions(
          iconCreateFunction = JS(
            "function (cluster) {
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
            
  }"
)
          ),group = "Units",
icon = aptIcon
          ) %>%
      
      ### Bus Stops
      addCircles(
        lat = ~ Lat, lng = ~ Lon, data = TStops, color = "#ffa500", weight = 1,
        popup = paste(TStops$name, "<br>",
                      TStops$agency, "<br>"), group = "Transit"
      ) %>%
      
      ### Schools
      addMarkers(
        lat = ~ latitude, lng = ~ longitude,  data = schools,
        popup = paste(
          "<a href=", schools$website,
          "<b>", schools$school_name, "</b>","</a>", "<br>",
          schools$school_type, "<br>",
          schools$address, "<br>",
          schools$phone, "<br>",
          "Free and Reduced Lunch (%): ", schools$freeandreducedLunch, "<br>"
        ),
        group = "Schools", icon = schoolIcon
      ) %>%
      
      #Supermarkets
      addMarkers(
        lat = ~ latitude, lng = ~ longitude, data = Markets,
        popup = paste(Markets$place_name, "<br>",
                      Markets$property_address),
        group = "Markets", icon = shopIcon
      ) %>%
      
      #SSN Offices
      addMarkers(
        lat = ~ latitude, lng = ~ longitude, data = SSNs,
        popup = paste(
          SSNs$place_name, "<br>",
          SSNs$property_address, "<br>",
          SSNs$phone
        ),
        group = "SSNs", icon = ssnIcon
      ) %>%
      
      #Daycare Centers
      addMarkers(
        lat = ~ latitude, lng = ~ longitude, data = SSNs,
        popup = paste(
          Daycares$place_name, "<br>",
          Daycares$property_address, "<br>",
          Daycares$phone
        ),
        group = "Daycares", icon = daycareIcon
      ) %>%
      
      #Hospitals
      addMarkers(
        lat = ~ latitude, lng = ~ longitude, data = Hospitals,
        popup = paste(
          Hospitals$place_name, "<br>",
          Hospitals$property_address, "<br>",
          Hospitals$phone, "<br>",
          Hospitals$opening_hours
        ),
        group = "Hospitals", icon = hospitalIcon
      ) %>%
      
      #ESL Resources
      addMarkers(
        lat = ~ latitude, lng = ~ longitude, data = ESL,
        popup = paste(
          ESL$place_name, "<br>",
          ESL$property_address, "<br>",
          ESL$phone
        ),
        group = "ESL", icon = eslIcon
      ) %>%
      
      #DDS Offices
      addMarkers(
        lat = ~ latitude, lng = ~ longitude, data = DDS,
        popup = paste(
          DDS$place_name, "<br>",
          DDS$property_address, "<br>",
          DDS$phone
        ),
        group = "DDS", icon = ddsIcon
      ) %>%
      
      #DFACS Offices
      addMarkers(
        lat = ~ latitude, lng = ~ longitude, data = DFACs,
        popup = paste(
          DFACs$place_name, "<br>",
          DFACs$property_address, "<br>",
          DFACs$phone
        ),
        group = "DFACS", icon = dfacsIcon
      ) %>%
      
      
      ### Faith Centers
      addMarkers(
        lat = ~ latitude, lng = ~ longitude, data = Faith,
        popup = paste(Faith$place_name, "<br>",
                      Faith$property_address),
        group = "Faith Centers", icon = faithIcons
      ) %>%
      
      # Search Layer
      #addSearchMarker('marker', position='topleft', propertyName = 'popup')%>%
      
      ### Layer Toggling
      addLayersControl(
        baseGroups = c(
          "Default", "Streets", "Affordability", "Jobs", "Retail", "Crime"
        )
        ,options = layersControlOptions(collapsed = FALSE)
      ) %>%
      ### Add Legend
      addLegend(
        "bottomright", pal = binpal, values = Aff$Rent , title = "Average Rent",
        labFormat = labelFormat(prefix = "$"), opacity = 1
      ) %>%
      #addLegend("bottomleft", pal = pal4, value = Schools$Grades, title= "Schools", opacity = 1)%>%
      addLegend(
        "bottomleft", pal = pal2, value = Aff$local_job_, title = "Neighborhood Percentile", opacity = 1
      ) 
    
    })
  
  ########## output$mymap end
  
  observe({
    proxy <- leafletProxy("mymap")
    
    if ('apt' %in% input$CheckOptions) {
      proxy %>%  showGroup("Units")
    } else {
      leafletProxy("mymap") %>% hideGroup("Units")
    }
    
    if ('tran' %in% input$CheckOptions) {
      proxy %>% showGroup("Transit")
    } else {
      leafletProxy("mymap") %>% hideGroup("Transit")
    }
    
    if ('skl' %in% input$CheckOptions) {
      proxy %>%  showGroup("Schools")
    } else {
      leafletProxy("mymap") %>% hideGroup("Schools")
    }
    
    if ('hosp' %in% input$CheckOptions) {
      proxy %>%  showGroup("Hospitals")
    } else {
      leafletProxy("mymap") %>% hideGroup("Hospitals")
    }
    
    if ('sup' %in% input$CheckOptions) {
      proxy %>%  showGroup("Markets")
    } else {
      leafletProxy("mymap") %>% hideGroup("Markets")
    }
    
    if ('esl' %in% input$CheckOptions) {
      proxy %>%  showGroup("ESL")
    } else {
      leafletProxy("mymap") %>% hideGroup("ESL")
    }
    
    if ('dfacs' %in% input$CheckOptions) {
      proxy %>%  showGroup("DFACS")
    } else {
      leafletProxy("mymap") %>% hideGroup("DFACS")
    }
    
    if ('dds' %in% input$CheckOptions) {
      proxy %>%  showGroup("DDS")
    } else {
      leafletProxy("mymap") %>% hideGroup("DDS")
    }
    
    if ('ssn' %in% input$CheckOptions) {
      proxy %>%  showGroup("SSNs")
    } else {
      leafletProxy("mymap") %>% hideGroup("SSNs")
    }
  
    if ('faith' %in% input$CheckOptions) {
      proxy %>%  showGroup("Faith Centers")
    } else {
      leafletProxy("mymap") %>% hideGroup("Faith Centers")
    }
    
    if ('daycare' %in% input$CheckOptions) {
      proxy %>%  showGroup("Daycares")
    } else {
      leafletProxy("mymap") %>% hideGroup("Daycares")
    }
    
    ####### combined map ############
    
    # user selected values of sliders 
    J <- input$jobs_slider
    R <- input$retail_slider
    E <- input$rent_slider
    S <- input$schools_slider
    M <- input$supermarkets_slider
    
    #the raster equation
    Show <- ((J * index$j1) + (R * index$r1) + (E * index$e1) + (S * index$s1) + (M * index$m1))
    
    #creating raster data frame 
    I <- cbind(index$Y, index$X, Show)
    
    # create raster and project 
    A <- rasterFromXYZ(I)
    crs(A) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0" 
    
    #color pallette 
    Color = colorBin("YlOrRd", domain = Show, bins = 1000)
    
    #plot
    leafletProxy("mymap") %>% addTiles("http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png") %>%
      addRasterImage(A, opacity = 0.5, colors = Color, group = "CombinedMap")
    
    if ("combined_map" %in% input$CheckOptions)
    {
      proxy %>%  showGroup("CombinedMap")
    }
    else
    {
      leafletProxy("mymap") %>% hideGroup("CombinedMap")
    }
    
  })
  ########## observe end
  
  
  }