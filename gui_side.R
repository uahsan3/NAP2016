#Shiny User Interface
ui <- fluidPage(
  titlePanel("New American Pathways Housing Scout"),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput(
        "CheckOptions", "Show:",
        c(
          "Apartment Complexes" = "apt",
          "Transit" = "tran",
          "Schools" = "skl",
          "Supermarkets" = "sup",
          "Faith Centers" = "faith",
          "ESL Resources" = "esl",
          "DDS Offices" = "dds",
          "DFCS Offices" = "dfacs",
          "SSN Offices" = "ssn",
          "Hospitals" = "hosp"
        )
      ),#checkboxGroupInput
      
      sliderInput("jobs_slider", "Importance of jobs access", 0, 100, 50, step = 1),
      sliderInput("retail_slider", "Importance of retail access", 0, 100, 50, step = 1),
      sliderInput("rent_slider", "Importance of rent price", 0, 100, 50, step = 1),
      sliderInput("schools_slider", "Importance of proximity to schools", 0, 100, 50, step = 1),
      sliderInput("supermarkets_slider", "Importance of proximity to supermarkets",0, 100, 50, step = 1),
      
      h4("Legend", align = "center"), h5("Schools"),
      
      img(src = "school-p1.png", height = 25, width = 25), "Elementary School", br(),
      img(src = "school-m1.png", height = 25, width = 25), "Middle School", br(),
      img(src = "school-h1.png", height = 25, width = 25), "High School", br(),
      img(src = "school-21.png", height = 25, width = 25), "Other Schools", br(),
      
      img(src = "apartment-3.png"), "Apartments", br(),
      div(style = "display:inline-block", img(src = "shopping_cart.png"), "Supermarkets", style = "float:right"),
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
      img(src = "prayer.png", height = 25, width = 25), "Other worship places"
      
  ),#sidebarPanel
  
  mainPanel(leafletOutput("mymap", height = "580", width = "1000"))#mainPanel
  
)#sidebarLayout
)#ui <- fluidPage