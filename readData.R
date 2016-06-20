###########################################################################################
###------------------------------------------DATA---------------------------------------###
###########################################################################################

data_folder <- paste(getwd(), 'data', sep='/')

Apartments <- read.csv( paste(data_folder, 'Apartments.csv', sep='/'), header = TRUE, sep = "," ) 
schools <- read.csv( paste(data_folder, 'Schools.csv', sep='/'), header = TRUE, sep = "," )
TStops <- read.csv( paste(data_folder, 'TStops.csv', sep='/'), header = TRUE, sep = "," ) 
Aff <- readOGR(paste(data_folder), "Af_New" )
Markets <- read.csv( paste(data_folder, 'Markets.csv', sep='/'), header = TRUE, sep = "," )
Faith <- read.csv( paste(data_folder, 'Faith.csv', sep='/'), header = TRUE, sep = "," )