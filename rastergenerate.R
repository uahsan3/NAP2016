# Reactive expression to compose a data frame containing all of
# the values
getRasterImage <- reactive({
  
  # these should be user selected by sliders 
  J <- 100
  R <- 100
  E <- input$public_transit_slider
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
  Color = colorBin("YlOrRd", domain = Show, bins = 100)

}) 




#plot 
leaflet() %>% addTiles("http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png") %>%
  setView(-84.3851808,33.785859,  zoom = 10)%>%
  addRasterImage(A, opacity = 0.5, colors = Color)

