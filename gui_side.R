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
          "Hospitals" = "hosp",
          "Daycare Centers" = "daycare",
          "Show weighted map" = "combined_map"
        )
      ),#checkboxGroupInput
      
      #checkboxInput('combined_map', 'Show weighted map', value = FALSE, width = NULL),
      
      sliderInput("jobs_slider", "Importance of jobs access", 0, 100, 50, step = 1),
      sliderInput("retail_slider", "Importance of retail access", 0, 100, 50, step = 1),
      sliderInput("rent_slider", "Importance of rent price", 0, 100, 50, step = 1),
      sliderInput("schools_slider", "Importance of proximity to schools", 0, 100, 50, step = 1),
      sliderInput("supermarkets_slider", "Importance of proximity to supermarkets",0, 100, 50, step = 1),
      
      h4("Legend", align = "center"), 
      
      img(src = "apartment-3.png", height = 25, width = 25), "Apartments", br(),
      img(src = "shopping_cart.png", height = 25, width = 25), "Supermarkets", br(),
      img(src = "SSN.png", height = 25, width = 25), "SSN Offices", br(),
      img(src = "esl.png", height = 25, width = 25), "ESL Classes", br(),
      img(src = "DMV.png", height = 25, width = 25), "DDS Offices", br(),
      img(src = "dfacs.png", height = 25, width = 25), "DFCS Offices", br(),
      img(src = "hospital-2.png", height = 25, width = 25), "Hospitals", br(),
      img(src = "daycare.png", height = 25, width = 25), "Daycare Centers", br(),
      
      br(), h5("Schools"),
      
      img(src = "school-p1.png", height = 25, width = 25), "Elementary School", br(),
      img(src = "school-m1.png", height = 25, width = 25), "Middle School", br(),
      img(src = "school-h1.png", height = 25, width = 25), "High School", br(),
      img(src = "school-21.png", height = 25, width = 25), "Other Schools", br(),
      
      br(), h5("Places to Worship"),
      img(src = "cross-2.png", height = 25, width = 25), "Church", br(),
      img(src = "mosque.png", height = 25, width = 25), "Mosque", br(),
      img(src = "synagogue-2.png", height = 25, width = 25), "Synagogue", br(),
      img(src = "templehindu.png", height = 25, width = 25), "Hindu Temple", br(),
      img(src = "prayer.png", height = 25, width = 25), "Other worship places"
      
  ),#sidebarPanel
  
  mainPanel(
        tabsetPanel(
          tabPanel("Main Map", leafletOutput("mymap", height = "580", width = "1000")),
          tabPanel("Update Apartments", 
                   tags$iframe(style="height:500px; width: 800px",
                               src="https://dssg-pathways.shinyapps.io/ExperimentingWithForms/")))
     )#mainPanel
  
)#sidebarLayout
)#ui <- fluidPage