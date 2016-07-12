#Read in Packages
source("./libraries.R")

#Read in data files
source("./readData.R")

#Set Color Palettes
source("./set_color_palletes.R")

#Add in the icons
source("./makeIcons.R")

#Shiny User Interface
source("./gui_side.R")

#Shiny Server
source("./server_side.R")

shinyApp(ui = ui, server = server)
