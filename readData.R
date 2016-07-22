###########################################################################################
###------------------------------------------DATA---------------------------------------###
###########################################################################################
library(raster)
library("googlesheets")
library("ggmap")

data_folder <- paste(getwd(), 'data', sep='/')

# Read Updated Apartments from Google Sheets


# Grab the Google Sheet
sheet_url <- "https://docs.google.com/spreadsheets/d/1IrpR8SMU_LMM6RHuF2AuwX-bg3JUudRvNr6Wnt858dc/pub?output=csv"
sheet <- gs_url(sheet_url)
# Read the data
sheet_data <- gs_read_csv(sheet)
sheet_data

# Now figure out if multiple apartments have been added by checking the length of sheet_data
num_apt = dim(sheet_data)[1] # this is the number of entries per column
#num_col = dim(sheet_data)[2] # this is the number of columns [they remain constant]

# Declare empty data frame
apartments <- data.frame(matrix(vector(), 0, 9,
                               dimnames=list(c(), c("apartment_name","latitude","longitude",
                                                    "place_id",	"zipcode", "website",	"property_address",	"map_url",	"phone"))),
                        stringsAsFactors=FALSE)
row_to_write <- data.frame(matrix(vector(), 0, 9, dimnames=list(c(), c("apartment_name","latitude","longitude",
                                                    "place_id",	"zipcode", "website",	"property_address",	"map_url",	"phone"))),
                           stringsAsFactors=FALSE)

if (num_apt > 1) {
  for (i in 2:num_apt){
    
    # Access the address - it is guaranteed to be there as it was mandatory field
    apt_address <- sheet_data$address[i]
    
    # Geocode address -
    lat_long <- geocode(apt_address)
    lat <- lat_long$lat
    lon <- lat_long$lon
    
    # Append the whole line to the Apartments csv file
    # These are the fields in the CSV: apartment_name,latitude,longitude
    # place_id,	zipcode, website,	property_address,	map_url,	phone
    row_to_write <- rbind(row_to_write, c(sheet_data$name[i], lat, lon, "", "",
                      sheet_data$website[i], sheet_data$address[i], "", sheet_data$phone[i]), 
                      stringsAsFactors=FALSE)
    colnames(row_to_write) <- c("apartment_name","latitude","longitude", "place_id",	
                                "zipcode", "website",	"property_address",	"map_url",	"phone")
    
    apartments <- rbind(apartments, row_to_write)
  }
  to_write <- unique(apartments)
  Apartments_initial <- read.csv(paste(data_folder, 'apartment_complexes.csv', sep='/'), header = TRUE, sep = ",", stringsAsFactors=FALSE)
  # Concatenate the new additions and existing apartments - and extract unique rows from there
  Apartments_tmp <- rbind(Apartments_initial,to_write)
  Apartments <- unique(Apartments_tmp)
} else {
  Apartments <- read.csv(paste(data_folder, 'apartment_complexes.csv', sep='/'), header = TRUE, sep = ',', stringsAsFactors=FALSE)
}

schools <- read.csv( paste(data_folder, 'Schools.csv', sep='/'), header = TRUE, sep = "," )
TStops <- read.csv( paste(data_folder, 'TStops.csv', sep='/'), header = TRUE, sep = "," ) 
Aff <- readOGR(paste(data_folder), "Af_New" )
Markets <- read.csv( paste(data_folder, 'grocery_stores.csv', sep='/'), header = TRUE, sep = "," )
Faith <- read.csv( paste(data_folder, 'places_of_worship.csv', sep='/'), header = TRUE, sep = "," )
SSNs <- read.csv(paste(data_folder, 'SSN_offices.csv', sep = '/'), header = TRUE, sep = ",")
DDS <- read.csv(paste(data_folder, 'department_of_driver_services.csv', sep = '/'), header = TRUE, sep = ",")
DFACs <- read.csv(paste(data_folder, 'DFACS.csv', sep = '/'), header = TRUE, sep = ",")
ESL <- read.csv(paste(data_folder, 'ESL.csv', sep = '/'), header = TRUE, sep = ",")
Rent <- readOGR(paste(data_folder), "Filtered_Rent" )
Hospitals <- read.csv(paste(data_folder, 'primary_care_locations.csv', sep = '/'), header = TRUE, sep = ",")
Daycares <- read.csv(paste(data_folder, 'day_care_centers.csv', sep = '/'), header = TRUE, sep = ",")
To_NAP_Office <- read.csv(paste(data_folder, 'to_NAP_office.csv', sep = '/'), header = TRUE, sep = ",")
Times <- read.csv(paste(data_folder, 'Times.csv', sep = '/'), header = TRUE, sep = ",")
Apartments <- merge(x = Apartments, y = To_NAP_Office, by.x="place_id", by.y="origin_place_id", all.x=TRUE)

raster_file <- paste(data_folder, "Crimeclip1.tif", sep = "/")
Crime <- raster(raster_file)
index <- read.csv(paste(data_folder, 'index.csv', sep = '/'), header = TRUE, sep = ",")
