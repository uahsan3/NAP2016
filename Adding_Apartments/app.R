# The issue of oauth error got solved by solution posted here: 
#https://github.com/jennybc/googlesheets/issues/235 - essentially don't "Publish" .. just 
# run the command rsconnect::deployApp()

library("googlesheets")
library("ggmap")

# Which fields are mandatory
fieldsMandatory <- c("name", "address")
appCSS <-
  ".mandatory_star { color: red; }
#error { color: red; }"

labelMandatory <- function(label) {
  tagList(
    label,
    span("*", class = "mandatory_star")
  )
}

# which fields are saved
fieldsAll <- c("name", "address", "phone", "website", "rent")

# directory where all responses are saved
responsesDir <- file.path("responses")

# get current Epoch time
epochTime <- function() {
  as.integer(Sys.time())
}

# get a formatted string of the timestamp (exclude colons as they are invalid
# characters in Windows filenames)
humanTime <- function() {
  format(Sys.time(), "%Y%m%d-%H%M%OS")
}

#save the data - keep filename concatenation of timestamp + md5 checksum of response
# saveData <- function(data) {
#   fileName <- sprintf("%s_%s.csv",
#                       humanTime(),
#                       digest::digest(data))
#   
#   write.csv(x = data, file = file.path(responsesDir, fileName),
#             row.names = FALSE, quote = TRUE)
# }

# save the data using googlesheets
# I have already made a public Google Sheets spreadsheet and populated it with one entry 
# (this is necessary for this functionality to work)

saveData <- function(data) {
  # Grab the Google Sheet
  sheet_url <- "https://docs.google.com/spreadsheets/d/1IrpR8SMU_LMM6RHuF2AuwX-bg3JUudRvNr6Wnt858dc/pub?output=csv"
  sheet <- gs_url(sheet_url)
  
  # Add the data as a new row
  gs_add_row(sheet, input = data)
}

loadData <- function() {
  # Grab the Google Sheet
  sheet_url <- "https://docs.google.com/spreadsheets/d/1IrpR8SMU_LMM6RHuF2AuwX-bg3JUudRvNr6Wnt858dc/pub?output=csv"
  sheet <- gs_url(sheet_url)
  # Read the data
  sheet_data <- gs_read_csv(sheet)
  sheet_data
}

shinyApp(
  ui = fluidPage(
    titlePanel("Add a New Apartment to the Map"),
    #install.packages("shinyjs")
    shinyjs::useShinyjs(),
    shinyjs::inlineCSS(appCSS),
    div(
      id = "form",
      
      textInput("name", labelMandatory("Apartment Name"), ""),
      textInput("address", labelMandatory("Apartment Address")),
      textInput("phone", "Apartment Phone"),
      textInput("website", "Apartment Website"),
      sliderInput("rent", "Average Rent (if known)", 500, 2000, 500, 250, ticks = FALSE),
      #selectInput("os_type", "Operating system used most frequently",
       #           c("",  "Windows", "Mac", "Linux")),
      actionButton("submit", "Submit", class = "btn-primary"),
      
      
      # Showing status of submitting
      shinyjs::hidden(
        span(id = "submit_msg", "Submitting..."),
        div(id = "error",
            div(br(), tags$b("Error: "), span(id = "error_msg"))
        )
      )
    ),
    
    # Thank you message after form is submitted
    shinyjs::hidden(
      div(
        id = "thankyou_msg",
        h3("Thanks, your response was submitted successfully!"),
        actionLink("submit_another", "Submit another response")
      )
    )  
    
  ),
  server = function(input, output, session) {
    observe({
      # check if all mandatory fields have a value
      mandatoryFilled <-
        vapply(fieldsMandatory,
               function(x) {
                 !is.null(input[[x]]) && input[[x]] != ""
               },
               logical(1))
      mandatoryFilled <- all(mandatoryFilled)
      
      # enable/disable the submit button
      shinyjs::toggleState(id = "submit", condition = mandatoryFilled)
    })
      
      # Gather all the form inputs (and add timestamp)
      formData <- reactive({
        data <- sapply(fieldsAll, function(x) input[[x]])
        data <- c(data, timestamp = epochTime())
        data <- t(data)
        data
      })
      
      # action to take when submit button is pressed
      observeEvent(input$submit, {
        shinyjs::disable("submit")
        shinyjs::show("submit_msg")
        shinyjs::hide("error")
        #source('readData.R')
        
        tryCatch({
          saveData(formData())
          shinyjs::reset("form")
          shinyjs::hide("form")
          shinyjs::show("thankyou_msg")
        },
        # error = function(err) {
        #   shinyjs::text("error_msg", err$message)
        #   shinyjs::show(id = "error", anim = TRUE, animType = "fade")
        # },
        finally = {
          shinyjs::enable("submit")
          shinyjs::hide("submit_msg")
        })
        
        
        
      })
        
      # When user presses the submit another form button
      observeEvent(input$submit_another, {
        shinyjs::show("form")
        shinyjs::hide("thankyou_msg")
      }) 
  }
)

