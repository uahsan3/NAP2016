###########################################################################################
###------------------------------------------DATA---------------------------------------###
###########################################################################################
library(raster)

data_folder <- paste(getwd(), 'data', sep = '/')

Apartments <-
  read.csv(paste(data_folder, 'Apartments.csv', sep = '/'), header = TRUE, sep = ",")
schools <-
  read.csv(paste(data_folder, 'Schools.csv', sep = '/'), header = TRUE, sep = ",")
TStops <-
  read.csv(paste(data_folder, 'TStops.csv', sep = '/'), header = TRUE, sep = ",")
Aff <- readOGR(paste(data_folder), "Af_New")
Markets <-
  read.csv(paste(data_folder, 'grocery.csv', sep = '/'), header = TRUE, sep = ",")
Faith <-
  read.csv(paste(data_folder, 'Faith.csv', sep = '/'), header = TRUE, sep = ",")
SSNs <-
  read.csv(paste(data_folder, 'SSN.csv', sep = '/'), header = TRUE, sep = ",")
DDS <-
  read.csv(paste(data_folder, 'DDS.csv', sep = '/'), header = TRUE, sep = ",")
DFACs <-
  read.csv(paste(data_folder, 'DFACS.csv', sep = '/'), header = TRUE, sep = ",")
ESL <-
  read.csv(paste(data_folder, 'ESL.csv', sep = '/'), header = TRUE, sep = ",")
Rent <- readOGR(paste(data_folder), "Filtered_Rent")
Hospitals <-
  read.csv(paste(data_folder, 'Hospitals.csv', sep = '/'), header = TRUE, sep = ",")

To_NAP_Office <-
  read.csv(
    paste(data_folder, 'to_NAP_office.csv', sep = '/'), header = TRUE, sep = ","
  )

Apartments <-
  merge(x = Apartments, y = To_NAP_Office, by.x = "place_id", by.y = "origin_place_id")

raster_file <- paste(data_folder, "Crimeclip1.tif", sep = "/")
Crime <- raster(raster_file)

index <- read.csv(paste(data_folder, 'index.csv', sep = '/'), header = TRUE, sep = ",")

